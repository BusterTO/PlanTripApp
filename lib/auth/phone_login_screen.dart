import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:plantripapp/auth/email_auth_screen.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/input_container.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneLoginScreen extends StatelessWidget {
  PhoneLoginScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  final String initialCountry = 'ID';
  final PhoneNumber number = PhoneNumber(isoCode: 'ID');
  final TextEditingController _codeController = TextEditingController();

  final success = false.obs;
  final XController x = XController.to;
  final stepProcess = 1.obs;
  final loading = false.obs;

  final phoneNumber = ''.obs;

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
                          "Phone Login",
                          style: Get.theme.textTheme.headline6!.copyWith(
                            fontSize: 20,
                            color: Get.isDarkMode
                                ? Get.theme.primaryColorLight
                                : Get.theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 15),
                          color: Colors.transparent,
                          child: InputContainer(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 5,
                              top: 10,
                            ),
                            backgroundColor: Get.theme.backgroundColor,
                            child: InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {
                                phoneNumber.value = "${number.phoneNumber}";
                                //debugPrint(number.phoneNumber);
                              },
                              onInputValidated: (bool value) {
                                //debugPrint(value.toString());
                              },
                              selectorConfig: const SelectorConfig(
                                selectorType:
                                    PhoneInputSelectorType.BOTTOM_SHEET,
                              ),
                              ignoreBlank: false,
                              autoValidateMode: AutovalidateMode.disabled,
                              selectorTextStyle:
                                  const TextStyle(color: Colors.black),
                              textStyle: const TextStyle(fontSize: 19),
                              initialValue: number,
                              textFieldController: controller,
                              formatInput: false,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                              inputBorder: const OutlineInputBorder(),
                              onSaved: (PhoneNumber number) {
                                debugPrint('On Saved: $number');
                              },
                              inputDecoration: InputDecoration.collapsed(
                                  hintText: "Phone number",
                                  fillColor: Get.theme.backgroundColor),
                            ),
                          ),
                        ),
                        Obx(
                          () => (stepProcess.value > 1)
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
                                                    'SMS OTP Code Verification'),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.only(top: 25),
                          child: Obx(() => loading.value
                              ? Container(
                                  padding: const EdgeInsets.all(10),
                                  width: Get.width,
                                  child: Center(
                                    child: MyTheme.loading(),
                                  ),
                                )
                              : stepProcess.value == 1
                                  ? submitButton(x)
                                  : verifyButton(x)),
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
          String dataphone = phoneNumber.value;
          debugPrint("Phone $dataphone");

          if (dataphone.isNotEmpty) {
            EasyLoading.show(status: 'Loading...');
            await Future.delayed(const Duration(milliseconds: 1200));
            //try
            await x.notificationFCMManager.firebaseAuthService
                .loginPhoneUser(dataphone);

            stepProcess.value = 2;
            loading.value = false;

            await Future.delayed(const Duration(milliseconds: 2500));
            EasyLoading.dismiss();
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
        String dataphone = phoneNumber.value;
        String datacode = _codeController.text.trim();
        debugPrint("Phone $dataphone code OTP $datacode");

        if (dataphone.isNotEmpty && datacode.isNotEmpty) {
          //try
          EasyLoading.show(status: 'Loading...');
          final fauth = x.notificationFCMManager.firebaseAuthService;
          await Future.delayed(const Duration(milliseconds: 1200));
          await fauth.doVerifyCode(datacode);
          await Future.delayed(const Duration(milliseconds: 2500));
          String? uid = await fauth.getFirebaseUserId();

          EasyLoading.dismiss();
          if (uid != null && uid.isNotEmpty) {
            final dynamic userData = {
              "uf": uid,
              "phone": dataphone, // uid user firebase
            };

            debugPrint("Goto Email Authentication Screen ...");
            Get.to(EmailAuthScreen(getData: userData));
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
        "Verify",
        style: Get.theme.textTheme.headline6!.copyWith(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
