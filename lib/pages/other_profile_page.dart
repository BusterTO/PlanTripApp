import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/models/post_model.dart';
import 'package:plantripapp/models/user_model.dart';
import 'package:plantripapp/screens/home_screen.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/icon_blocked.dart';
import 'package:plantripapp/widgets/icon_follow.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OtherProfilePage extends StatelessWidget {
  final UserModel user;
  OtherProfilePage({Key? key, required this.user}) : super(key: key) {
    fetchDataPost("1");
  }

  final dataPlaces = <PostModel>[].obs;
  final dataArticles = <PostModel>[].obs;

  @override
  Widget build(BuildContext context) {
    final XController x = XController.to;

    return Scaffold(
      body: Obx(
        () => createBody(x, x.isDarkMode.value, user),
      ),
    );
  }

  fetchDataPost(final String flag) {
    final XController x = XController.to;
    Future.microtask(() async {
      final dataPost = jsonEncode(
          {"lt": "0,100", "iu": user.id, "lat": x.latitude, "fl": flag});
      debugPrint(dataPost);
      final response =
          await x.provider.pushResponse("post/get_byid_user", dataPost);

      if (response != null && response.statusCode == 200) {
        dynamic dataresult = jsonDecode(response.bodyString!);

        if (dataresult['code'] == '200') {
          List<dynamic>? posts = dataresult['result'];
          List<PostModel> tempPosts = [];
          if (posts != null && posts.isNotEmpty) {
            for (dynamic e in posts) {
              //debugPrint(e.toString());
              try {
                if (flag == e['flag']) {
                  tempPosts.add(PostModel.fromMap(e));
                }
              } catch (e) {
                debugPrint("Error4444 ${e.toString()}");
              }
            }
          }

          debugPrint("Length Post: ${tempPosts.length}");
          if (flag == '1') {
            dataPlaces.value = tempPosts;
          } else {
            dataArticles.value = tempPosts;
          }
        }
      }
    });
  }

  final isFollowedByMe = false.obs;

  Widget createBody(
      final XController x, final bool isDark, final UserModel thisUser) {
    String uri = thisUser.image!;
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
                  Padding(
                    padding: EdgeInsets.only(
                      top: Get.mediaQuery.padding.top * 0.45,
                      left: 5, //paddingSize,
                      right: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(BootstrapIcons.chevron_left),
                        ),
                        Row(
                          children: [
                            IconFollow(user: user, x: x),
                            IconBlocked(user: user, x: x),
                            const SizedBox(width: 5),
                            InkWell(
                              onTap: () {
                                Alert(
                                  context: Get.context!,
                                  type: AlertType.warning,
                                  style: AlertStyle(
                                    titleStyle: textNormal,
                                    backgroundColor: Get.theme.backgroundColor,
                                  ),
                                  title: "Are you sure to report this User?",
                                  buttons: [
                                    DialogButton(
                                      onPressed: () => Get.back(),
                                      color: Colors.grey[400],
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    DialogButton(
                                      onPressed: () async {
                                        Get.back();
                                        EasyLoading.show(status: 'Loading...');
                                        await Future.delayed(
                                            const Duration(milliseconds: 1200),
                                            () {
                                          EasyLoading.dismiss();
                                          EasyLoading.showSuccess(
                                              'Done. Thank you..');
                                        });
                                      },
                                      gradient: LinearGradient(colors: [
                                        Get.theme.primaryColor,
                                        Get.theme.primaryColor.withOpacity(.4)
                                      ]),
                                      child: const Text(
                                        "Yes",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    )
                                  ],
                                ).show();
                              },
                              child: const Icon(
                                  BootstrapIcons.exclamation_octagon_fill),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: paddingSize, right: paddingSize, bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.dialog(MyTheme.photoView(uri));
                            },
                            child: SizedBox(
                              child: CircleAvatar(
                                radius: 31,
                                backgroundColor: Get.theme.primaryColorLight,
                                child: CircleAvatar(
                                  radius: 29,
                                  child: ClipOval(
                                    child: ExtendedImage.network(
                                      thisUser.image!,
                                      cache: true,
                                      fit: BoxFit.cover,
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          spaceWidth10,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                thisUser.fullname!,
                                style: Get.theme.textTheme.headline6!
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                              Text(thisUser.email!, style: textSmallGrey),
                              Text(
                                "@${thisUser.username}",
                                style: Get.theme.textTheme.headline6!.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Get.isDarkMode
                                        ? Get.theme.primaryColorLight
                                        : Get.theme.primaryColor),
                              ),
                              Text(
                                  "Since ${MyTheme.formattedComment(thisUser.dateCreated!)}",
                                  style: textSmallGrey.copyWith(
                                      fontSize: 10, color: Colors.deepOrange)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                //Get.to(MyPostListPage());
                              },
                              child: SizedBox(
                                width: Get.width / 5,
                                child: Column(
                                  children: [
                                    const Icon(BootstrapIcons.geo_alt,
                                        size: iconSize),
                                    spaceHeight5,
                                    Text(MyTheme.numberFormatDisplay(
                                        thisUser.totalPost)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(color: Get.theme.disabledColor),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              child: SizedBox(
                                width: Get.width / 5,
                                child: Column(
                                  children: [
                                    const Icon(BootstrapIcons.bookmark,
                                        size: iconSize),
                                    spaceHeight5,
                                    Text(MyTheme.numberFormatDisplay(
                                        thisUser.totalLike)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(color: Get.theme.disabledColor),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              child: SizedBox(
                                width: Get.width / 5,
                                child: Column(
                                  children: [
                                    const Icon(BootstrapIcons.star,
                                        size: iconSize),
                                    spaceHeight5,
                                    Text(MyTheme.numberFormatDisplay(
                                        thisUser.totalComment)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(color: Get.theme.disabledColor),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              child: SizedBox(
                                width: Get.width / 5,
                                child: Column(
                                  children: [
                                    const Icon(BootstrapIcons.person_plus,
                                        size: iconSize),
                                    spaceHeight5,
                                    Text(MyTheme.numberFormatDisplay(
                                        thisUser.totalFollower)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (thisUser.about != null && thisUser.about!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 25,
                        left: 25,
                        right: 25,
                      ),
                      child: Text(
                        thisUser.about ?? "",
                        style: textSmallGrey.copyWith(
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  spaceHeight10,
                  topRightMenu(),
                  spaceHeight20,
                  spaceHeight10,
                  Obx(() => HomeScreen.listTopPosts(
                      x,
                      selectedMenu.value == 0 ? dataPlaces : dataArticles,
                      false,
                      false,
                      null)),
                  spaceHeight50,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final List<String> menus = ["Place", "Article"];
  final selectedMenu = 0.obs;

  Widget topRightMenu() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
      child: Obx(
        () => Row(
          children: menus.map((e) {
            final index = menus.indexOf(e);
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  selectedMenu.value = index;
                  if (index == 0) {
                    fetchDataPost("1");
                  } else {
                    fetchDataPost("2");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e,
                        style: textTitle.copyWith(
                            fontSize: selectedMenu.value == index ? 16 : 14,
                            color: selectedMenu.value == index
                                ? Get.theme.textTheme.bodyText1!.color!
                                : Colors.grey),
                      ),
                      if (selectedMenu.value == index)
                        Container(
                          color: Get.theme.primaryColor,
                          width: 30,
                          height: 5,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
