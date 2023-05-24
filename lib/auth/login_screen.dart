import 'dart:convert';

import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:plantripapp/auth/phone_login_screen.dart';
import 'package:plantripapp/auth/email_auth_screen.dart';
import 'package:plantripapp/auth/signup_screen.dart';
import 'package:plantripapp/core/firebase_auth_service.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/main.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/input_container.dart';

class LoginScreen extends StatelessWidget {
  final formGlobalKey = GlobalKey<FormState>();

  LoginScreen({Key? key}) : super(key: key) {
    debugPrint("LoginScreen enter... ");
    Future.delayed(const Duration(milliseconds: 1500), () {
      XController.to.asyncLatitude();
      XController.to.asyncHome();
    });

    Future.delayed(const Duration(milliseconds: 3500), () {
      XController.to.asyncLatitude();
      XController.to.asyncHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    final XController x = XController.to;
    debugPrint("darkmode ${x.myPref.pTheme.val}");

    return Container(
      width: Get.width,
      height: Get.height,
      color: Get.theme.backgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            width: Get.width,
            height: Get.height,
            color: Colors.transparent,
            child: SingleChildScrollView(
              child: Form(
                key: formGlobalKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: Get.mediaQuery.padding.top * 0.7),
                    Container(
                      width: Get.width,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: Get.width,
                        child: Column(
                          children: [
                            ExtendedImage.asset(
                              "assets/plantrip_line01_trans.png",
                              width: Get.width / 2,
                            ),
                            Text(appVersion,
                                style: textSmallGrey.copyWith(fontSize: 9))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 55),
                    Text(
                      "Sign In With Email or Username",
                      style: Get.theme.textTheme.headline6!.copyWith(
                        fontSize: 16,
                        color: Get.isDarkMode
                            ? Get.theme.primaryColorLight
                            : Get.theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: inputEmailUsername(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: inputPassword(),
                    ),
                    InkWell(
                      onTap: () {
                        String passWd = x.myPref.pPassword.val;
                        debugPrint("passWd $passWd");

                        // showDialogForgotPassword();

                        if (passWd.isNotEmpty) {
                          Get.to(EmailAuthScreen(getData: null),
                              transition: Transition.rightToLeft);
                        } else {
                          //Get.to(PhoneLoginScreen());
                          showDialogForgotPassword();
                        }
                      },
                      child: Container(
                        width: Get.width,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(top: 20),
                        child: const Text("Forgot Password?",
                            style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    Container(
                      width: Get.width,
                      padding: const EdgeInsets.only(top: 25),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formGlobalKey.currentState!.validate()) {
                            EasyLoading.show(status: 'Loading...');
                            pushLogin(x);
                          }
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.all(15)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Get.theme.primaryColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(radiusInput),
                            ),
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: Get.theme.textTheme.headline6!.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: Get.width,
                      padding: const EdgeInsets.only(top: 15),
                      child: ElevatedButton(
                        onPressed: () async {
                          Get.to(SignUpScreen(),
                              transition: Transition.rightToLeft);
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.all(15)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Get.theme.backgroundColor.withOpacity(.6)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(radiusInput),
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(BootstrapIcons.envelope,
                                color: Get.theme.textTheme.bodyText1!.color),
                            spaceWidth10,
                            Text(
                              "Sign Up with Email",
                              style: Get.theme.textTheme.headline6!.copyWith(
                                color: Get.theme.textTheme.bodyText1!.color,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (GetPlatform.isAndroid)
                      Container(
                        width: Get.width,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 25),
                        child: Text("Or",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold)),
                      ),
                    if (GetPlatform.isAndroid)
                      Container(
                        width: Get.width,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 25),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textButtonIcon(
                                "Goggle",
                                const Icon(AntIcons.googleCircleFilled,
                                    color: Colors.red), () {
                              MyTheme.showToast('Demo Only...');
                            }),
                            spaceWidth10,
                            textButtonIcon(
                                "Apple",
                                const Icon(AntIcons.appleFilled,
                                    color: Colors.black), () {
                              MyTheme.showToast('Demo Only...');
                            }),
                            spaceWidth10,
                            textButtonIcon(
                                "Facebook",
                                Icon(AntIcons.facebookFilled,
                                    color: Colors.blue[900]), () {
                              MyTheme.showToast('Demo Only...');
                            }),
                          ],
                        ),
                      ),
                    if (GetPlatform.isAndroid) spaceHeight50,
                    spaceHeight50,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showDialogForgotPassword() {
    final Container childContainer = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.only(top: Get.height / 2.2),
      decoration: BoxDecoration(
        color: Get.theme.backgroundColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topRight,
            width: Get.width,
            margin: const EdgeInsets.only(top: 5),
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              iconSize: 30,
              icon: const Icon(BootstrapIcons.x_circle),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: Get.width,
            padding: const EdgeInsets.only(top: 25),
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                Get.to(PhoneLoginScreen(), transition: Transition.rightToLeft);
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(15)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Get.theme.primaryColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radiusInput),
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(BootstrapIcons.telephone, color: Colors.white),
                  spaceWidth10,
                  Text(
                    "Phone Login",
                    style: Get.theme.textTheme.headline6!.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: Get.width,
            padding: const EdgeInsets.only(top: 15),
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                Get.to(EmailAuthScreen(getData: null),
                    transition: Transition.rightToLeft);
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(15)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Get.theme.backgroundColor.withOpacity(.6)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radiusInput),
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(BootstrapIcons.envelope,
                      color: Get.theme.textTheme.bodyText1!.color),
                  spaceWidth10,
                  Text(
                    "Email Authentication",
                    style: Get.theme.textTheme.headline6!.copyWith(
                      color: Get.theme.textTheme.bodyText1!.color,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Get.dialog(childContainer);
  }

  Widget textButtonIcon(
      final String? text, final Icon? icon, final VoidCallback? onPress) {
    return TextButton(
      style: ButtonStyle(
          padding:
              MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radiusInput),
                  side: const BorderSide(color: Colors.grey)))),
      onPressed: onPress ?? () {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon ?? const Icon(BootstrapIcons.google, color: Colors.red),
          const SizedBox(width: 5),
          Text(
            text ?? "Google",
            style: TextStyle(
              color: Get.theme.textTheme.bodyText1!.color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget inputEmailUsername() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InputContainer(
        child: TextFormField(
          validator: (email) {
            if (email!.isNotEmpty) {
              return null;
            } else {
              return 'Enter a valid email or username';
            }
          },
          controller: _email,
          decoration: inputForm(Get.theme.backgroundColor, 25,
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15))
              .copyWith(hintText: 'Email or Username'),
        ),
      ),
    );
  }

  final isObsecure = true.obs;
  Widget inputPassword() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InputContainer(
        child: Obx(
          () => TextFormField(
            validator: (password) {
              if (password!.isNotEmpty) {
                return null;
              } else {
                return 'Enter a valid password';
              }
            },
            controller: _passwd,
            obscureText: isObsecure.value,
            decoration: inputForm(Get.theme.backgroundColor, 25,
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15))
                .copyWith(
              hintText: 'Password',
              suffixIcon: InkWell(
                onTap: () {
                  isObsecure.value = !isObsecure.value;
                },
                child: Icon(isObsecure.value
                    ? BootstrapIcons.eye
                    : BootstrapIcons.eye_slash),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final TextEditingController _email = TextEditingController();
  final TextEditingController _passwd = TextEditingController();

  pushLogin(final XController x) async {
    EasyLoading.show(status: 'Loading...');

    try {
      x.notificationFCMManager.init();
      String em = _email.text.toString().trim();
      String ps = _passwd.text.toString().trim();

      FirebaseAuthService fauth = x.notificationFCMManager.firebaseAuthService;
      await fauth.firebaseSignInByEmailPwd(em, ps);

      await Future.delayed(const Duration(milliseconds: 2200));

      String? uid = await fauth.getFirebaseUserId();
      if (uid == null) {
        EasyLoading.dismiss();
        EasyLoading.showToast("Email or password invalid...");
        return;
      }

      var dataPush = jsonEncode({
        "em": em,
        "ps": ps,
        "is": x.install['id_install'],
        "lat": x.latitude,
        "loc": x.location,
        "cc": x.getCountry(),
        "uf": uid,
      });
      debugPrint(dataPush);

      EasyLoading.show(status: 'Loading...');

      final response = await x.provider.pushResponse('api/login', dataPush);

      if (response != null && response.statusCode == 200) {
        //debugPrint(response.bodyString);
        dynamic dataresult = jsonDecode(response.bodyString!);

        if (dataresult['code'] == '200') {
          dynamic member = dataresult['result'][0];
          x.myPref.pMember.val = jsonEncode(member);
          x.saveLogin(true);
          x.asyncHome();

          await Future.delayed(const Duration(milliseconds: 3200), () {
            EasyLoading.dismiss();

            Get.offAll(MyHomePage());
          });
        } else {
          await Future.delayed(const Duration(milliseconds: 2200), () async {
            EasyLoading.dismiss();

            CoolAlert.show(
              backgroundColor: Get.theme.backgroundColor,
              context: Get.context!,
              type: CoolAlertType.error,
              text: "${dataresult['message']}",
            );

            await Future.delayed(const Duration(milliseconds: 3200), () {
              x.notificationFCMManager.firebaseAuthService.signOut();
            });
          });
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 3200), () {
          x.notificationFCMManager.firebaseAuthService.signOut();
        });
      }
    } catch (e) {
      debugPrint("");
    }
  }
}
