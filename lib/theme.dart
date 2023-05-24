import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:plantripapp/core/my_pref.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class MyTheme {
  static final light = ThemeData.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: fontFamily,
        ),
    primaryTextTheme: ThemeData.light().textTheme.apply(
          fontFamily: fontFamily,
        ),
    appBarTheme: const AppBarTheme(
      color: primaryColor,
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.green,
      accentColor: primaryColor,
      brightness: Brightness.light,
    ),
    iconTheme: const IconThemeData(color: Colors.black),
    backgroundColor: accentColor.withOpacity(.9),
    canvasColor: Colors.grey[100],
    scaffoldBackgroundColor: Colors.white70,
    // ignore: deprecated_member_use
    primaryColorBrightness: Brightness.light,
    primaryColor: primaryColor,
    primaryColorLight: const Color(0xff7fcaca),
  );

  static final dark = ThemeData.dark().copyWith(
    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: fontFamily,
        ),
    primaryTextTheme: ThemeData.dark().textTheme.apply(
          fontFamily: fontFamily,
        ),
    appBarTheme: const AppBarTheme(
      color: Colors.black87,
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.grey,
      accentColor: Colors.grey[200],
      brightness: Brightness.dark,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    backgroundColor: Colors.black,
    canvasColor: Colors.grey[800],
    // ignore: deprecated_member_use
    primaryColorBrightness: Brightness.dark,
    primaryColor: primaryColor,
    primaryColorLight: const Color(0xff7fcaca),
  );

  static showToast(final String status) {
    EasyLoading.showToast(status);
  }

  static sendWA(String phone, String text) {
    try {
      if (phone.length < 5) {
        EasyLoading.showToast("Handphone tidak tersedia...");
        return;
      }
      if (phone.substring(0, 1) == '0') {
        phone = "+62${phone.substring(1)}";
      }
      debugPrint(phone);
      //launch("https://api.whatsapp.com/send?phone=$phone&text=$text");
      openWhatsapp(text: text, number: phone);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static openWhatsapp({required String text, required String number}) async {
    var whatsapp = number; //+92xx enter like this
    var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=$text";
    var whatsappURLIos = "https://wa.me/$whatsapp?text=${Uri.tryParse(text)}";
    if (GetPlatform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
        await launchUrl(Uri.parse(
          whatsappURLIos,
        ));
      } else {
        showSnackbar("Whatsapp not installed");
      }
    } else {
      // android , web
      if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
        await launchUrl(Uri.parse(whatsappURlAndroid));
      } else {
        showSnackbar("Whatsapp not installed");
      }
    }
  }

  static showSnackbar(final String text) {
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text(text)));
  }

  static onShare(final String text, final String subject,
      final List<String> imagePaths) async {
    // A builder is used to retrieve the context immediately
    // surrounding the ElevatedButton.
    //
    // The context's `findRenderObject` returns the first
    // RenderObject in its descendent tree when it's not
    // a RenderObjectWidget. The ElevatedButton's RenderObject
    // has its position and size after it's built.
    final RenderBox box = Get.context!.findRenderObject() as RenderBox;

    if (imagePaths.isNotEmpty) {
      await Share.shareFiles(imagePaths,
          text: text,
          subject: subject,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share(text,
          subject: subject,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

  static Widget photoView(final String uri) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: Get.theme.backgroundColor,
      child: Stack(
        children: [
          PhotoView(
            imageProvider: ExtendedNetworkImageProvider(uri, cache: true),
            backgroundDecoration:
                BoxDecoration(color: Get.theme.backgroundColor),
          ),
          Positioned(
            top: Get.mediaQuery.padding.top,
            left: 0,
            child: Container(
              margin: const EdgeInsets.only(top: 0),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Icon(BootstrapIcons.chevron_left,
                              color: Get.theme.primaryColor, size: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String numberFormatDisplay(final number) {
    return NumberFormat.compact().format(number);
  }

  static int timeStamp(final String date) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime dateTime = dateFormat.parse(date);
    return dateTime.toLocal().millisecondsSinceEpoch;
  }

  static DateTime convertDate(final String date) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    return dateFormat.parse(date);
  }

  static String formattedTime(DateTime dateTime) {
    return DateFormat().add_jm().format(dateTime);
  }

  static String formattedTimeFromString(final String date) {
    return DateFormat().add_yMMMMEEEEd().add_jm().format(convertDate(date));
  }

  static String formattedTimeFromStringShort(final String date) {
    return DateFormat().add_yMMMEd().add_jm().format(convertDate(date));
  }

  static String formattedComment(final String date) {
    DateFormat dateFormat = DateFormat("yyyy/MM/dd h:mm a");
    return dateFormat.format(convertDate(date));
  }

  static String timeStampNow() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    return dateFormat.format(DateTime.now());
  }

  static setAppTheme() {
    final XController x = XController.to;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            x.isDarkMode.value ? Brightness.light : Brightness.dark,

        //iOS only
        statusBarBrightness:
            x.isDarkMode.value ? Brightness.dark : Brightness.light,

        systemNavigationBarColor:
            x.isDarkMode.value ? Colors.black87 : Colors.white30,

        systemNavigationBarContrastEnforced: false,
        systemNavigationBarIconBrightness:
            x.isDarkMode.value ? Brightness.light : Brightness.dark,
      ),
    );
  }

  static InputDecoration inputFormAccent(
      final String hint, final Color fillColor, final Color accentColor) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: fillColor,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: accentColor),
        borderRadius: BorderRadius.circular(20),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: accentColor),
        borderRadius: BorderRadius.circular(20),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: accentColor),
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.all(15),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: accentColor),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  static Widget loading() {
    return const SizedBox(
      width: 30,
      height: 30,
      child: SizedBox(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static String basename(String path) {
    return path.split('/').last;
  }
}

const String appName = 'PlanTrip';
const String appVersion = 'v. 1.1.3';
const String nmStorage = "newGetStorage";
const String mapGoogleAPIKey = "AIzaSyCqvFeXeNMAHIHJK5Abq17UBN42V5ZYmWw";
const String serverKeyFCM =
    "AAAA7_y_GJ0:APA91bHGVKg5BV2WdCU46fZuIgIZNWZyxtdfRKGU3tWRF7C5L75u7nXuhTRaPOy2aqcdvIarBdHVrfwv3Dtw0fN7OBSH8yt7Hh3oYeWBsgiDTIcqF5y6FeHfNDeFdT_6aqaGY6gSuiIw";

const String fcmTopicName = "topicplantripapp";
const String waPhone = "+6281293812628";
const String contentToShare =
    "PlanTrip - Save Your Plan Trip Everywhere. \n\nWebsite: https://erhacorp.id @Copyrights 2021, Erhacorp.ID\n";

final fontFamily = GoogleFonts.poppins().fontFamily;
const Color mainColor = Color(0xFF21A381);
const Color primaryColor = Color(0xff307672);
const Color primaryColorDark = Color(0xff2e482e);
const Color accentColor = Color(0xffe6ecec);

const int maxViewComment = 5;
const int pagePaging = 100; // 100 row per page
const String pageLimit = "0,100"; // limit paging push

final List<String> defAvatar = [
  "https://plantrip.theaterify.id/upload/avatar_plantrip01.jpg",
  "https://plantrip.theaterify.id/upload/avatar_plantrip02.jpg",
  "https://plantrip.theaterify.id/upload/avatar_plantrip03.jpg",
];

InputDecoration inputForm(final Color backgroundColor, final double radius,
        final EdgeInsets? contentPadding) =>
    InputDecoration(
      //hintText: hint,
      filled: true,
      hintStyle: const TextStyle(color: Colors.grey),
      fillColor: backgroundColor,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: backgroundColor),
        borderRadius: BorderRadius.circular(radius),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: backgroundColor),
        borderRadius: BorderRadius.circular(radius),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: backgroundColor),
        borderRadius: BorderRadius.circular(radius),
      ),
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(horizontal: 26, vertical: 22),
      border: InputBorder.none,
    );

