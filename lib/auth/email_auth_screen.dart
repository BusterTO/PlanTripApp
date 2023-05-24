import 'dart:convert';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:plantripapp/auth/phone_login_screen.dart';
import 'package:plantripapp/auth/reset_password_screen.dart';
import 'package:plantripapp/core/firebase_auth_service.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/input_container.dart';

class EmailAuthScreen extends StatelessWidget {
  final dynamic getData;
  EmailAuthScreen({Key? key, required this.getData}) : super(key: key) {
    Future.delayed(const Duration(milliseconds: 3500), () {
      XController.to.asyncLatitude();
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  final _userEmail = ''.obs;
  final stepProcess = 1.obs;
  final loading = false.obs;

  final XController x = XController.to;

  @override
  Widget build(BuildContext context) {
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
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Stack(
                  children: [
                    Column(
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
                          "Reset Password",
                          style: Get.theme.textTheme.headline6!.copyWith(
                            fontSize: 20,
                            color: Get.isDarkMode
                                ? Get.theme.primaryColorLight
                                : Get.theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: InputContainer(
                              child: TextFormField(
                                validator: (email) {
                                  if (email!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return 'Enter a valid email';
                                  }
                                },
                                controller: _emailController,
                                decoration: inputForm(
                                        Get.theme.backgroundColor,
                                        25,
                                        const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15))
                                    .copyWith(
                                        hintText: 'Your Registered Email'),
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => stepProcess.value > 1
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 25),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    child: InputContainer(
                                      child: TextFormField(
                                        validator: (code) {
                                          if (code!.isNotEmpty) {
                                            return null;
                                          } else {
                                            return 'Enter a valid code';
                                          }
                                        },
                                        controller: _codeController,
                                        decoration: inputForm(
                                                Get.theme.backgroundColor,
                                                25,
                                                const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 15))
                                            .copyWith(
                                                hintText:
                                                    'Email Code Verification'),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.only(top: 25),
                          child: Obx(
                            () => loading.value
                                ? Container(
                                    padding: const EdgeInsets.all(10),
                                    width: Get.width,
                                    child: Center(
                                      child: MyTheme.loading(),
                                    ),
                                  )
                                : stepProcess.value == 1
                                    ? submitButton(x)
                                    : verifyButton(x),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 5,
                      left: 0,
                      child: IconButton(
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          BootstrapIcons.chevron_left,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget submitButton(final XController x) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _userEmail.value = _emailController.text.trim();
          String em = _userEmail.value;
          final valid = await x.checkEmail(em);
          if (valid) {
            loading.value = true;
            stepProcess.value = 2;

            await pushCodeToResetPassword();

            Future.delayed(const Duration(milliseconds: 2500), () {
              loading.value = false;

              MyTheme.showToast(
                  'Code already sent to your email, please check inbox/junk/SPAM folder.');
            });
          } else {
            MyTheme.showToast(
                'Email not found, please check your registered email');
          }
        }
      },
      style: ButtonStyle(
        padding:
            MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor:
            MaterialStateProperty.all<Color>(Get.theme.primaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusInput),
          ),
        ),
      ),
      child: Text(
        "Submit",
        style: Get.theme.textTheme.headline6!.copyWith(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget verifyButton(final XController x) {
    return ElevatedButton(
      onPressed: () async {
        debugPrint(encPass.value);
        debugPrint("Email: $_userEmail");
        String passWd = x.myPref.pPassword.val;
        debugPrint("passWd $passWd");

        String code = _codeController.text.trim();
        if (encPass.value != code) {
          EasyLoading.showToast('Code invalid...');
          return;
        }

        EasyLoading.show(status: 'Loading...');
        Future.delayed(const Duration(milliseconds: 1200), () async {
          //push firebase auth reathentication
          try {
            x.notificationFCMManager.init();
            FirebaseAuthService fauth =
                x.notificationFCMManager.firebaseAuthService;

            String em = _userEmail.value;
            String ps = passWd;

            String isForce = "1";
            String phone = '';

            if (getData != null &&
                getData['uf'] != null &&
                getData['uf'].toString().isNotEmpty) {
              //do nothing
              isForce = "0";
              ps = "defPassword2022";
              phone = getData['phone'].toString();
            } else {
              await fauth.firebaseSignInByEmailPwd(em, ps);
            }

            await Future.delayed(const Duration(milliseconds: 2200));

            String? uid = await fauth.getFirebaseUserId();

            if (uid == null) {
              // invalid login
              EasyLoading.dismiss();
              Get.back();

              EasyLoading.showToast('Email invalid.. try to phone login...');
              Get.to(PhoneLoginScreen());
            } else {
              EasyLoading.dismiss();
              Get.back();

              //pass through password login by phone:
              if (isForce == '0') {
                EasyLoading.show(status: 'Loading...');

                Future.delayed(const Duration(milliseconds: 1200), () {
                  x.pushResetPassword(
                      uid, em, "defPassword2022", phone, isForce == '1');
                });
                return;
              }

              //valid login go to creae new password
              final dynamic userData = {
                "email": em,
                "password": ps,
                "uf": uid,
                "phone": phone,
                "is_force": isForce, // uid user firebase
              };

              debugPrint("Goto Reset Password Screen ...");

              Get.to(ResetPasswordScreen(userData: userData));
            }
          } catch (e) {
            debugPrint("Error signing firebase ... ${e.toString()}");
          }
        });
      },
      style: ButtonStyle(
        padding:
            MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor:
            MaterialStateProperty.all<Color>(Get.theme.primaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusInput),
          ),
        ),
      ),
      child: Text(
        "Verify",
        style: Get.theme.textTheme.headline6!.copyWith(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  final encPass = ''.obs;

  Future<void> pushCodeToResetPassword() async {
    _userEmail.value = _emailController.text.trim();

    // push email
    var dataPush = {"em": _userEmail.value};
    final response = await x.provider
        .pushResponse('sendMail/sendMail', jsonEncode(dataPush));

    if (response != null && response.statusCode == 200) {
      debugPrint(response.bodyString);
      dynamic dataresult = jsonDecode(response.bodyString!);
      if (dataresult['result'] != null && dataresult['result'].length > 0) {
        dynamic result = dataresult['result'][0];
        encPass.value = result['token_forgot'];
      }
    }

    debugPrint("code verification $encPass");
  }
}
