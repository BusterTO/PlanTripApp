import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/input_container.dart';

class ResetPasswordScreen extends StatelessWidget {
  final dynamic userData;
  ResetPasswordScreen({Key? key, required this.userData}) : super(key: key) {
    Future.delayed(const Duration(milliseconds: 3500), () {
      XController.to.asyncLatitude();
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _rePwdController = TextEditingController();

  final _userPwd = ''.obs;
  final _userRePwd = ''.obs;
  final XController x = XController.to;
  final loading = false.obs;

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
                                validator: (passwd) {
                                  if (passwd!.isEmpty) {
                                    return 'Enter a valid password';
                                  } else if (passwd.length < 6) {
                                    return 'Enter a min 6 alphanumeric password';
                                  } else {
                                    return null;
                                  }
                                },
                                controller: _pwdController,
                                decoration: inputForm(
                                        Get.theme.backgroundColor,
                                        25,
                                        const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15))
                                    .copyWith(hintText: 'Your Password'),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: InputContainer(
                              child: TextFormField(
                                validator: (rePass) {
                                  if (rePass!.isEmpty) {
                                    return 'Enter a valid Retype password';
                                  } else if (rePass.length < 6) {
                                    return 'Enter a min 6 alphanumeric retype password';
                                  } else {
                                    return null;
                                  }
                                },
                                controller: _rePwdController,
                                decoration: inputForm(
                                        Get.theme.backgroundColor,
                                        25,
                                        const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15))
                                    .copyWith(hintText: 'Retype Password'),
                              ),
                            ),
                          ),
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
                                : submitButton(x),
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
          _userPwd.value = _pwdController.text.trim();
          _userRePwd.value = _rePwdController.text.trim();
          if (_userPwd.value == _userRePwd.value) {
            loading.value = true;

            EasyLoading.show(status: 'Loading...');

            String phone = "";
            if (userData['phone'] != null &&
                userData['phone'].toString().isNotEmpty) {
              phone = userData['phone'].toString();
            }

            Future.delayed(const Duration(milliseconds: 1200), () {
              x.pushResetPassword(
                  userData['uf'].toString(),
                  userData['email'].toString(),
                  _userPwd.value,
                  phone,
                  userData['is_force'].toString() == '1');
            });
          } else {
            MyTheme.showToast('Your Password not equal with retype Password');
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
}
