import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/pages/feedback_page.dart';
import 'package:plantripapp/pages/webview_page.dart';
import 'package:plantripapp/theme.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final XController x = XController.to;

    return Obx(() => createBody(x, x.isDarkMode.value));
  }

  Widget createBody(final XController x, final bool isDarkMode) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: Get.theme.backgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            width: Get.width,
            height: Get.height,
            color: Colors.transparent,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      top: 25,
                      left: paddingSize,
                      right: paddingSize / 1.5,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        topHeader(x),
                        spaceHeight20,
                        SwitchListTile(
                          title: Text(
                              x.isDarkMode.value ? 'Dark Mode' : 'Light Mode'),
                          secondary: x.isDarkMode.value
                              ? const Icon(BootstrapIcons.brightness_high)
                              : const Icon(BootstrapIcons.moon_stars),
                          activeColor: Get.isDarkMode
                              ? Get.theme.primaryColorLight
                              : Get.theme.primaryColor,
                          onChanged: (value) async {
                            await ThemeService().switchTheme();
                            await Future.delayed(
                                const Duration(milliseconds: 500), () {
                              x.setThemeValue(x.myPref.pTheme.val);

                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                MyTheme.setAppTheme();
                              });
                            });
                          },
                          value: x.isDarkMode.value,
                        ),
                        const Divider(
                          thickness: 1.2,
                        ),
                        ListTile(
                          onTap: () {
                            showDialogLanguage(x);
                          },
                          title: Text("language".tr),
                          leading: const Icon(BootstrapIcons.flag),
                          trailing: const Icon(BootstrapIcons.chevron_right,
                              size: 18),
                        ),
                        const Divider(
                          thickness: 1.2,
                        ),
                        ListTile(
                          onTap: () {
                            debugPrint("click here");
                            Get.to(FeedbackPage(),
                                transition: Transition.leftToRight);
                          },
                          title: Text("feedback".tr),
                          leading: const Icon(BootstrapIcons.inbox),
                          trailing: const Icon(BootstrapIcons.chevron_right,
                              size: 18),
                        ),
                        const Divider(
                          thickness: 1.2,
                        ),
                        ListTile(
                          onTap: () {
                            MyTheme.onShare('Information', contentToShare, []);
                          },
                          title: Text('share_apps'.tr),
                          leading: const Icon(BootstrapIcons.share_fill),
                          trailing: const Icon(BootstrapIcons.chevron_right,
                              size: 18),
                        ),
                        const Divider(
                          thickness: 1.2,
                        ),
                        ListTile(
                          onTap: () {
                            // MyTheme.showToast('Coming soon...');
                            Get.to(
                                WebviewPage(
                                  url:
                                      'https://www.osano.com/ccpa-platform-demo',
                                  title: 'Privacy Policy',
                                ),
                                transition: Transition.leftToRight);
                          },
                          title: const Text('Privacy Policy'),
                          leading: const Icon(BootstrapIcons.box),
                          trailing: const Icon(BootstrapIcons.chevron_right,
                              size: 18),
                        ),
                        const Divider(
                          thickness: 1.2,
                        ),
                        ListTile(
                          onTap: () {
                            Get.to(
                                WebviewPage(
                                  url: 'https://plantrip.theaterify.id/',
                                  title: 'Website',
                                ),
                                transition: Transition.leftToRight);
                          },
                          title: const Text('Website'),
                          leading: const Icon(BootstrapIcons.globe),
                          trailing: const Icon(BootstrapIcons.chevron_right,
                              size: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget topHeader(final XController x) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                BootstrapIcons.chevron_left,
                size: 20,
              ),
            ),
          ),
          Text(
            "setting".tr,
            style: Get.theme.textTheme.headline6!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  //language
  showDialogLanguage(final XController x) {
    return showCupertinoModalBottomSheet(
      barrierColor: Get.theme.disabledColor.withOpacity(.4),
      context: Get.context!,
      builder: (context) => Container(
        width: Get.width,
        height: Get.height / 2.5,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(15.0),
            topLeft: Radius.circular(15.0),
          ),
          gradient: LinearGradient(colors: [
            Get.theme.backgroundColor,
            Get.theme.backgroundColor.withOpacity(.4)
          ]),
        ),
        child: Container(
          width: Get.width,
          height: Get.height,
          padding: const EdgeInsets.only(top: 15),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  width: Get.width,
                  height: Get.height,
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        margin: const EdgeInsets.only(top: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Container(
                          padding: const EdgeInsets.only(top: 0, bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(radiusInput),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "language".tr,
                                style: Get.theme.textTheme.headline5!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      spaceHeight20,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                              updateLanguageSetting(x, 'en');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              margin: const EdgeInsets.only(
                                  left: 0, right: 0, bottom: 10),
                              decoration: BoxDecoration(
                                color: Get.theme.scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "English",
                                  )
                                ],
                              ),
                            ),
                          ),
                          spaceWidth10,
                          InkWell(
                            onTap: () {
                              Get.back();
                              updateLanguageSetting(x, 'id');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              margin: const EdgeInsets.only(
                                  left: 0, right: 0, bottom: 10),
                              decoration: BoxDecoration(
                                color: Get.theme.primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Indonesia",
                                    style: textBold.copyWith(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      spaceHeight20,
                      spaceHeight20,
                      spaceHeight50,
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  margin: const EdgeInsets.only(top: 0),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(BootstrapIcons.chevron_down, size: 30)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateLanguageSetting(final XController x, final String lang) async {
    x.myPref.pLang.val = lang;

    await Future.delayed(const Duration(milliseconds: 300), () async {
      Locale locale =
          lang == 'en' ? const Locale('en', 'US') : const Locale('id', 'ID');
      Get.updateLocale(locale);
    });
  }
}
