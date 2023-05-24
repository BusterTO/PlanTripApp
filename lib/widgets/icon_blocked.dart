import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/models/user_model.dart';
import 'package:get/get.dart';

class IconBlocked extends StatelessWidget {
  final XController x;
  final UserModel user;

  IconBlocked({Key? key, required this.user, required this.x})
      : super(key: key) {
    isBlocked.value = false;
    //x.getFollowingByIdUser(user.id!) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => iconBlocked(x, isBlocked.value, user));
  }

  final isBlocked = false.obs;
  final totalFollower = 0.obs;

  Widget iconBlocked(
      final XController x, final bool blocked, final UserModel followUser) {
    UserModel defUser = x.thisUser.value;
    final bool isMe = defUser.id == followUser.id;

    return Material(
      type: MaterialType.transparency,
      child: Container(
        alignment: Alignment.bottomCenter,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        padding: const EdgeInsets.all(5),
        child: InkWell(
          onTap: () async {
            //Get.back();
            EasyLoading.show(status: 'Loading...\nComing soon...');
            await Future.delayed(const Duration(milliseconds: 1200), () async {
              EasyLoading.dismiss();
              isBlocked.value = !isBlocked.value; //blocked ? false : true;
              Future.microtask(() async {
                if (!isMe) {}

                await Future.delayed(const Duration(milliseconds: 2200), () {
                  //x.asyncHome();
                });
                if (!isBlocked.value) Get.back();
              });
            });

            if (!isBlocked.value) {
              EasyLoading.showToast('done_thank'.tr);
            } else {
              CoolAlert.show(
                context: Get.context!,
                backgroundColor: Get.theme.backgroundColor,
                type: CoolAlertType.success,
                text: blocked ? "unblocked".tr : "blocked".tr,
              );
            }
          },
          child: AnimatedContainer(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color:
                  blocked ? Get.theme.primaryColor : Get.theme.backgroundColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
              border: Border.all(
                color: blocked ? Colors.transparent : Colors.grey.shade700,
              ),
            ),
            child: Text(
              blocked ? "unblocked".tr : "blocked".tr,
              style: TextStyle(
                fontWeight: blocked ? FontWeight.bold : FontWeight.normal,
                color: blocked
                    ? Colors.white
                    : Get.isDarkMode
                        ? Colors.white
                        : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
