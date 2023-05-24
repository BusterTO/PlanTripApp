import 'dart:convert';
import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:plantripapp/auth/login_screen.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/models/liked_model.dart';
import 'package:plantripapp/models/post_model.dart';
import 'package:plantripapp/models/user_model.dart';
import 'package:plantripapp/pages/list_follower_page.dart';
import 'package:plantripapp/pages/list_post_page.dart';
import 'package:plantripapp/pages/mypost_list_page.dart';
import 'package:plantripapp/screens/setting_screen.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/crop_editor_helper.dart';
import 'package:plantripapp/widgets/input_container.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final XController x = XController.to;
    reloadListAction(x);

    return Obx(
      () => createBody(x, x.isDarkMode.value),
    );
  }

  reloadListAction(final XController x) {
    menuProfiles.value = [
      {
        "title": "${x.thisUser.value.fullname}",
        "subtitle": "Change Name",
        "icon": ""
      },
      {
        "title": "@${x.thisUser.value.username}",
        "subtitle": "Change Username",
        "icon": ""
      },
      {"title": "Password", "subtitle": "Change Password", "icon": ""},
      {"title": "Photo", "subtitle": "Change Photo", "icon": ""},
      {"title": "Setting", "subtitle": "Adjust Setting", "icon": ""},
      {"title": "Version", "subtitle": appVersion, "icon": ""},
    ];
  }

  Widget createBody(final XController x, final bool isDark) {
    UserModel thisUser = x.thisUser.value;
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
                      left: paddingSize,
                      right: paddingSize * 0.6,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Profile",
                          style: Get.theme.textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            confirmLogout();
                          },
                          icon: const Icon(BootstrapIcons.box_arrow_left),
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
                                      uri,
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
                                Get.to(MyPostListPage());
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
                              onTap: () {
                                List<PostModel> posts = [];
                                List<LikedModel> likeds =
                                    x.itemHome.value.liked!;
                                for (var element in likeds) {
                                  if (element.post != null) {
                                    PostModel p = element.post!;
                                    if (p.liked == 1) {
                                      posts.add(p);
                                    }
                                  }
                                }

                                Get.to(ListPostPage(
                                    title: "Bookmark", datas: posts));
                              },
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
                              onTap: () {
                                if (thisUser.totalFollower > 0) {
                                  Get.to(const ListFollowerPage());
                                }
                              },
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
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 25,
                      left: 25,
                      right: 25,
                    ),
                    child: InkWell(
                      onTap: () {
                        showDialogUpdate(x, 'Change AboutMe', 'About Me');
                      },
                      child: Text(
                        thisUser.about ?? " Update about me here ",
                        style: textSmallGrey.copyWith(
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  spaceHeight10,
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: listMenu(x, menuProfiles),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      confirmDelete();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 22),
                      padding: const EdgeInsets.all(5),
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            Get.theme.colorScheme.secondary,
                            Get.theme.colorScheme.secondary.withOpacity(.6)
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Delete Account",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static confirmLogout() {
    return Alert(
      context: Get.context!,
      type: AlertType.warning,
      style: AlertStyle(
        titleStyle: textNormal,
        backgroundColor: Get.theme.backgroundColor,
      ),
      title: "Are you sure to Logout?",
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
            await Future.delayed(const Duration(milliseconds: 1200), () {
              XController.to.signOut();
              Get.offAll(LoginScreen());
              EasyLoading.dismiss();
            });
          },
          gradient: LinearGradient(colors: [
            Get.theme.primaryColor,
            Get.theme.primaryColor.withOpacity(.4)
          ]),
          child: const Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        )
      ],
    ).show();
  }

  static confirmDelete() {
    return Alert(
      context: Get.context!,
      type: AlertType.warning,
      style: AlertStyle(
        titleStyle: textNormal,
        backgroundColor: Get.theme.backgroundColor,
      ),
      title: "Are you sure to Delete your Account?",
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
            await Future.delayed(const Duration(milliseconds: 1200), () {
              XController.to.signOut();
              Get.offAll(LoginScreen());
              EasyLoading.dismiss();
            });
          },
          gradient: LinearGradient(colors: [
            Get.theme.primaryColor,
            Get.theme.primaryColor.withOpacity(.4)
          ]),
          child: const Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        )
      ],
    ).show();
  }

  final menuProfiles = [
    {"title": "...", "subtitle": "Change Name", "icon": ""},
    {"title": "...", "subtitle": "Change Username", "icon": ""},
    {"title": "Password", "subtitle": "Change Password", "icon": ""},
    {"title": "Photo", "subtitle": "Change Photo", "icon": ""},
    {"title": "Setting", "subtitle": "Adjust Setting", "icon": ""},
    {"title": "Version", "subtitle": appVersion, "icon": ""},
  ].obs;

  clickAction(final XController x, final int index) async {
    if (index == 4) {
      await Get.to(const SettingScreen(), transition: Transition.downToUp);
      MyTheme.setAppTheme();
    } else if (index == 0) {
      showDialogUpdate(x, 'Change Name', 'Fullname');
    } else if (index == 1) {
      showDialogUpdate(x, 'Change Username', 'Username');
    } else if (index == 2) {
      showDialogUpdatePassword(x);
    } else if (index == 3) {
      showDialogUpdatePhoto(x, x.thisUser.value.image!);
    }
  }

  Widget listMenu(final XController x, final List<dynamic> menus) {
    return SizedBox(
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: menus.map((e) {
          final int index = menus.indexOf(e);
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                clickAction(x, index);
              },
              child: Stack(
                children: [
                  Container(
                    width: Get.width,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    margin: EdgeInsets.only(
                        left: paddingSize,
                        right: paddingSize,
                        bottom: index >= (menus.length - 1)
                            ? (spaceIcon * 3)
                            : spaceIcon * 1.1),
                    child: InputContainer(
                      backgroundColor: Get.theme.backgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 20, bottom: 0),
                            child: SizedBox(
                              child: Text(
                                "${e['title']}",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  height: 1.2,
                                  color: Get.isDarkMode
                                      ? Get.theme.primaryColorLight
                                      : Get.theme.primaryColor,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 0, bottom: 15),
                            child: Text("${e['subtitle']}",
                                style: const TextStyle(color: Colors.grey)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    right: 42,
                    top: 30,
                    child: Icon(
                      BootstrapIcons.chevron_right,
                      size: 18,
                    ),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  final TextEditingController _input = TextEditingController();
  final validUsername = false.obs;
  final isProcessChecking = false.obs;

  showDialogUpdate(
      final XController x, final String topTitle, final String hint) {
    _input.text = '';

    bool isUsername = false;
    isProcessChecking.value = false;

    if (topTitle == 'Change Name') {
      _input.text = x.thisUser.value.fullname ?? '';
    } else if (topTitle == 'Change AboutMe') {
      _input.text = x.thisUser.value.about ?? '';
    } else if (topTitle == 'Change Username') {
      _input.text = x.thisUser.value.username ?? '';
      validUsername.value = false;
      isUsername = true;
    }

    return showCupertinoModalBottomSheet(
      barrierColor: Get.theme.disabledColor.withOpacity(.4),
      context: Get.context!,
      builder: (context) => Container(
        width: Get.width,
        height: Get.height / 1.5,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Get.theme.backgroundColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(15.0),
            topLeft: Radius.circular(15.0),
          ),
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
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Text(
                                topTitle,
                                style: Get.theme.textTheme.headline5!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      spaceHeight10,
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 0),
                        padding: const EdgeInsets.only(left: 25, right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: LinearGradient(
                            colors: [
                              Get.theme.canvasColor,
                              Get.theme.canvasColor.withOpacity(.98)
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Get.theme.backgroundColor,
                              blurRadius: 1.0,
                              offset: const Offset(1, 2),
                            )
                          ],
                        ),
                        child: SizedBox(
                          width: Get.width,
                          child: TextField(
                            controller: _input,
                            onChanged: (text) {
                              if (isUsername) {
                                if (text.isNotEmpty && text.length > 5) {
                                  Future.delayed(
                                      const Duration(milliseconds: 4500), () {
                                    if (isProcessChecking.value) return;

                                    isProcessChecking.value = true;
                                    //push check username
                                    String textInput = _input.text.trim();
                                    x.provider
                                        .pushResponse("user/check_username",
                                            jsonEncode({"us": textInput}))!
                                        .then((result) {
                                      dynamic dataresult =
                                          jsonDecode(result!.bodyString!);
                                      debugPrint(dataresult.toString());

                                      validUsername.value = false;
                                      if (dataresult['code'] == '200') {
                                        validUsername.value = true;
                                      }

                                      EasyLoading.showToast(
                                          "Username ${validUsername.value ? 'available' : 'already exist, try another one'}");
                                      Future.delayed(
                                          const Duration(milliseconds: 6500),
                                          () {
                                        isProcessChecking.value = false;
                                      });
                                    });
                                  });
                                }
                              }
                            },
                            maxLines: topTitle == 'Change AboutMe' ? 3 : 1,
                            textCapitalization: isUsername
                                ? TextCapitalization.none
                                : TextCapitalization.sentences,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: hint,
                              suffixIcon: isUsername
                                  ? validUsername.value
                                      ? const Icon(BootstrapIcons.check)
                                      : const Icon(BootstrapIcons.x,
                                          color: Colors.red)
                                  : null,
                            ),
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
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              margin: const EdgeInsets.only(
                                  left: 0, right: 0, bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("Close",
                                      style: TextStyle(color: Colors.black))
                                ],
                              ),
                            ),
                          ),
                          spaceWidth10,
                          InkWell(
                            onTap: () async {
                              String input = _input.text.trim();
                              if (input.isEmpty) {
                                MyTheme.showToast('$hint invalid!');
                                return;
                              }

                              if (isUsername) {
                                if (input.length < 7) {
                                  MyTheme.showToast(
                                      'Username min 7 character!');
                                  return;
                                }

                                if (input.length > 20) {
                                  MyTheme.showToast(
                                      'Username too long, max 20 character!');
                                  return;
                                }

                                if (!validUsername.value) {
                                  MyTheme.showToast(
                                      'Username already exist, try another one!');
                                  return;
                                }
                              }

                              Get.back();
                              EasyLoading.show(status: 'Loading...');

                              if (topTitle == 'Change AboutMe') {
                                x.updateUserById('update_about_fullname', input,
                                    x.thisUser.value.fullname!);
                              } else if (topTitle == 'Change Name') {
                                x.updateUserById('update_about_fullname',
                                    x.thisUser.value.about!, input);
                              } else if (topTitle == 'Change Username') {
                                x.updateUserById(
                                    'update_username', input.toLowerCase(), "");
                              }

                              await Future.delayed(
                                  const Duration(milliseconds: 1800), () {});

                              Future.delayed(const Duration(milliseconds: 800),
                                  () {
                                EasyLoading.showSuccess(
                                    'Process successful...');
                                reloadListAction(x);
                              });
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
                                    "Submit",
                                    style: textBold.copyWith(
                                      color: Colors.white,
                                      fontSize: 12,
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

  final TextEditingController _oldPass = TextEditingController();
  final TextEditingController _newPass = TextEditingController();
  final TextEditingController _renewPass = TextEditingController();
  showDialogUpdatePassword(final XController x) {
    _oldPass.text = '';
    _newPass.text = '';
    _renewPass.text = '';

    return showCupertinoModalBottomSheet(
      barrierColor: Get.theme.disabledColor.withOpacity(.4),
      context: Get.context!,
      builder: (context) => Container(
        width: Get.width,
        height: Get.height / 1.2,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Get.theme.backgroundColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(15.0),
            topLeft: Radius.circular(15.0),
          ),
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
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Change Password",
                                style: Get.theme.textTheme.headline5!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      spaceHeight10,
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: LinearGradient(
                            colors: [
                              Get.theme.canvasColor,
                              Get.theme.canvasColor.withOpacity(.98)
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Get.theme.backgroundColor,
                              blurRadius: 1.0,
                              offset: const Offset(1, 2),
                            )
                          ],
                        ),
                        child: SizedBox(
                          width: Get.width,
                          child: TextField(
                            controller: _oldPass,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Old Password",
                            ),
                          ),
                        ),
                      ),
                      spaceHeight10,
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: LinearGradient(
                            colors: [
                              Get.theme.canvasColor,
                              Get.theme.canvasColor.withOpacity(.98)
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Get.theme.backgroundColor,
                              blurRadius: 1.0,
                              offset: const Offset(1, 2),
                            )
                          ],
                        ),
                        child: SizedBox(
                          width: Get.width,
                          child: TextField(
                            controller: _newPass,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "New Password",
                            ),
                          ),
                        ),
                      ),
                      spaceHeight10,
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: LinearGradient(
                            colors: [
                              Get.theme.canvasColor,
                              Get.theme.canvasColor.withOpacity(.98)
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Get.theme.backgroundColor,
                              blurRadius: 1.0,
                              offset: const Offset(1, 2),
                            )
                          ],
                        ),
                        child: SizedBox(
                          width: Get.width,
                          child: TextField(
                            controller: _renewPass,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Retype New Password",
                            ),
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
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              margin: const EdgeInsets.only(
                                  left: 0, right: 0, bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("Close",
                                      style: TextStyle(color: Colors.black))
                                ],
                              ),
                            ),
                          ),
                          spaceWidth10,
                          InkWell(
                            onTap: () async {
                              String oldP = _oldPass.text.trim();
                              String newP = _newPass.text.trim();
                              String renewP = _renewPass.text.trim();

                              if (oldP.isEmpty) {
                                MyTheme.showToast('Old Password invalid!');
                                return;
                              }

                              if (newP.isEmpty || newP.length < 6) {
                                MyTheme.showToast(
                                    'New Password invalid! (min. 6 alphanumeric)');
                                return;
                              }

                              if (renewP.isEmpty || renewP.length < 6) {
                                MyTheme.showToast(
                                    'Retype New Password invalid! (min. 6 alphanumeric)');
                                return;
                              }

                              if (newP != renewP) {
                                MyTheme.showToast('New Password is not equal!');
                                return;
                              }

                              String saveP = x
                                  .notificationFCMManager.firebaseAuthService
                                  .getPassword();

                              if (oldP != saveP) {
                                MyTheme.showToast('Old Password is wrong!');
                                return;
                              }

                              Get.back();
                              EasyLoading.show(status: 'Loading...');
                              await Future.delayed(
                                  const Duration(milliseconds: 1800), () {
                                x.updateUserById('change_password', oldP, newP);
                              });

                              Future.delayed(const Duration(milliseconds: 800),
                                  () {
                                EasyLoading.showSuccess(
                                    'Process successful...');
                              });
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
                                    "Submit",
                                    style: textBold.copyWith(
                                      color: Colors.white,
                                      fontSize: 12,
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

  showDialogUpdatePhoto(final XController x, final String uri) {
    return showCupertinoModalBottomSheet(
      barrierColor: Get.theme.disabledColor.withOpacity(.4),
      context: Get.context!,
      builder: (context) => Container(
        width: Get.width,
        height: Get.height / 1.2,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Get.theme.backgroundColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(15.0),
            topLeft: Radius.circular(15.0),
          ),
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
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Update Photo",
                                style: Get.theme.textTheme.headline5!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      spaceHeight10,
                      SizedBox(
                        width: Get.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: Get.width,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 10,
                              ),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    width: Get.width,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Spacer(),
                                        InputContainer(
                                          backgroundColor:
                                              Get.theme.backgroundColor,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 2),
                                            child: ClipOval(
                                              child: Obx(
                                                () => pathImage.value != ''
                                                    ? ExtendedImage.file(
                                                        File(pathImage.value),
                                                        width: 120,
                                                        height: 110,
                                                        fit: BoxFit.fill,
                                                      )
                                                    : ExtendedImage.network(
                                                        uri,
                                                        width: 120,
                                                        height: 110,
                                                        fit: BoxFit.fill,
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: 20,
                                    right: 20,
                                    bottom: 20,
                                    child: SizedBox(
                                      height: 35,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              pickImageSource(x, 2);
                                            },
                                            child: InputContainer(
                                              backgroundColor:
                                                  Get.theme.backgroundColor,
                                              radius: 15,
                                              boxShadow: BoxShadow(
                                                color:
                                                    Colors.grey.withOpacity(.3),
                                                offset: const Offset(1, 2),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8,
                                                        vertical: 5),
                                                    alignment: Alignment.center,
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                            BootstrapIcons
                                                                .camera,
                                                            color: Get.theme
                                                                .primaryColor,
                                                            size: 20),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              pickImageSource(x, 1);
                                            },
                                            child: InputContainer(
                                              backgroundColor:
                                                  Get.theme.backgroundColor,
                                              radius: 15,
                                              boxShadow: BoxShadow(
                                                color:
                                                    Colors.grey.withOpacity(.3),
                                                offset: const Offset(1, 2),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8,
                                                        vertical: 5),
                                                    alignment: Alignment.center,
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                            BootstrapIcons
                                                                .image,
                                                            color: Get.theme
                                                                .primaryColor,
                                                            size: 20),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      spaceHeight50,
                      spaceHeight20,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              margin: const EdgeInsets.only(
                                  left: 0, right: 0, bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("Close",
                                      style: TextStyle(color: Colors.black))
                                ],
                              ),
                            ),
                          ),
                          spaceWidth10,
                          InkWell(
                            onTap: () async {
                              Get.back();
                              EasyLoading.show(status: 'Loading...');
                              await Future.delayed(
                                  const Duration(milliseconds: 1800), () {});

                              Future.delayed(const Duration(milliseconds: 800),
                                  () {
                                EasyLoading.showSuccess(
                                    'Process successful...');
                              });
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
                                    "Submit",
                                    style: textBold.copyWith(
                                      color: Colors.white,
                                      fontSize: 12,
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
                      child: const Icon(BootstrapIcons.chevron_left, size: 30)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //upload photo profile
  final picker = ImagePicker();
  final pathImage = ''.obs;
  pickImageSource(final XController x, final int tipe) {
    Future<XFile?> file;

    file = picker.pickImage(
        source: tipe == 1 ? ImageSource.gallery : ImageSource.camera,
        maxHeight: 512,
        maxWidth: 512);
    file.then((XFile? pickFile) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (pickFile != null) {
          pathImage.value = pickFile.path;
          _cropImage(x, File(pathImage.value));
        }
      });
    });
  }

  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  Future _cropImage(final XController x, final File imageFile) async {
    Get.dialog(
      Container(
        padding: const EdgeInsets.all(5),
        width: Get.width,
        height: Get.height / 1.2,
        child: Stack(
          children: [
            ExtendedImage.file(
              imageFile,
              fit: BoxFit.contain,
              mode: ExtendedImageMode.editor,
              extendedImageEditorKey: editorKey,
              cacheRawData: true,
              initEditorConfigHandler: (state) {
                return EditorConfig(
                  maxScale: 8.0,
                  cropRectPadding: const EdgeInsets.all(20.0),
                  hitTestSize: 20.0,
                  cropAspectRatio:
                      CropAspectRatios.original, // update your ratio here
                );
              },
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: () {
                  Get.back();
                  cropAction(x);
                },
                icon: Icon(
                  BootstrapIcons.check2_circle,
                  color: Get.theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  cropAction(final XController x) async {
    final Uint8List fileData = Uint8List.fromList(kIsWeb
        ? (await cropImageDataWithDartLibrary(state: editorKey.currentState!))!
        : (await cropImageDataWithNativeLibrary(
            state: editorKey.currentState!))!);

    final String title = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String? fileFath = await ImageSaver.save(title, fileData);

    File tmpFile = File(fileFath!);
    String base64Image = base64Encode(tmpFile.readAsBytesSync());
    String fileName = x.basename(tmpFile.path);
    Future.microtask(() {
      upload(x, fileName, base64Image);
    });
  }

  upload(final XController x, final String fileName,
      final String base64Image) async {
    EasyLoading.show(status: "Loading...");

    String idUser = x.thisUser.value.id!;

    var dataPush = jsonEncode({
      "filename": fileName,
      "id": idUser,
      "image": base64Image,
      "lat": x.latitude,
      "loc": x.location,
    });

    debugPrint("idUser: $idUser");
    var path = "upload/upload_image_user";
    debugPrint(path);

    await Future.delayed(const Duration(milliseconds: 600));

    try {
      final Response? result = await x.provider.pushResponse(path, dataPush);
      dynamic dataresult = jsonDecode(result!.bodyString!);
      debugPrint(dataresult.toString());

      //EasyLoading.dismiss();
      if (dataresult['code'] == '200') {
        EasyLoading.showSuccess("Process success...");
        String fileUploaded = "${dataresult['result']['file']}";
        debugPrint(fileUploaded);

        Future.delayed(const Duration(seconds: 1), () async {
          await x.getUserById();
        });

        Future.delayed(const Duration(seconds: 4), () {
          Future.microtask(() {
            x.asyncHome();
          });
          Get.back();
        });
      } else {
        EasyLoading.showError("Process failed...");
      }
    } catch (e) {
      debugPrint("Error Uploaded ProfileScreen ${e.toString()}");
    }
  }
}
