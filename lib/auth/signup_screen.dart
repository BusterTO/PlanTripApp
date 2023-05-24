import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:plantripapp/core/firebase_auth_service.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/main.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/input_container.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SignUpScreen extends StatelessWidget {
  final formGlobalKey = GlobalKey<FormState>();

  SignUpScreen({Key? key}) : super(key: key) {
    Future.delayed(const Duration(milliseconds: 3500), () {
      XController.to.asyncLatitude();
      XController.to.asyncHome();
    });
  }

  final thisAgree = true.obs;

  @override
  Widget build(BuildContext context) {
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
              child: Form(
                key: formGlobalKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: Get.mediaQuery.padding.top * 0.6,
                        left: paddingSize,
                        right: paddingSize / 3,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 25),
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
                                    child: Icon(BootstrapIcons.chevron_left,
                                        color: Get.theme.primaryColor,
                                        size: 20),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: ClipOval(
                                    child: Image.asset(
                                        "assets/icon_tranparent.png",
                                        width: 45),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: Get.width / 1.4,
                            child: const Text(
                              "Create Account",
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 24,
                                height: 1.2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          spaceHeight5,
                          const Text(
                              "Enter your name, email and password for sign up",
                              style: textSmallGrey),
                          spaceHeight50,
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: inputFullname(),
                          ),
                          spaceHeight20,
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: inputEmail(),
                          ),
                          spaceHeight20,
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: inputPassword(),
                          ),
                          spaceHeight20,
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: inputRePassword(),
                          ),
                          spaceHeight20,
                          Padding(
                            padding: const EdgeInsets.only(top: 10, right: 20),
                            child: Obx(
                              () => Row(
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    child: Checkbox(
                                      activeColor: Get.theme.primaryColor,
                                      value: thisAgree.value,
                                      onChanged: (value) {
                                        thisAgree.value = !thisAgree.value;
                                      },
                                    ),
                                  ),
                                  const Text(
                                    'I have and agree to our terms, conditions\r\n and privacy Policy.',
                                    style: textSmallGrey,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          spaceHeight10,
                          Obx(() => buttonSignup(isProcessSignup.value)),
                          spaceHeight50,
                        ],
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

  final TextEditingController _email = TextEditingController();
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _passwd = TextEditingController();
  final TextEditingController _repasswd = TextEditingController();

  final isProcessSignup = false.obs;
  Widget buttonSignup(final bool isRunning) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.only(
        top: 25,
        right: 20,
      ),
      child: ElevatedButton(
        onPressed: () async {
          if (!thisAgree.value) {
            MyTheme.showToast(
                'You must accept and agree our terms & conditions!');
            return;
          }

          if (formGlobalKey.currentState!.validate()) {
            Alert(
              context: Get.context!,
              type: AlertType.warning,
              title: "Are you sure to procced?",
              style: AlertStyle(backgroundColor: Get.theme.backgroundColor),
              buttons: [
                DialogButton(
                  onPressed: () => Get.back(),
                  color: Colors.grey[400],
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                DialogButton(
                  onPressed: () async {
                    Get.back();
                    if (isProcessSignup.value) return;

                    isProcessSignup.value = true;
                    Future.delayed(const Duration(seconds: 5), () {
                      isProcessSignup.value = false;
                    });

                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    pushRegister(XController.to);
                  },
                  gradient: LinearGradient(colors: [
                    Get.theme.primaryColor,
                    Get.theme.primaryColor.withOpacity(.8)
                  ]),
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              ],
            ).show();
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
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        child: isRunning
            ? const SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(BootstrapIcons.chevron_right, color: Colors.white),
                  spaceWidth10,
                  Text(
                    "Signing Up",
                    style: Get.theme.textTheme.headline6!.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget inputFullname() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InputContainer(
        child: TextFormField(
          validator: (fullname) {
            if (fullname!.isNotEmpty) {
              return null;
            } else {
              return 'Enter a valid fullname';
            }
          },
          controller: _fullname,
          textCapitalization: TextCapitalization.sentences,
          decoration: inputForm(Get.theme.backgroundColor, 25,
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15))
              .copyWith(hintText: 'Fullname'),
        ),
      ),
    );
  }

  Widget inputEmail() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InputContainer(
        child: TextFormField(
          validator: (email) {
            if (email!.isNotEmpty) {
              if (!GetUtils.isEmail(email)) {
                return 'Enter a valid email address';
              }
              return null;
            } else {
              return 'Enter a valid Email';
            }
          },
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          decoration: inputForm(Get.theme.backgroundColor, 25,
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15))
              .copyWith(hintText: 'Email'),
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

  final isObsecureRe = true.obs;
  Widget inputRePassword() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InputContainer(
        child: Obx(
          () => TextFormField(
            validator: (password) {
              if (password!.isNotEmpty) {
                return null;
              } else {
                return 'Enter a valid retype password';
              }
            },
            controller: _repasswd,
            obscureText: isObsecureRe.value,
            decoration: inputForm(Get.theme.backgroundColor, 25,
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15))
                .copyWith(
              hintText: 'Retype Password',
              suffixIcon: InkWell(
                onTap: () {
                  isObsecureRe.value = !isObsecureRe.value;
                },
                child: Icon(isObsecureRe.value
                    ? BootstrapIcons.eye
                    : BootstrapIcons.eye_slash),
              ),
            ),
          ),
        ),
      ),
    );
  }

  pushRegister(final XController x) async {
    EasyLoading.show(status: 'Loading...');
    x.notificationFCMManager.init();

    String em = _email.text.toString().trim();
    String ps = _passwd.text.toString().trim();

    // check email first
    bool passChecked = false;
    try {
      final datapush = {
        "em": em,
      };

      //debugPrint(datapush);

      final response = await x.provider
          .pushResponse('api/checkEmailPhone', jsonEncode(datapush));
      if (response != null && response.statusCode == 200) {
        dynamic dataresult = jsonDecode(response.bodyString!);
        //debugPrint(_result);

        if (dataresult['code'] != '200') {
          passChecked = true;
        }
      }
    } catch (e) {
      debugPrint("");
    }

    try {
      if (!passChecked) {
        EasyLoading.dismiss();
        EasyLoading.showToast("Email already exist, try another one");
        return;
      }

      // push email Firebase
      FirebaseAuthService fauth = x.notificationFCMManager.firebaseAuthService;
      await fauth.firebaseSignUpByEmailPwd(em, ps);

      await Future.delayed(const Duration(milliseconds: 3200));

      String? uid = await fauth.getFirebaseUserId();
      if (uid == null) {
        EasyLoading.dismiss();
        return;
      }

      EasyLoading.show(status: 'Loading...');
      final datapush = {
        "em": em,
        "ps": ps,
        "is": x.install['id_install'],
        "lat": x.latitude,
        "loc": x.location,
        "cc": x.getCountry(),
        "fn": _fullname.text.toString().trim(),
        "uf": uid,
      };

      //debugPrint(datapush);

      final response =
          await x.provider.pushResponse('api/register', jsonEncode(datapush));
      //debugPrint(response);

      if (response != null && response.statusCode == 200) {
        //debugPrint(response.bodyString);
        dynamic dataresult = jsonDecode(response.bodyString!);

        if (dataresult['code'] == '200') {
          dynamic member = dataresult['result'][0];

          Future.microtask(() => successRegister(x, member));
        } else {
          await Future.delayed(const Duration(milliseconds: 2200), () async {
            EasyLoading.dismiss();

            CoolAlert.show(
              backgroundColor: Get.theme.backgroundColor,
              context: Get.context!,
              type: CoolAlertType.error,
              text: "${dataresult['message']}",
            );

            await Future.delayed(const Duration(milliseconds: 2200), () {
              x.notificationFCMManager.firebaseAuthService.signOut();
            });
          });
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 2200), () {
          x.notificationFCMManager.firebaseAuthService.signOut();
        });
      }
    } catch (e) {
      debugPrint("");
    }
  }

  static successRegister(final XController x, final dynamic member) async {
    x.myPref.pMember.val = jsonEncode(member);
    x.saveLogin(true);
    x.asyncHome();

    await Future.delayed(const Duration(milliseconds: 3200), () {
      EasyLoading.dismiss();
      Get.offAll(MyHomePage(), transition: Transition.cupertinoDialog);
    });
  }
}
