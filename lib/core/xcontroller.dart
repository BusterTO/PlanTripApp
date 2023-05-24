import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plantripapp/chat/chat_app.dart';
import 'package:plantripapp/chat/controller/chat_controller.dart';
import 'package:plantripapp/chat/models/chat_user.dart';
import 'package:plantripapp/chat/models/userchat.dart';
import 'package:plantripapp/core/ads_helper.dart';
import 'package:plantripapp/core/firebase_auth_service.dart';
import 'package:plantripapp/core/get_location.dart';
import 'package:plantripapp/core/my_pref.dart';
import 'package:plantripapp/core/notification_fcm_manager.dart';
import 'package:plantripapp/core/provider/all_provider.dart';
import 'package:plantripapp/core/xcontroller_addon.dart';
import 'package:plantripapp/main.dart';
import 'package:plantripapp/models/category_model.dart';
import 'package:plantripapp/models/city_category_model.dart';
import 'package:plantripapp/models/city_model.dart';
import 'package:plantripapp/models/follow_model.dart';
import 'package:plantripapp/models/liked_model.dart';
import 'package:plantripapp/models/myplan_model.dart';
import 'package:plantripapp/models/notif_model.dart';
import 'package:plantripapp/models/post_model.dart';
import 'package:plantripapp/models/slide_model.dart';
import 'package:plantripapp/models/user_model.dart';
import 'package:plantripapp/theme.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class XController extends GetxController {
  static XController get to => Get.find<XController>();
  final myPref = Get.find<MyPref>();

  final AllProvider _provider = AllProvider();
  AllProvider get provider => _provider;

  final NotificationFCMManager notificationFCMManager =
      NotificationFCMManager.instance;

  final GetLocation geoLocation = GetLocation.instance;

  final AdsHelper _adsHelper = AdsHelper.instance;
  AdsHelper get adsHelper => _adsHelper;

  final isDarkMode = false.obs;
  setThemeValue(bool isDark) {
    isDarkMode.value = isDark;
  }

  final isLoggedIn = false.obs;
  setLogin(final bool isLogin) {
    isLoggedIn.value = isLogin;
    myPref.pLogin.val = isLogin;
  }

  setDefaultLocale() {
    String lang = getLangName();
    String locale = lang == 'id' ? 'id_ID' : 'en_US';
    initializeDateFormatting(locale, null);
    Intl.defaultLocale = locale;
  }

  String getLangName() {
    String langName = myPref.pLang.val;
    return langName;
  }

  @override
  void onInit() {
    isDarkMode.value = myPref.pTheme.val;
    isLoggedIn.value = myPref.pLogin.val;
    update();

    notificationFCMManager.setMyPref(myPref);

    setDefaultLocale();

    final uuid = myPref.pUUID; // ?? Uuid().v1();
    if (uuid.val == '') {
      uuid.val = const Uuid().v1();
    }

    thisUuid.value = myPref.pUUID.val;
    debugPrint("UUID: ${thisUuid.value}");

    isLogin();

    asyncLatitude();

    super.onInit();
  }

  asyncLatitude() async {
    try {
      await geoLocation.init();
      _latitude = geoLocation.latitude;
      _location = (latitude != '') ? geoLocation.shortAddr : "";
      asyncUuidToken();
    } catch (e) {
      debugPrint("Error asyncLatitude ${e.toString()}");
    }
  }

  final memberMap = <String, dynamic>{}.obs;

  double? getOriginLat() {
    try {
      return double.parse(latitude.split(",")[0]);
    } catch (e) {
      return 1.3089153;
    }
  }

  double? getOriginLon() {
    try {
      return double.parse(latitude.split(",")[1]);
    } catch (e) {
      return 103.7600613;
    }
  }

  //paging limit
  final pagingLimit = pageLimit.obs;
  updateLimitPage(String nextPage) {
    pagingLimit.value = nextPage;
    update();
  }

  clearLimitPage() {
    pagingLimit.value = pageLimit;
    update();
  }
  //paging limit

  bool isLogin() {
    bool login = myPref.pLogin.val;
    isLoggedIn.value = login;
    String getMember = myPref.pMember.val;

    //debugPrint(getMember);
    if (getMember != '') {
      memberMap.value = jsonDecode(getMember);
      update();
      //debugPrint(member);

      setUserLogin();
      update();
    } else {
      _thisUserFirebase = null;
      userLogin.update((val) {
        val!.user = null;
        val.isLogin = false;
        val.status = 0;
      });
    }

    return login;
  }

  final thisUser = UserModel().obs;
  final photoUser = ''.obs;
  setUserLogin() {
    //debugPrint("setUserLogin.... ");
    try {
      //debugPrint(memberMap.toString());
      if (memberMap['id_user'] != null && memberMap['id_user'] != '') {
        thisUser.value = UserModel.fromJson(memberMap);

        if (isLoggedIn.value) {
          try {
            photoUser.value = thisUser.value.image!;
          } catch (e) {
            debugPrint(e.toString());
          }
          setUserFirebase();
        }
      }
    } catch (e) {
      debugPrint("Error: setUserLogin: ${e.toString()}");
    }
  }

  //chat utility
  setUserFirebase() async {
    //debugPrint("setUserFirebase...");
    try {
      FirebaseAuthService fauth = notificationFCMManager.firebaseAuthService;
      String? uid = await fauth.getFirebaseUserId();

      if (uid != null) {
        _thisUserFirebase = fauth.firebaseUser;

        debugPrint("get setUserFirebase: ${thisUserFirebase!.uid}");
        if (_thisUserFirebase != null && thisUserFirebase!.uid != '') {
          initChatController();
        }
      }
    } catch (e) {
      debugPrint("Error: setUserFirebase $e");
    }
  }

  final itemChatScreen = ItemChatUser().obs;

  gotoChatApp(UserChat peer) {
    debugPrint("gotoChatApp... ");
    debugPrint(userLogin.value.userChat.toString());

    if (userLogin.value.userChat == null ||
        userLogin.value.userChat!.id!.isEmpty) {
      EasyLoading.showToast("User login offline");
      return;
    }

    itemChatScreen.update((val) {
      val!.user = userLogin.value.user;
      val.peer = peer;
      val.groupChatId =
          generateGroupChatId(userLogin.value.userChat!.id, peer.id);
    });

    Get.to(ChatApp(userChat: peer));
  }

  final ChatController _chatController = ChatController.instance;
  ChatController get chatController => _chatController;

  User? _thisUserFirebase;
  User? get thisUserFirebase => _thisUserFirebase;

  final textToSend = "".obs;

  bool getReadyToSend() {
    String text = textToSend.value.trim();
    if (text.isEmpty || text == '' || text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  String generateGroupChatId(id, peerId) {
    String groupChatId = '$peerId-$id';
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    }
    return groupChatId;
  }

  //startChatWith(String uid, String peerId) {}

  final userLogin = UserLogin().obs;
  getUserChatById(String id) {
    //debugPrint("getUserChatById ID: $id");

    try {
      return userLogin.value.userChats!
          .firstWhere((userChat) => id == userChat.id);
    } catch (e) {
      debugPrint("Error getUserChatById $e");
    }

    return null;
  }

  initChatController() async {
    debugPrint("initChatController: is runnning...");
    try {
      if (isLoggedIn.value) {
        userLogin.update((val) {
          val!.user = thisUserFirebase;
          val.isLogin = true;
          val.status = 1;
        });

        if (_thisUserFirebase != null && thisUserFirebase!.uid != '') {
          await setUserFirebaseAsync();
          await chatController.checkUserExistOrNot(
              this, thisUserFirebase, thisUser.value);
        }

        notificationFCMManager.firebaseAuthService.listenUserChange();
      } else {
        userLogin.update((val) {
          val!.user = null;
          val.isLogin = false;
          val.status = 0;
        });
      }
    } catch (e) {
      debugPrint("Error initChatController: $e");
    }
  }

  setUserFirebaseAsync() async {
    //debugPrint("uid: ${thisUserFirebase.uid}");
    try {
      await chatController.setUserLoginFirebaseById(
          this, thisUserFirebase!.uid);
    } catch (e) {
      debugPrint("Error setUserfirebaseAsync");
    }
  }

  getAllUserFirebase() {
    chatController.getAllUserChatFirebase(this, thisUser.value);
  }

  bool onProcessAsyncChat = false;
  asyncUserChat() async {
    if (onProcessAsyncChat) return;

    onProcessAsyncChat = true;
    Future.delayed(const Duration(seconds: 5), () {
      onProcessAsyncChat = false;
    });

    await chatController.checkUserExistOrNot(
        this, thisUserFirebase, thisUser.value);
  }

  final itemChat = ChatUserModel().obs;
  final chatState = ChatState.done.obs;

  sendMessage(String content, int type) async {
    chatState.value = ChatState.loading;
    update();

    textToSend.value = '';
    update();
  }

  closeMessage() {
    myPref.pOnChatScreen.val = "";
  }

  updateChattingWith(String uid, String peerId) {
    UserModel member = thisUser.value;
    chatController.firestore
        .collection(ChatController.tAGUSERCHAT)
        .doc(uid)
        .update({
      'chattingWith': peerId,
      'nickname': member.fullname ?? "",
      'photoUrl': member.image ?? "",
      'aboutMe': member.about ?? "",
      'updatedAt': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  clearBufferChat() {
    debugPrint("clearBufferChat .. running...");
    closeMessage();
  }

  sendNotifToRecipient(dynamic map) async {
    var dataPush = {"token": map['token'], "data": map};

    _provider.pushResponse('user/push_fcm', jsonEncode(dataPush));
  }
  //chat utility

  saveTokenFCM(String token) {
    myPref.pTokenFCM.val = token;

    asyncUuidToken();
  }

  String? _latitude;
  String get latitude => _latitude ?? "";
  String setLatitude(String lat) => _latitude = lat;

  String? _location;
  String get location => _location ?? "";
  String setLocation(String loc) => _location = loc;

  final thisUuid = ''.obs;
  final install = <String, dynamic>{}.obs;
  final isProcessAsycnToken = false.obs;

  asyncUuidToken() async {
    debugPrint("asyncUuidToken is running.. ");
    if (isProcessAsycnToken.value) return;

    isProcessAsycnToken.value = true;
    Future.delayed(const Duration(milliseconds: 2200), () {
      isProcessAsycnToken.value = false;
    });

    try {
      String? getInstall = myPref.pInstall.val;
      if (getInstall != '') {
        install.value = jsonDecode(getInstall);
      }

      final jsonBody = jsonEncode({
        "id": install['id_install'] ?? "",
        "lat": latitude,
        "loc": location,
        "uuid": thisUuid.value,
        "os": GetPlatform.isAndroid ? "Android" : "iOS",
        "tk": getTokenFCM(),
      });
      debugPrint(jsonBody);

      provider.pushResponse('install/saveUpdate', jsonBody)!.then(
        (response) {
          //debugPrint(response!.statusCode.toString());

          if (response != null && response.statusCode == 200) {
            //debugPrint(response.bodyString);
            dynamic dataresult = jsonDecode(response.bodyString!);
            if (dataresult['result'] != null &&
                dataresult['result'].length > 0) {
              dynamic installRow = dataresult['result'][0];
              //debugPrint(installRow);
              myPref.pInstall.val = jsonEncode(installRow);
              install.value = installRow;
            }

            //debugPrint(dataresult);
          }
        },
      );
    } catch (e) {
      debugPrint("Error asyncUuidToken ${e.toString()}");
    }
  }

  String getCountry() {
    return myPref.pCountry.val;
  }

  getTokenFCM() {
    return myPref.pTokenFCM.val;
  }

  signOut() async {
    await notificationFCMManager.firebaseAuthService.signOut();
    myPref.pMember.val = '';
    saveLogin(false);
  }

  saveLogin(bool login) {
    myPref.pLogin.val = login;
    isLoggedIn.value = isLogin();
  }

  final isProcessAsyncHome = false.obs;
  final itemHome = ItemReponse().obs;
  asyncHome() {
    if (isProcessAsyncHome.value) return;
    isProcessAsyncHome.value = true;

    Future.delayed(const Duration(milliseconds: 2200), () {
      isProcessAsyncHome.value = false;
    });

    getUserById();

    itemHome.update((val) {
      val!.posts = itemHome.value.nearbys;
    });

    getAllLocalVariables();

    try {
      String idUser = "";
      String limitTop = pageLimit;
      String jsonBody = "";

      try {
        idUser = thisUser.value.id ?? "";

        String idInstall = "";
        String? getInstall = myPref.pInstall.val;

        try {
          if (getInstall != '') {
            install.value = jsonDecode(getInstall);
            idInstall = install['id_install'] ?? "";
          }
        } catch (e) {
          debugPrint("Errror12121 ${e.toString()}");
        }

        jsonBody = jsonEncode({
          "id": idInstall,
          "iu": idUser,
          "lt": limitTop,
          "lat": latitude,
          "loc": location,
          "uuid": thisUuid.value,
          "os": GetPlatform.isAndroid ? "Android" : "iOS",
          "tk": getTokenFCM(),
        });
        debugPrint(jsonBody);
      } catch (e) {
        debugPrint("Error asyncHome install first: ${e.toString()}");
      }

      var linkAPI = 'api?lt=$limitTop&iu=$idUser&lat=$latitude';
      debugPrint("LinkAPI: $linkAPI");

      provider.pushResponse(linkAPI, jsonBody)!.then(
        (response) {
          debugPrint("fetch response api home....");
          //debugPrint(response!.statusCode.toString());

          if (response != null && response.statusCode == 200) {
            //debugPrint(response.bodyString);
            String respString = response.bodyString!;
            dynamic dataresult = jsonDecode(respString);
            if (dataresult['result'] != null &&
                dataresult['result'].length > 0) {
              myPref.pHome.val = respString;
              getAllLocalVariables();
            }

            //debugPrint(dataresult);
          }
        },
      );
    } catch (e) {
      debugPrint("Error asyncHome: ${e.toString()}");
    }
  }

  getAllLocalVariables() {
    try {
      String? dataHome = myPref.pHome.val;
      if (dataHome != '') {
        Map<String, dynamic> dataresult = jsonDecode(dataHome);
        if (dataresult['result'] != null && dataresult['result'].length > 0) {
          debugPrint('fetching getAllLocalVariables...');

          //category
          List<dynamic>? categs = dataresult['result']['category'];
          List<CategoryModel> dataCategories = [];
          if (categs != null && categs.isNotEmpty) {
            for (dynamic e in categs) {
              //debugPrint(e.toString());
              try {
                dataCategories.add(CategoryModel.fromMap(e));
              } catch (e) {
                debugPrint("Error99999 ${e.toString()}");
              }
            }
          }

          //city_category
          List<dynamic>? cityCategs = dataresult['result']['city_category'];
          List<CityCategoryModel> dataCityCategories = [];
          if (cityCategs != null && cityCategs.isNotEmpty) {
            for (dynamic e in cityCategs) {
              //debugPrint(e.toString());
              try {
                dataCityCategories.add(CityCategoryModel.fromMap(e));
              } catch (e) {
                debugPrint("Error11111 ${e.toString()}");
              }
            }
          }

          //slider
          List<dynamic>? sliders = dataresult['result']['slide'];
          List<SlideModel> dataSliders = [];
          if (sliders != null && sliders.isNotEmpty) {
            for (dynamic e in sliders) {
              //debugPrint(e.toString());
              try {
                dataSliders.add(SlideModel.fromMap(e));
              } catch (e) {
                debugPrint("Error22222 ${e.toString()}");
              }
            }
          }

          //cities
          List<dynamic>? cities = dataresult['result']['city'];
          List<CityModel> dataCities = [];
          if (cities != null && cities.isNotEmpty) {
            for (dynamic e in cities) {
              //debugPrint(e.toString());
              try {
                dataCities.add(CityModel.fromMap(e));
              } catch (e) {
                debugPrint("Error33333 ${e.toString()}");
              }
            }
          }

          List<PostModel> allPosts = [];
          //posts
          List<dynamic>? posts = dataresult['result']['post']['data'];
          List<PostModel> dataPosts = [];
          if (posts != null && posts.isNotEmpty) {
            for (dynamic e in posts) {
              //debugPrint(e.toString());
              try {
                PostModel p = PostModel.fromMap(e);
                dataPosts.add(p);
                allPosts.add(p);
              } catch (e) {
                debugPrint("Error4444 ${e.toString()}");
              }
            }
          }

          //articles
          List<dynamic>? articles = dataresult['result']['article']['data'];
          List<PostModel> dataArticles = [];
          if (articles != null && articles.isNotEmpty) {
            for (dynamic e in articles) {
              try {
                PostModel p = PostModel.fromMap(e);
                dataArticles.add(p);
                allPosts.add(p);
              } catch (e) {
                debugPrint("Error5555 ${e.toString()}");
              }
            }
          }

          //travel guide
          List<dynamic>? travelGuideCategs =
              dataresult['result']['travel_guide'];

          List<CityCategoryModel> dataTravelGuideCategories = [];
          if (travelGuideCategs != null && travelGuideCategs.isNotEmpty) {
            for (dynamic e in travelGuideCategs) {
              try {
                //debugPrint(e.toString());
                dataTravelGuideCategories.add(CityCategoryModel.fromMap(e));
              } catch (e) {
                debugPrint("Error8888 ${e.toString()}");
              }
            }
          }

          //hotel collection
          List<dynamic>? hotelColCategs =
              dataresult['result']['hotel_collection'];
          List<CityCategoryModel> dataHotelColCategories = [];
          if (hotelColCategs != null && hotelColCategs.isNotEmpty) {
            for (dynamic e in hotelColCategs) {
              try {
                dataHotelColCategories.add(CityCategoryModel.fromMap(e));
              } catch (e) {
                debugPrint("Error9999 ${e.toString()}");
              }
            }
          }

          //myplan
          List<dynamic>? myplans = dataresult['result']['myplan'];
          List<MyPlanModel> dataMyPlans = [];
          if (myplans != null && myplans.isNotEmpty) {
            for (dynamic e in myplans) {
              try {
                dataMyPlans.add(MyPlanModel.fromMap(e));
              } catch (e) {
                debugPrint("Error10101 ${e.toString()}");
              }
            }
          }

          //liked
          List<LikedModel> dataLiked = [];
          try {
            List<dynamic>? postLiked = dataresult['result']['liked'];

            if (postLiked != null && postLiked.isNotEmpty) {
              for (dynamic e in postLiked) {
                //debugPrint(e.toString());
                try {
                  dataLiked.add(LikedModel.fromJson(e));
                } catch (e) {
                  debugPrint("Error12112 ${e.toString()}");
                }
              }
            }
          } catch (e) {
            debugPrint("errorr liked ${e.toString()}");
          }

          //nearby
          List<PostModel> dataNearbys = [];
          try {
            List<dynamic>? postNearbys = dataresult['result']['post']['nearby'];
            if (postNearbys != null && postNearbys.isNotEmpty) {
              for (dynamic e in postNearbys) {
                //debugPrint(e.toString());
                try {
                  dataNearbys.add(PostModel.fromMap(e));
                } catch (e) {
                  debugPrint("Error4444 ${e.toString()}");
                }
              }

              if (dataNearbys.isNotEmpty) {
                dataNearbys.sort((a, b) => a.distance!.compareTo(b.distance!));
              }
            }
          } catch (e) {
            debugPrint("errorr nearby ${e.toString()}");
          }

          debugPrint("all post data length: ${allPosts.length}");

          //add list of user
          List<UserModel> dataUsers = [];
          int totalUser = 0;
          try {
            totalUser = int.parse(
                dataresult['result']['userlist']['total'][0]['total'] ?? "0");
            List<dynamic>? userlists = dataresult['result']['userlist']['data'];
            if (userlists != null && userlists.isNotEmpty) {
              for (dynamic e in userlists) {
                try {
                  dataUsers.add(UserModel.fromJson(e));
                } catch (e) {
                  debugPrint("Error get userlist ${e.toString()}");
                }
              }
            }
          } catch (e) {
            debugPrint("errorr list of user ${e.toString()}");
          }
          //add list of user

          //add list of notif
          List<NotifModel> dataNotifs = [];
          try {
            List<dynamic>? notiflists = dataresult['result']['notif']['data'];
            if (notiflists != null && notiflists.isNotEmpty) {
              for (dynamic e in notiflists) {
                try {
                  //debugPrint(e['user'].toString());
                  dataNotifs.add(NotifModel.fromMap(e));
                } catch (e) {
                  debugPrint("Error get notif ${e.toString()}");
                }
              }
            }
          } catch (e) {
            debugPrint("errorr list of notif ${e.toString()}");
          }
          //add list of notif

          //add list of following
          List<FollowModel> dataFollowing = [];
          try {
            List<dynamic>? followinglists = dataresult['result']['following'];
            if (followinglists != null && followinglists.isNotEmpty) {
              for (dynamic e in followinglists) {
                try {
                  //debugPrint(e['user'].toString());
                  dataFollowing.add(FollowModel.fromJson(e));
                } catch (e) {
                  debugPrint("Error get dataFollowing ${e.toString()}");
                }
              }
            }
          } catch (e) {
            debugPrint("errorr list of dataFollowing ${e.toString()}");
          }
          allFollowings.value = dataFollowing;
          //add list of following

          //add list of follower
          List<FollowModel> dataFollower = [];
          try {
            List<dynamic>? followerlists = dataresult['result']['follower'];
            if (followerlists != null && followerlists.isNotEmpty) {
              for (dynamic e in followerlists) {
                try {
                  //debugPrint(e['user'].toString());
                  dataFollower.add(FollowModel.fromJson(e));
                } catch (e) {
                  debugPrint("Error get dataFollower ${e.toString()}");
                }
              }
            }
          } catch (e) {
            debugPrint("errorr list of dataFollower ${e.toString()}");
          }
          allFollowers.value = dataFollower;
          //add list of follower

          itemHome.update((val) {
            val!.categories = dataCategories;
            val.nearbys = dataNearbys;
            val.travels = dataTravelGuideCategories;
            val.hotels = dataHotelColCategories;
            val.cityCategories = dataCityCategories;
            val.posts = dataPosts;
            val.articles = dataArticles;
            val.sliders = dataSliders;
            val.cities = dataCities;
            val.all = allPosts;
            val.myplans = dataMyPlans;
            val.liked = dataLiked;
            val.users = dataUsers;
            val.notifs = dataNotifs;
            val.totalUsers = totalUser;
            val.followers = dataFollower;
            val.followings = dataFollowing;
          });
        }
      }
    } catch (e) {
      debugPrint("Error: getAllLocalVariables: ${e.toString()}");
    }
  }

  addMorePost(final PostModel post) async {
    try {
      final jsonBody = jsonEncode({
        "ip": post.id,
        "iu": thisUser.value.id,
        "tl": post.title,
        "ds": post.desc,
        "ct": post.idCity,
        "ic": post.idCategory,
        "fl": post.flag,
        "tag": post.tag,
        "img1": post.image1,
        "img2": post.image2,
        "img3": post.image3,
        "lat": latitude,
        "loc": location,
        "uuid": thisUuid.value,
        "os": GetPlatform.isAndroid ? "Android" : "iOS",
        "tk": getTokenFCM(),
      });
      debugPrint(jsonBody);

      var linkAPI = 'upload/upload_post';

      final response = await provider.pushResponse(linkAPI, jsonBody);
      debugPrint("addMorePost response api home....");

      if (response != null && response.statusCode == 200) {
        EasyLoading.showSuccess('Upload post success');
        asyncLatitude();
        Future.delayed(const Duration(milliseconds: 600), () {
          asyncHome();
        });
      } else {
        String respString = response!.bodyString!;
        dynamic dataresult = jsonDecode(respString);
        EasyLoading.showError('Upload post failed. ${dataresult['message']}');
      }
    } catch (e) {
      debugPrint("Error upload post ${e.toString()}");
    }

    List<PostModel> lastPosts = [];
    lastPosts.add(post);
    lastPosts.addAll(itemHome.value.posts!);

    itemHome.update((val) {
      val!.posts = lastPosts;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      asyncHome();
    });
  }

  checkEmail(final String email) async {
    try {
      String? getInstall = myPref.pInstall.val;
      if (getInstall != '') {
        install.value = jsonDecode(getInstall);
      }

      final jsonBody = jsonEncode({
        "em": email,
        "lat": latitude,
        "loc": location,
        "cc": getCountry(),
        "iu": thisUser.value.id ?? '',
        "uf": thisUser.value.uidFcm ?? '',
        "is": install['id_install'] ?? ""
      });

      debugPrint(jsonBody);

      final response =
          await provider.pushResponse('api/checkEmailPhone', jsonBody);
      if (response != null && response.statusCode == 200) {
        dynamic dataresult = jsonDecode(response.bodyString!);

        if (dataresult['code'] == '200') {
          return true;
        }
      }
    } catch (e) {
      debugPrint("Error getUserById: ${e.toString()}");
    }

    return false;
  }

  getUserById() async {
    try {
      isLoggedIn.value = myPref.pLogin.val;
      debugPrint('getUserById isLoggedIn: ${isLoggedIn.value}');

      if (isLoggedIn.value) {
        final jsonBody = jsonEncode({
          "lat": latitude,
          "loc": location,
          "cc": getCountry(),
          "iu": thisUser.value.id ?? '',
          "uf": thisUser.value.uidFcm ?? '',
          "is": install['id_install'] ?? ""
        });

        debugPrint(jsonBody);

        provider.pushResponse('api/get_user', jsonBody)!.then((response) {
          if (response != null && response.statusCode == 200) {
            dynamic dataresult = jsonDecode(response.bodyString!);

            if (dataresult['code'] == '200') {
              dynamic getMember = dataresult['result'][0];
              myPref.pMember.val = jsonEncode(getMember);
              memberMap.value = getMember;
              //update();

              //update state
              setUserLogin();
              update();
            }
          }
        });
      }
    } catch (e) {
      debugPrint("Error getUserById: ${e.toString()}");
    }
  }

  updateUserById(
      final String action, final String about, final String fullname) async {
    try {
      debugPrint("updateUserById action $action");

      String idUser = thisUser.value.id ?? '';

      var jsonBody = jsonEncode({
        "lat": latitude,
        "loc": location,
        "iu": idUser,
        "act": action,
        "ab": about,
        "fn": fullname,
      });

      if (action == 'change_password') {
        jsonBody = jsonEncode({
          "lat": latitude,
          "loc": location,
          "iu": idUser,
          "act": action,
          "ps": about,
          "np": fullname,
        });
      } else if (action == 'update_username') {
        jsonBody = jsonEncode({
          "lat": latitude,
          "loc": location,
          "iu": idUser,
          "act": action,
          "us": about
        });
      }

      debugPrint(jsonBody);

      await provider.pushResponse('api/update_user_byid', jsonBody);

      Future.microtask(() async {
        if (action == 'change_password') {
          await XController.to.notificationFCMManager.firebaseAuthService
              .firebaseUpdatePassword(fullname);
        }
        getUserById();

        // update firebase password
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String basename(String path) {
    return path.split('/').last;
  }

  static Gradient getGradientColor(final bool isActive, final bool isDark) {
    return LinearGradient(
      colors: isActive
          ? [
              Get.theme.primaryColor,
              Get.theme.primaryColor.withOpacity(.6),
            ]
          : isDark
              ? [
                  Get.theme.canvasColor,
                  Get.theme.canvasColor.withOpacity(.8),
                ]
              : [
                  Colors.grey[600]!,
                  Colors.grey[600]!.withOpacity(.8),
                ],
    );
  }

  likeOrDislike(idPost, action) async {
    PostModel? postModel;
    try {
      final jsonBody = jsonEncode({
        "lat": latitude,
        "ip": "$idPost",
        "iu": "${thisUser.value.id}",
        "act": action
      });
      debugPrint(jsonBody);
      final response =
          await _provider.pushResponse('post/like_dislike_download', jsonBody);
      //debugPrint(response);

      if (response != null && response.statusCode == 200) {
        //debugPrint(response.body);
        dynamic dataresult = jsonDecode(response.bodyString!);

        if (dataresult['code'] == '200') {
          List<dynamic>? updatedRent = dataresult['result'];
          //debugPrint(updatedRent);
          if (updatedRent != null && updatedRent.isNotEmpty) {
            postModel = PostModel.fromMap(updatedRent[0]);
          }
        }
      }
    } catch (e) {
      debugPrint("");
    }

    Future.delayed(const Duration(milliseconds: 400), () {
      asyncHome();
    });

    return postModel;
  }

  //follow un follow
  followUnFollow(idUser, idUserTo, action) async {
    FollowModel? followModel;
    try {
      final jsonBody = jsonEncode({
        "lat": _latitude ?? '',
        "it": "$idUserTo",
        "iu": "$idUser",
        "sender": "${thisUser.value.id}",
        "act": action
      });
      debugPrint(jsonBody);
      final response =
          await provider.pushResponse('follow/follow_unfollow', jsonBody);
      //debugPrint(response);

      if (response != null && response.statusCode == 200) {
        debugPrint(response.bodyString);
        dynamic dataresult = jsonDecode(response.bodyString!);

        if (dataresult['code'] == '200') {
          List<dynamic> results = dataresult['result'];
          if (action == 'follow') {
            followModel = FollowModel.fromJson(results[0]);
          }
        }
      }

      Future.delayed(const Duration(milliseconds: 1200), () {
        asyncHome();
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    return followModel;
  }

  //create BitmapDescriptor icon
  final iconMap = BitmapDescriptor.defaultMarker.obs;
  createBitmapMap() async {
    iconMap.value = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 0.8),
        GetPlatform.isAndroid
            ? "assets/marker_plantrip.png"
            : "assets/marker_plantrip_50.png");
  }

  //data following, follower
  // follower
  final allFollowers = <FollowModel>[].obs;
  FollowModel getFollowerById(final String id) {
    return allFollowers.firstWhere((element) => element.id == id);
  }

// follower
  final allFollowings = <FollowModel>[].obs;
  FollowModel? getFollowById(final String id) {
    try {
      return allFollowings.firstWhere((element) => element.id == id);
    } catch (e) {
      debugPrint("");
    }
    return null;
  }

  FollowModel? getFollowingByIdUser(final String idUser) {
    debugPrint("idUser: $idUser");
    try {
      return allFollowings.firstWhere((element) => element.idUserTo == idUser);
    } catch (e) {
      debugPrint("");
    }
    return null;
  }

  FollowModel? getFollowerByIdUser(final String idUser) {
    try {
      return allFollowers.firstWhere((element) => element.idUser == idUser);
    } catch (e) {
      debugPrint("");
    }
    return null;
  }

  // add pushResetPassword
  Future<void> pushResetPassword(final String uidFirebase, final String email,
      final String newPassword, final String? phone, final bool isForce) async {
    // push reset password
    try {
      String idInstall = '';
      String getInstall = myPref.pInstall.val;
      if (getInstall.isNotEmpty) {
        install.value = jsonDecode(getInstall);
        idInstall = install['id_install'] ?? "";
      }

      String dataPush = jsonEncode({
        "id": idInstall,
        "uuid": thisUuid.value,
        "lat": latitude,
        "loc": location,
        "os": GetPlatform.isAndroid ? "Android" : "iOS",
        "tk": getTokenFCM(),
        "ph": phone ?? "",
        "em": email,
        "np": newPassword,
        "uf": uidFirebase,
      });

      debugPrint(dataPush);

      final response =
          await provider.pushResponse('api/reset_password', dataPush);

      if (response != null && response.statusCode == 200) {
        //debugPrint(response.bodyString);
        dynamic dataresult = jsonDecode(response.bodyString!);
        if (dataresult['result'] != null && dataresult['result'].length > 0) {
          dynamic member = dataresult['result'][0];

          if (isForce) {
            //try to change password firebase
            await XController.to.notificationFCMManager.firebaseAuthService
                .firebaseResetPassword(newPassword);
          } else {
            myPref.pPassword.val = "";
          }

          await Future.delayed(const Duration(milliseconds: 1200));

          myPref.pMember.val = jsonEncode(member);
          saveLogin(true);
          asyncHome();

          await Future.delayed(const Duration(milliseconds: 3200), () async {
            EasyLoading.dismiss();
            await initChatController();

            Get.offAll(MyHomePage());
          });
        }
      }
    } catch (e) {
      debugPrint("Error pushResetPassword: ${e.toString()}");
    }
  }
}
