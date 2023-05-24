import 'dart:async';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:plantripapp/auth/login_screen.dart';
import 'package:plantripapp/chat/chat_list_screen.dart';
import 'package:plantripapp/components/foldable_sidebar.dart';
import 'package:plantripapp/core/message_translation.dart';
import 'package:plantripapp/core/my_pref.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/models/city_category_model.dart';
import 'package:plantripapp/models/post_model.dart';
import 'package:plantripapp/models/user_model.dart';
import 'package:plantripapp/pages/mycard_page.dart';
import 'package:plantripapp/pages/notif_page.dart';
import 'package:plantripapp/screens/happening_screen.dart';
import 'package:plantripapp/screens/home_screen.dart';
import 'package:plantripapp/screens/plan_screen.dart';
import 'package:plantripapp/screens/profile_screen.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/custom_drawer.dart';
import 'package:plantripapp/widgets/funky_notification.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  try {
    await Firebase.initializeApp();
    debugPrint('Handling a background message ${message.messageId}');
    //if (message.messageId != null && message.messageId != '') {}

    await GetStorage.init(nmStorage);

    Get.lazyPut<MyPref>(() => MyPref.instance);
    Get.lazyPut<XController>(() => XController());

    final XController x = XController.to;
    x.notificationFCMManager.setMyPref(MyPref.to);
    x.asyncLatitude();
    x.asyncHome();
  } catch (e) {
    debugPrint("Error _firebaseMessagingBackgroundHandler: ${e.toString()}");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  await Firebase.initializeApp();
  await GetStorage.init(nmStorage);

  Get.lazyPut<MyPref>(() => MyPref.instance);
  Get.lazyPut<XController>(() => XController());

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) {
    final XController x = XController.to;
    x.notificationFCMManager.setMyPref(MyPref.to);

    Future.microtask(() => MyTheme.setAppTheme());

    Future.delayed(const Duration(milliseconds: 500), () {
      XController.to.asyncLatitude();
      x.asyncHome();
    });

    Future.delayed(const Duration(milliseconds: 2200), () {
      XController.to.asyncLatitude();
      XController.to.asyncHome();
    });

    //interval for next 22 minutes
    Timer.periodic(const Duration(minutes: 22), (timer) {
      x.asyncLatitude();
      x.asyncHome();
    });

    return runApp(const MyApp());
  });

  //configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final XController x = XController.to;

    debugPrint("check isLoggedIn ${x.isLoggedIn.value}");

    String lang = "en";
    try {
      lang = x.getLangName().toLowerCase();
    } catch (e) {
      debugPrint("check Lang $lang error ${e.toString()}");
    }
    Locale locale =
        lang == 'id' ? const Locale('id', 'ID') : const Locale('en', 'US');

    final bool isLogin = x.isLoggedIn.value;

    debugPrint("check isLogin $isLogin");

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      customTransition: SizeTransitions(),
      translations: MessagesTranslation(),
      locale: locale,
      fallbackLocale: const Locale('en', 'US'),
      title: appName,
      theme: MyTheme.light,
      darkTheme: MyTheme.dark,
      themeMode: ThemeService().theme,
      home: isLogin ? MyHomePage() : LoginScreen(),
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final drawerStatus = FSBStatus.fSBCLOSE.obs;
  final _index = 0.obs;

  MyHomePage({Key? key}) : super(key: key);
  final isRefreshing = false.obs;

  @override
  Widget build(BuildContext context) {
    final XController x = XController.to;

    return WillPopScope(
      onWillPop: () => onBackPress(),
      child: Scaffold(
        body: Obx(
          () => FoldableSidebarBuilder(
            drawerBackgroundColor: Get.theme.backgroundColor,
            drawer: CustomDrawer(
              closeDrawer: () {
                drawerStatus.value = FSBStatus.fSBCLOSE;
              },
              goMenu: (index) {
                drawerStatus.value = FSBStatus.fSBCLOSE;

                if (index == 5) {
                  Get.to(ChatListScreen());
                } else if (index == 6) {
                  Get.to(MyCardPage());
                } else if (index == 7) {
                  Get.to(NotifPage());
                } else if (index > -1) {
                  _index.value = index;
                }
              },
            ),
            screenContents: GestureDetector(
              onTap: () {
                drawerStatus.value = FSBStatus.fSBCLOSE;
              },
              onDoubleTap: () {
                drawerStatus.value = FSBStatus.fSBCLOSE;
              },
              onLongPress: () {
                drawerStatus.value = FSBStatus.fSBCLOSE;
              },
              child: _buildScreens(
                x,
                _index.value,
                x.isDarkMode.value,
                isRefreshing.value,
              )[_index.value],
            ),
            status: drawerStatus.value,
          ),
        ),
        bottomNavigationBar: Obx(
          () => Container(
            width: Get.width,
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: createItemBottom(x, x.thisUser.value, x.isDarkMode.value),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Obx(
          () => FloatingActionButton(
            //elevation: 10,
            backgroundColor:
                x.isDarkMode.value ? Get.theme.primaryColorLight : accentColor,
            onPressed: () {
              debugPrint("center button clicked...");
              PlanScreen.showDialogAddNewPlaceArticle(
                x,
                "add_new_place".tr,
                (result) {
                  if (result != null) {
                    if (result['success'] != null && result['success'] == '1') {
                      isRefreshing.value = true;

                      Future.microtask(
                        () => x.addMorePost(
                          PostModel(
                            id: "0",
                            title: result['title'],
                            desc: result['description'],
                            idCategory: "${result['category']}",
                            idCity: "${result['city']}",
                            idUser: x.thisUser.value.id,
                            liked: 0,
                            rating: 0,
                            tag: result['tag'],
                            flag: int.parse(result['flag'] ?? "0"),
                            status: 1,
                            createAt: MyTheme.timeStampNow(),
                            updateAt: MyTheme.timeStampNow(),
                            latitude: x.latitude,
                            location: x.location,
                            totalComment: 0,
                            totalLike: 0,
                            totalRating: 0,
                            totalReport: 0,
                            totalShare: 0,
                            totalView: 1,
                            totalUser: 1,
                            image1: result['image1'] ?? '',
                            image2: result['image2'] ?? '',
                            image3: result['image3'] ?? '',
                            user: UserModel(
                              id: x.thisUser.value.id,
                              fullname: x.thisUser.value.fullname,
                              image: x.thisUser.value.image,
                              username: x.thisUser.value.username,
                            ),
                          ),
                        ),
                      );

                      Future.delayed(const Duration(milliseconds: 3500), () {
                        isRefreshing.value = false;
                        debugPrint(result.toString());
                      });
                    }
                  }
                },
              );
            },
            tooltip: 'Make a new post',
            child: Material(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(120)),
                child: Image.asset(
                  "assets/icon_tranparent.png",
                  width: 70,
                  height: 70,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //static function
  static pushLikeOrDislike(final XController x, final PostModel? post,
      final CityCategoryModel? cityCateg, final bool isLiked) {
    if (isLiked) {
      Future.delayed(const Duration(milliseconds: 10), () {
        x.likeOrDislike(post!.id, 'like');
      });
    } else {
      Future.delayed(const Duration(milliseconds: 10), () {
        x.likeOrDislike(post!.id, 'dislike');
      });
    }

    const int duration = 2000;
    final overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return FunkyNotification(
          text: isLiked ? "Bookmark!" : "Remove!",
          backgroundColor: isLiked ? Get.theme.primaryColor : Colors.grey[600],
          duration: duration - 400,
        );
      },
    );
    final overlayState = Navigator.of(Get.context!).overlay;
    overlayState!.insert(overlayEntry);

    Future.delayed(const Duration(milliseconds: duration), () {
      overlayEntry.remove();
    });
  }

  final _channel =
      const MethodChannel('com.erhacorpdotcom.plantripapp/app_retain');
  Future<bool> onBackPress() {
    debugPrint("onBackPress MyHome...");
    if (GetPlatform.isAndroid) {
      if (Navigator.of(Get.context!).canPop()) {
        return Future.value(true);
      } else {
        _channel.invokeMethod('sendToBackground');
        return Future.value(false);
      }
    } else {
      return Future.value(true);
    }
  }

  Widget createItemBottom(
      final XController x, final UserModel thisUser, final bool isDark) {
    debugPrint("isDark $isDark");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: DotNavigationBar(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        enableFloatingNavBar: false,
        itemPadding: const EdgeInsets.symmetric(horizontal: 15),
        currentIndex: _index.value,
        duration: const Duration(milliseconds: 1200),
        backgroundColor: Get.theme.backgroundColor,
        onTap: (idx) {
          if (idx == 2) {
            _index.value = 0;
          } else {
            _index.value = idx;
          }
          drawerStatus.value = FSBStatus.fSBCLOSE;
        },

        // dotIndicatorColor: Colors.black,
        items: [
          /// Home
          DotNavigationBarItem(
            icon: const Icon(BootstrapIcons.house, size: iconSize),
            selectedColor: primaryColor,
          ),

          /// happening
          DotNavigationBarItem(
            icon: const Padding(
              padding: EdgeInsets.only(right: 0),
              child: Icon(BootstrapIcons.check2_square, size: iconSize),
            ),
            selectedColor: primaryColor,
          ),

          /// Search
          DotNavigationBarItem(
            icon: const Padding(
              padding: EdgeInsets.only(left: 0),
              child: SizedBox.shrink(),
              // Icon(BootstrapIcons.plus_circle, size: 25),
            ),
            selectedColor: Colors.transparent,
          ),

          /// Search
          DotNavigationBarItem(
            icon: const Padding(
              padding: EdgeInsets.only(left: 0),
              child: Icon(BootstrapIcons.stickies, size: iconSize),
            ),
            selectedColor: primaryColor,
          ),

          /// Profile
          DotNavigationBarItem(
            icon: Obx(
              () => ClipOval(
                child: ExtendedImage.network(
                  x.photoUser.value,
                  width: 24,
                  height: 24,
                  fit: BoxFit.cover,
                ),
              ),
            ), //const Icon(BootstrapIcons.person_circle, size: 22),
            selectedColor: primaryColor,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildScreens(final XController x, final int selectedBottom,
      final bool isDark, final bool isUploading) {
    return [
      HomeScreen(
        callback: () {
          drawerStatus.value = drawerStatus.value == FSBStatus.fSBOPEN
              ? FSBStatus.fSBCLOSE
              : FSBStatus.fSBOPEN;
        },
        isUploading: isUploading,
      ),
      HappeningScreen(),
      const SizedBox(child: Text("")),
      PlanScreen(), // icon number 4 (myplan/chat) widget screen
      ProfileScreen(),
    ];
  }
}

class SizeTransitions extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext? context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return Align(
      alignment: Alignment.center,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animation,
          curve: curve!,
        ),
        child: child,
      ),
    );
  }
}