const double paddingSize = 28.0;
const double spaceIcon = 18.0;
const double witdhIcon = 80.0;
const double tabIconSize = 18.0;

const double heightDivider = 12.0;
const double radiusInput = 20.0;
const double iconSize = 19.0;
const int ratioSize = 25;
const int ratioSmallSize = 20;
const int ratioSmallerSize = 15;

double heightExpanded = Get.height / 1.3;

const EdgeInsets padding5 = EdgeInsets.all(5);
const EdgeInsets padding8 = EdgeInsets.all(8);
const EdgeInsets padding20 = EdgeInsets.all(20);

const TextStyle textBold = TextStyle(fontWeight: FontWeight.bold);
const TextStyle textBig = TextStyle(fontSize: 20);
const TextStyle textTitle = TextStyle(fontSize: 18);
const TextStyle textNormal = TextStyle(fontSize: 14);
const TextStyle textSuperSmall = TextStyle(fontSize: 9);
const TextStyle textSmall8 = TextStyle(fontSize: 8);
const TextStyle textSmall = TextStyle(fontSize: 11);
const TextStyle textSmallGrey = TextStyle(fontSize: 12, color: Colors.grey);

const SizedBox spaceHeight2 = SizedBox(height: 2);
const SizedBox spaceHeight5 = SizedBox(height: 5);
const SizedBox spaceHeight10 = SizedBox(height: 10);
const SizedBox spaceHeight15 = SizedBox(height: 15);
const SizedBox spaceHeight20 = SizedBox(height: 20);
const SizedBox spaceHeight50 = SizedBox(height: 50);

const SizedBox spaceWidth2 = SizedBox(width: 2);
const SizedBox spaceWidth5 = SizedBox(width: 5);
const SizedBox spaceWidth10 = SizedBox(width: 10);
const SizedBox spaceWidth15 = SizedBox(width: 15);
const SizedBox spaceWidth20 = SizedBox(width: 20);
const SizedBox spaceWidth50 = SizedBox(width: 50);

//theme service
class ThemeService {
  final myPref = MyPref.to;

  /// Get isDarkMode info from local storage and return ThemeMode
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  /// Load isDArkMode from local storage and if it's empty, returns false (that means default theme is light)
  bool _loadThemeFromBox() => myPref.pTheme.val;

  /// Save isDarkMode to local storage
  _saveThemeToBox(bool isDarkMode) => myPref.pTheme.val = isDarkMode;

  /// Switch theme and save to local storage
  switchTheme() async {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());

    Future.delayed(const Duration(milliseconds: 1200), () {
      MyTheme.setAppTheme();
    });
  }
}
//theme service


