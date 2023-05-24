import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/models/liked_model.dart';
import 'package:plantripapp/models/post_model.dart';
import 'package:plantripapp/pages/list_post_page.dart';
import 'package:plantripapp/screens/profile_screen.dart';
import 'package:plantripapp/screens/setting_screen.dart';
import 'package:plantripapp/theme.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback? closeDrawer;
  final Function(int index)? goMenu;

  const CustomDrawer({Key? key, this.closeDrawer, this.goMenu})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final XController x = XController.to;
    return Container(
      color: Get.theme.scaffoldBackgroundColor,
      width: Get.width * 0.80,
      height: Get.height,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: Get.height / 3,
              color: Colors.grey.withAlpha(20),
              child: InkWell(
                onTap: () {
                  debugPrint("Tapped Photo Profile");
                  closeDrawer!();
                  goMenu!(4);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 30),
                      child: ClipOval(
                        child: ExtendedImage.network(
                          x.thisUser.value.image!,
                          width: 90,
                          height: 90,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    spaceHeight10,
                    Text(x.thisUser.value.fullname!),
                    Text(x.thisUser.value.email!, style: textSmallGrey),
                    Text(
                      "@${x.thisUser.value.username!}",
                      style: Get.theme.textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Get.theme.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              onTap: () {
                debugPrint("Tapped Profile");
                closeDrawer!();
                goMenu!(4);
              },
              leading: const Icon(BootstrapIcons.person),
              title: Text("your_profile".tr),
            ),
            const Divider(
              height: 1,
              color: Colors.grey,
            ),
            ListTile(
              onTap: () {
                debugPrint("Tapped Bookmark");
                closeDrawer!();
                //goMenu!(4);

                List<PostModel> posts = [];
                List<LikedModel> likeds = x.itemHome.value.liked!;
                for (var element in likeds) {
                  if (element.post != null) {
                    PostModel p = element.post!;
                    if (p.liked == 1) {
                      posts.add(p);
                    }
                  }
                }

                Get.to(ListPostPage(title: "Bookmark", datas: posts));
              },
              leading: const Icon(BootstrapIcons.bookmark),
              title: const Text("Bookmark"),
            ),
            const Divider(
              height: 1,
              color: Colors.grey,
            ),
            ListTile(
              onTap: () {
                debugPrint("Tapped Chat");
                closeDrawer!();
                goMenu!(5);
              },
              leading: const Icon(BootstrapIcons.chat),
              title: const Text(
                "Chat",
              ),
            ),
            const Divider(
              height: 1,
              color: Colors.grey,
            ),
            ListTile(
              onTap: () {
                debugPrint("Tapped settings");
                closeDrawer!();
                Get.to(const SettingScreen(), transition: Transition.downToUp);
              },
              leading: const Icon(BootstrapIcons.gear),
              title: Text("setting".tr),
            ),
            const Divider(
              height: 1,
              color: Colors.grey,
            ),
            ListTile(
              onTap: () {
                debugPrint("Tapped Notifications");
                closeDrawer!();
                goMenu!(7);
              },
              leading: const Icon(BootstrapIcons.bell),
              title: Text("notification".tr),
            ),
            const Divider(
              height: 1,
              color: Colors.grey,
            ),
            ListTile(
              onTap: () {
                debugPrint("Tapped Log Out");
                closeDrawer!();

                Future.microtask(() => ProfileScreen.confirmLogout());
              },
              leading: const Icon(BootstrapIcons.box_arrow_left),
              title: const Text("Log Out"),
            ),
            spaceHeight20,
          ],
        ),
      ),
    );
  }
}
