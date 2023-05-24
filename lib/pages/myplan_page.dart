import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/models/myplan_model.dart';
import 'package:plantripapp/models/post_model.dart';
import 'package:plantripapp/models/user_model.dart';
import 'package:plantripapp/screens/plan_screen.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/input_container.dart';
import 'package:plantripapp/widgets/item_post_vertical.dart';

class MyPlanPage extends StatelessWidget {
  final MyPlanModel myplan;
  const MyPlanPage({Key? key, required this.myplan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final XController x = XController.to;
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
              primary: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: Get.mediaQuery.padding.top * 0.45,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: topHeader(x),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 15, right: 18, left: 18),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Get.theme.backgroundColor,
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: ExtendedImage.network(
                                    myplan.image!,
                                    width: witdhIcon,
                                    height: witdhIcon,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 19, vertical: 5),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "${myplan.title}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 19, vertical: 0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Created ${myplan.dateCreated}",
                                        textAlign: TextAlign.center,
                                        style: textSmallGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        createTabbar(x, myplan.totalItem!),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget createTabbar(final XController x, final int items) {
    debugPrint("items $items");
    return SizedBox(
      width: Get.width,
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Get.width,
              padding: const EdgeInsets.only(top: 20, left: 18, right: 18),
              child: TabBar(
                indicatorColor: Get.theme.primaryColor,
                labelColor: Get.theme.primaryColor,
                unselectedLabelStyle: textSmall.copyWith(fontSize: 16),
                labelStyle: textBig.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                tabs: const [
                  Tab(text: "Places"),
                  Tab(text: "Articles"),
                ],
              ),
            ),
            Container(
              width: Get.width,
              height: Get.height * 2,
              padding: const EdgeInsets.only(top: 20, left: 0, right: 0),
              child: TabBarView(
                children: [
                  myplan.listPlaces().isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.only(
                            top: 5,
                          ),
                          child: listPlaces(x, myplan.listPlaces()),
                        )
                      : SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              spaceHeight20,
                              Image.asset(
                                "assets/not_found.png",
                                height: 150,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Text(
                                  "There's No Place You Save",
                                  style:
                                      Get.theme.textTheme.headline6!.copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Text(
                                  "Search for the place you want then save or by adding a place below",
                                  textAlign: TextAlign.center,
                                  style: textSmall.copyWith(
                                    color: Get.theme.textTheme.caption!.color,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              spaceHeight10,
                              SizedBox(
                                width: Get.width / 2.6,
                                child: InputContainer(
                                  backgroundColor: Get.theme.primaryColor,
                                  radius: 20,
                                  boxBorder: Border.all(width: 0.1),
                                  boxShadow: BoxShadow(
                                    color: Get.theme.backgroundColor
                                        .withOpacity(.3),
                                    offset: const Offset(1, 2),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        debugPrint("clicked...");
                                        openCreatePlace(x);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 8),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 0),
                                              alignment: Alignment.center,
                                              child: Icon(
                                                  BootstrapIcons.plus_circle,
                                                  color: Get
                                                      .theme.backgroundColor),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 2, right: 20),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Add New",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Get
                                                        .theme.backgroundColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(
                    height: Get.height,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 0),
                      child: myplan.listArticles().isEmpty
                          ? SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  spaceHeight20,
                                  Image.asset(
                                    "assets/not_found.png",
                                    height: 150,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                    child: Text(
                                      "There's No Article",
                                      style: Get.theme.textTheme.headline6!
                                          .copyWith(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                    child: Text(
                                      "Create one for new article",
                                      textAlign: TextAlign.center,
                                      style: textSmall.copyWith(
                                        color:
                                            Get.theme.textTheme.caption!.color,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  spaceHeight10,
                                  SizedBox(
                                    width: Get.width / 2.6,
                                    child: InputContainer(
                                      backgroundColor: Get.theme.primaryColor,
                                      radius: 20,
                                      boxBorder: Border.all(width: 0.1),
                                      boxShadow: BoxShadow(
                                        color: Get.theme.backgroundColor
                                            .withOpacity(.3),
                                        offset: const Offset(1, 2),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            debugPrint("clicked...");
                                            openCreateArticle(x);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 8),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, right: 0),
                                                  alignment: Alignment.center,
                                                  child: Icon(
                                                      BootstrapIcons
                                                          .plus_circle,
                                                      color: Get.theme
                                                          .backgroundColor),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 2, right: 20),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Add New",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Get.theme
                                                            .backgroundColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : listArticles(x, myplan.listArticles()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listPlaces(final XController x, final List<PostModel> datas) {
    List<PostModel> infos = [PostModel(title: "more")];
    infos.addAll(datas);

    final double defHeight =
        GetPlatform.isAndroid ? Get.height / 1.9 : Get.height / 2.2;

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: infos.map((e) {
        final int index = infos.indexOf(e);
        return index == 0
            ? Container(
                margin: const EdgeInsets.only(bottom: 10, right: 20, left: 20),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8, right: 5, left: 5),
                  child: InputContainer(
                    backgroundColor: Get.theme.backgroundColor,
                    radius: 15,
                    boxShadow: BoxShadow(
                      color: Colors.grey.withOpacity(.3),
                      offset: const Offset(1, 2),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          debugPrint("clicked...");
                          openCreatePlace(x);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              alignment: Alignment.center,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 5),
                                    alignment: Alignment.center,
                                    child: Icon(BootstrapIcons.plus_circle,
                                        color: Get.theme.primaryColor),
                                  ),
                                  spaceWidth5,
                                  Text(
                                    "Add New",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Get
                                            .theme.textTheme.bodyText2!.color),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : ItemPostVertical(
                x: x,
                post: e,
                defHeight: defHeight,
                isBookmark: false,
                isMyPost: true,
                callback: () {},
              );
      }).toList(),
    );
  }

  openCreateArticle(final XController x) {
    PlanScreen.showDialogAddNewPlaceArticle(
      x,
      "add_new_article".tr,
      (result) {
        if (result != null) {
          if (result['success'] != null && result['success'] == '1') {
            //isRefreshing.value = true;

            Future.microtask(
              () => x.addMorePost(
                PostModel(
                  id: myplan.id,
                  title: result['title'],
                  desc: result['description'],
                  idCategory: "${result['category']}",
                  idCity: "${result['city']}",
                  idUser: x.thisUser.value.id,
                  liked: 0,
                  rating: 0,
                  tag: result['tag'],
                  flag: int.parse(result['flag'] ?? "0"),
                  status: 1,
                  createAt: MyTheme.timeStampNow(),
                  updateAt: MyTheme.timeStampNow(),
                  latitude: x.latitude,
                  location: x.location,
                  totalComment: 0,
                  totalLike: 0,
                  totalRating: 0,
                  totalReport: 0,
                  totalShare: 0,
                  totalView: 1,
                  totalUser: 1,
                  image1: result['image1'] ?? '',
                  image2: result['image2'] ?? '',
                  image3: result['image3'] ?? '',
                  user: UserModel(
                    id: x.thisUser.value.id,
                    fullname: x.thisUser.value.fullname,
                    image: x.thisUser.value.image,
                    username: x.thisUser.value.username,
                  ),
                ),
              ),
            );

            Future.delayed(const Duration(milliseconds: 3500), () {
              //isRefreshing.value = false;
              debugPrint(result.toString());
            });
          }
        }
      },
    );
  }

  openCreatePlace(final XController x) {
    PlanScreen.showDialogAddNewPlaceArticle(
      x,
      "add_new_place".tr,
      (result) {
        if (result != null) {
          if (result['success'] != null && result['success'] == '1') {
            //isRefreshing.value = true;

            Future.microtask(
              () => x.addMorePost(
                PostModel(
                  id: myplan.id,
                  title: result['title'],
                  desc: result['description'],
                  idCategory: "${result['category']}",
                  idCity: "${result['city']}",
                  idUser: x.thisUser.value.id,
                  liked: 0,
                  rating: 0,
                  tag: result['tag'],
                  flag: int.parse(result['flag'] ?? "0"),
                  status: 1,
                  createAt: MyTheme.timeStampNow(),
                  updateAt: MyTheme.timeStampNow(),
                  latitude: x.latitude,
                  location: x.location,
                  totalComment: 0,
                  totalLike: 0,
                  totalRating: 0,
                  totalReport: 0,
                  totalShare: 0,
                  totalView: 1,
                  totalUser: 1,
                  image1: result['image1'] ?? '',
                  image2: result['image2'] ?? '',
                  image3: result['image3'] ?? '',
                  user: UserModel(
                    id: x.thisUser.value.id,
                    fullname: x.thisUser.value.fullname,
                    image: x.thisUser.value.image,
                    username: x.thisUser.value.username,
                  ),
                ),
              ),
            );

            Future.delayed(const Duration(milliseconds: 3500), () {
              //isRefreshing.value = false;
              debugPrint(result.toString());
            });
          }
        }
      },
    );
  }

  Widget listArticles(final XController x, final List<PostModel> datas) {
    List<PostModel> infos = [
      PostModel(title: 'info'),
    ];
    infos.addAll(datas);

    final double defHeight =
        GetPlatform.isAndroid ? Get.height / 1.9 : Get.height / 2.2;

    return SizedBox(
      width: Get.width,
      child: ListView(
        primary: false,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: infos.map((e) {
          final int index = infos.indexOf(e);
          return index == 0
              ? Container(
                  margin:
                      const EdgeInsets.only(bottom: 10, right: 20, left: 20),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8, left: 5, right: 5),
                    child: InputContainer(
                      backgroundColor: Get.theme.backgroundColor,
                      radius: 15,
                      boxShadow: BoxShadow(
                        color: Colors.grey.withOpacity(.3),
                        offset: const Offset(1, 2),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            debugPrint("clicked...");
                            openCreateArticle(x);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                alignment: Alignment.center,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 5),
                                      alignment: Alignment.center,
                                      child: Icon(BootstrapIcons.plus_circle,
                                          color: Get.theme.primaryColor),
                                    ),
                                    spaceWidth5,
                                    Text(
                                      "Add New",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Get.theme.textTheme.bodyText2!
                                              .color),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : ItemPostVertical(
                  x: x,
                  post: e,
                  defHeight: defHeight,
                  isBookmark: false,
                  isMyPost: true,
                  callback: () {},
                );
        }).toList(),
      ),
    );
  }

  Widget topHeader(final XController x) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
              child: const Icon(
                BootstrapIcons.chevron_left,
                size: 20,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 0),
                  child: InputContainer(
                    backgroundColor: Get.theme.backgroundColor,
                    radius: 15,
                    boxShadow: BoxShadow(
                      color: Colors.grey.withOpacity(.3),
                      offset: const Offset(1, 2),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          deleteSinglePlanAsync(x, myplan.id);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 19, vertical: 5),
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Icon(BootstrapIcons.trash,
                                      color: Get.theme.primaryColor, size: 15),
                                  spaceWidth5,
                                  Text(
                                    "Delete",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Get
                                            .theme.textTheme.bodyText2!.color),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  deleteSinglePlanAsync(final XController x, final String? id) async {
    if (id != null && id != '') {
      debugPrint("id $id");
      CoolAlert.show(
          context: Get.context!,
          type: CoolAlertType.confirm,
          text: 'confirm_delete'.tr,
          confirmBtnText: 'yes'.tr,
          cancelBtnText: 'no'.tr,
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: () async {
            Get.back();

            EasyLoading.show(status: 'Loading...');
            await Future.delayed(const Duration(milliseconds: 800), () async {
              final dataPost = jsonEncode({
                "id": id,
                "iu": x.thisUser.value.id,
                "act": "delete",
              });
              debugPrint(dataPost);
              x.provider.pushResponse("plan/get_byid", dataPost);
            });

            await Future.delayed(const Duration(milliseconds: 800), () {
              EasyLoading.showSuccess('deletesuccess'.tr);
              x.asyncHome();

              Future.delayed(const Duration(milliseconds: 1100), () {
                Get.back();
              });
            });
          });
    }
  }
}
