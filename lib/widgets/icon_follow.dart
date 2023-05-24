import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/models/follow_model.dart';
import 'package:plantripapp/models/user_model.dart';
import 'package:get/get.dart';

class IconFollow extends StatelessWidget {
  final XController x;
  final UserModel user;

  IconFollow({Key? key, required this.user, required this.x})
      : super(key: key) {
    isFollowed.value = x.getFollowingByIdUser(user.id!) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => iconFollow(x, isFollowed.value, user));
  }

  final isFollowed = false.obs;
  final totalFollower = 0.obs;

  Widget iconFollow(
      final XController x, final bool follow, final UserModel followUser) {
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
            EasyLoading.show(status: 'Loading...');
            await Future.delayed(const Duration(milliseconds: 1200), () async {
              final FollowModel? datafollow = await x.followUnFollow(
                  x.thisUser.value.id,
                  followUser.id,
                  follow ? "unfollow" : "follow");
              EasyLoading.dismiss();
              isFollowed.value = follow ? false : true;
              Future.microtask(() async {
                if (!isMe) {
                  if (datafollow != null) defUser = datafollow.user!;

                  if (isFollowed.value) {
                    totalFollower.value = totalFollower.value + 1;
                  } else {
                    totalFollower.value = totalFollower.value - 1;
                  }
                }

                await Future.delayed(const Duration(milliseconds: 2200), () {
                  x.asyncHome();
                });
                if (!isFollowed.value) Get.back();
              });
            });

            if (!isFollowed.value) {
              EasyLoading.showToast('done_thank'.tr);
            } else {
              CoolAlert.show(
                context: Get.context!,
                backgroundColor: Get.theme.backgroundColor,
                type: CoolAlertType.success,
                text: follow ? "unfollow".tr : "following".tr,
                //autoCloseDuration: Duration(seconds: 2),
              );
            }
          },
          child: AnimatedContainer(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color:
                  follow ? Get.theme.primaryColor : Get.theme.backgroundColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
              border: Border.all(
                color: follow ? Colors.transparent : Colors.grey.shade700,
              ),
            ),
            child: Text(
              follow ? "unfollow".tr : "follow".tr,
              style: TextStyle(
                fontWeight: follow ? FontWeight.bold : FontWeight.normal,
                color: follow
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
