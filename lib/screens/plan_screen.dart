import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/models/category_model.dart';
import 'package:plantripapp/models/city_model.dart';
import 'package:plantripapp/models/myplan_model.dart';
import 'package:plantripapp/pages/myplan_page.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/checkbox_plan.dart';
import 'package:plantripapp/widgets/input_container.dart';
import 'package:plantripapp/widgets/item_upload_image.dart';

class PlanScreen extends StatelessWidget {
  PlanScreen({Key? key}) : super(key: key) {
    final XController x = XController.to;
    if (x.itemHome.value.myplans != null &&
        x.itemHome.value.myplans!.isNotEmpty) {
      myplans.value = x.itemHome.value.myplans!;
    }
  }

  static final isSelected = false.obs;
  static final myplans = <MyPlanModel>[].obs;
  @override
  Widget build(BuildContext context) {
    final XController x = XController.to;

    return Obx(
      () => createBody(x, myplans, x.isDarkMode.value),
    );
  }

  Widget createBody(
      final XController x, final List<MyPlanModel> models, final bool isDark) {
    int totalPlan = 0;
    try {
      totalPlan = models.length;
    } catch (e) {
      debugPrint("Err ${e.toString()}");
    }
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
                      top: Get.mediaQuery.padding.top * 0.25,
                      left: paddingSize,
                      right: paddingSize * 0.45,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$totalPlan Plan(s)",
                          style: Get.theme.textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Obx(
                          () => createCustomPopupPlan(
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(BootstrapIcons.three_dots),
                              ),
                              isSelected.value),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InputContainer(
                            backgroundColor: Get.theme.backgroundColor,
                            radius: 20,
                            boxBorder: Border.all(width: 0.1),
                            boxShadow: BoxShadow(
                              color: Get.theme.primaryColor.withOpacity(.3),
                              offset: const Offset(1, 2),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  debugPrint("clicked...");
                                  showDialogAddPlan(
                                    x,
                                    "add_new_plan".tr,
                                    (result) {},
                                  );
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
                                            left: 20, right: 5),
                                        alignment: Alignment.center,
                                        child: Icon(BootstrapIcons.plus_circle,
                                            color: Get.theme.primaryColor),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 2, right: 20),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "new_plan".tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Get.theme.textTheme
                                                  .bodyText2!.color),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Obx(
                            () => !isSelected.value
                                ? spaceWidth10
                                : InputContainer(
                                    backgroundColor: Get.theme.backgroundColor,
                                    radius: 20,
                                    boxBorder: Border.all(width: 0.1),
                                    boxShadow: BoxShadow(
                                      color: Get.theme.primaryColor
                                          .withOpacity(.3),
                                      offset: const Offset(1, 2),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          debugPrint("clicked...");
                                          deleteAllPlanAsync(x, myplans);
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
                                                    left: 20, right: 5),
                                                alignment: Alignment.center,
                                                child: Icon(
                                                    BootstrapIcons.trash,
                                                    color:
                                                        Get.theme.primaryColor),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 2, right: 20),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Selected".tr,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Get.theme.textTheme
                                                          .bodyText2!.color),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Obx(
                      () => x.itemHome.value.myplans != null &&
                              x.itemHome.value.myplans!.isNotEmpty
                          ? listPlans(
                              x.itemHome.value.myplans!, isSelected.value)
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
                                      "There's No Plan",
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
                                      "Create the new one with button New Plan click",
                                      textAlign: TextAlign.center,
                                      style: textSmall.copyWith(
                                        color:
                                            Get.theme.textTheme.caption!.color,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  spaceHeight10,
                                ],
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

  // delete plan function
  static deleteAllPlanAsync(
      final XController x, final List<MyPlanModel>? plans) async {
    if (plans != null && plans.isNotEmpty) {
      var ids = "";
      for (var element in plans) {
        if (element.isSelected!) {
          ids = "${element.id},$ids";
        }
      }

      debugPrint("ids $ids");
      if (ids == '') {
        MyTheme.showToast('No data selected!');
        return;
      }

      if (ids != '') {
        CoolAlert.show(
            context: Get.context!,
            type: CoolAlertType.confirm,
            text: 'want_to_continue'.tr,
            confirmBtnText: 'yes'.tr,
            cancelBtnText: 'no'.tr,
            confirmBtnColor: Colors.green,
            onConfirmBtnTap: () async {
              Get.back();

              EasyLoading.show(status: 'Loading...');
              await Future.delayed(const Duration(milliseconds: 800), () async {
                final dataPost = jsonEncode({
                  "ids": ids,
                  "iu": x.thisUser.value.id,
                  "act": "delete",
                });
                debugPrint(dataPost);
                x.provider.pushResponse("plan/get_byid", dataPost);
              });

              await Future.delayed(const Duration(milliseconds: 800), () {
                EasyLoading.showSuccess('deletesuccess'.tr);
                x.asyncHome();

                Future.delayed(const Duration(milliseconds: 1600), () {
                  if (x.itemHome.value.myplans != null &&
                      x.itemHome.value.myplans!.isNotEmpty) {
                    myplans.value = x.itemHome.value.myplans!;
                  } else {
                    myplans.value = [];
                  }
                });
                isSelected.value = false;
                Get.back();
              });
            });
      }
    }
  }

  Widget listPlans(final List<MyPlanModel>? plans, final bool selected) {
    List<MyPlanModel> infos = [];
    if (plans != null && plans.isNotEmpty) {
      infos = plans.reversed.toList();
    }

    return SizedBox(
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: infos.map((e) {
          final int index = infos.indexOf(e);
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Get.to(MyPlanPage(myplan: e));
              },
              child: Stack(
                children: [
                  Container(
                    width: Get.width,
                    height: GetPlatform.isAndroid
                        ? Get.height / 3
                        : Get.height / 3.6,
                    margin: EdgeInsets.only(
                        left: paddingSize,
                        right: paddingSize,
                        bottom: index >= (infos.length - 1)
                            ? (spaceIcon * 3)
                            : spaceIcon * 1.5),
                    child: InputContainer(
                      backgroundColor: Get.theme.backgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Get.theme.backgroundColor,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  topLeft: Radius.circular(15),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  topLeft: Radius.circular(15),
                                ),
                                child: ExtendedImage.network(
                                  e.image!,
                                  width: Get.width,
                                  height: witdhIcon * 1.75,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 5, bottom: 5),
                            child: SizedBox(
                              child: Text(
                                "${e.title}",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text("${e.totalItem} Items",
                                style: const TextStyle(color: Colors.grey)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (selected)
                    Positioned(
                      top: 10,
                      right: 30,
                      child: CheckBoxPlan(
                        model: e,
                        callback: (checked) {
                          e.isSelected = checked;
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // add new plan
  static final TextEditingController _title = TextEditingController();
  static final TextEditingController _tag = TextEditingController();
  static final TextEditingController _description = TextEditingController();

  static final imageSelected = 0.obs;

  // type 1 = image gallery pick, 2 = image camera photo, 3 = video pick gallery
  static final imageType = 0.obs;

  static final fileImage1 = ''.obs;
  static final fileImage2 = ''.obs;
  static final fileImage3 = ''.obs;
  static final catSelected = 0.obs;
  static final citySelected = 0.obs;

  static showDialogAddNewPlaceArticle(final XController x,
      final String topTitle, final Function(dynamic result) callback) {
    _title.text = '';
    _description.text = '';
    _tag.text = '';

    imageType.value = 0;
    imageSelected.value = 0;
    catSelected.value = 0;
    citySelected.value = 0;

    fileImage1.value = '';
    fileImage2.value = '';
    fileImage3.value = '';

    final List<CategoryModel> categModels = x.itemHome.value.categories!;
    final List<CityModel> cityModels = x.itemHome.value.cities!;

    return showCupertinoModalBottomSheet(
      barrierColor: Get.theme.disabledColor.withOpacity(.4),
      context: Get.context!,
      builder: (context) => Container(
        width: Get.width,
        height: Get.height / 1,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
          padding: const EdgeInsets.only(top: 11),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  width: Get.width,
                  height: Get.height * 2.5,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        margin: const EdgeInsets.only(top: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                        child: Container(
                          padding: const EdgeInsets.only(top: 0, bottom: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Text(
                                topTitle,
                                style: Get.theme.textTheme.headline6!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 5,
                                    left: paddingSize,
                                    right: paddingSize),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(BootstrapIcons.geo_alt_fill,
                                        size: 11,
                                        color: Get.theme.primaryColor),
                                    spaceWidth5,
                                    Text(x.location, style: textSmallGrey),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Get.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: Get.width,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.zero,
                                    width: Get.width,
                                    height: 160,
                                    child: Obx(
                                      () => Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              imageSelected.value = 0;
                                            },
                                            child: ItemUploadImage(
                                              counter: "1",
                                              selected:
                                                  imageSelected.value == 0,
                                              type: imageType.value,
                                              callback: (String path) {
                                                fileImage1.value = path;
                                                imageType.value = 0;
                                              },
                                              uriToUpload: fileImage1.value,
                                            ),
                                          ),
                                          spaceWidth5,
                                          InkWell(
                                            onTap: () {
                                              imageSelected.value = 1;
                                            },
                                            child: ItemUploadImage(
                                              counter: "2",
                                              selected:
                                                  imageSelected.value == 1,
                                              type: imageType.value,
                                              callback: (String path) {
                                                fileImage2.value = path;
                                                imageType.value = 0;
                                              },
                                              uriToUpload: fileImage2.value,
                                            ),
                                          ),
                                          spaceWidth5,
                                          InkWell(
                                            onTap: () {
                                              imageSelected.value = 2;
                                            },
                                            child: ItemUploadImage(
                                              counter: "3",
                                              selected:
                                                  imageSelected.value == 2,
                                              type: imageType.value,
                                              callback: (String path) {
                                                fileImage3.value = path;
                                                imageType.value = 0;
                                              },
                                              uriToUpload: fileImage3.value,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 20,
                                    right: 20,
                                    bottom: 0,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 30),
                                      height: 35,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              imageType.value = 2;
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
                                          spaceWidth5,
                                          InkWell(
                                            onTap: () {
                                              MyTheme.showToast(
                                                  'Coming soon...');
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
                                                                .camera_video,
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
                                          spaceWidth5,
                                          InkWell(
                                            onTap: () {
                                              imageType.value = 1;
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
                      spaceHeight10,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Obx(
                          () => SizedBox(
                            height: 40,
                            child: ListView(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: categModels.map((e) {
                                final int idx = categModels.indexOf(e);
                                return InkWell(
                                  onTap: () => catSelected.value = idx,
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(10),
                                    margin: EdgeInsets.only(
                                        left: idx == 0 ? 20 : 10, right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: idx == catSelected.value
                                          ? Get.theme.primaryColor
                                          : Get.theme.canvasColor,
                                    ),
                                    child: Text(
                                      "${e.title}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: idx == catSelected.value
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      spaceHeight10,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Obx(
                          () => SizedBox(
                            height: 40,
                            child: ListView(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: cityModels.map((e) {
                                final int idx = cityModels.indexOf(e);
                                return InkWell(
                                  onTap: () => citySelected.value = idx,
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(10),
                                    margin: EdgeInsets.only(
                                        left: idx == 0 ? 20 : 10, right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: idx == citySelected.value
                                          ? Get.theme.primaryColor
                                          : Get.theme.canvasColor,
                                    ),
                                    child: Text(
                                      "${e.title}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: idx == citySelected.value
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      spaceHeight20,
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
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
                            controller: _tag,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Tag (flutter, flight, places) *",
                            ),
                          ),
                        ),
                      ),
                      spaceHeight10,
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
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
                            controller: _title,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "${'title'.tr} *",
                            ),
                          ),
                        ),
                      ),
                      spaceHeight10,
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
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
                            controller: _description,
                            maxLines: 3,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "${'description'.tr} *",
                            ),
                          ),
                        ),
                      ),
                      spaceHeight20,
                      Flexible(
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  margin: const EdgeInsets.only(
                                      left: 0, right: 0, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("close".tr,
                                          style: const TextStyle(
                                              color: Colors.black))
                                    ],
                                  ),
                                ),
                              ),
                              spaceWidth10,
                              InkWell(
                                onTap: () async {
                                  String tag = _tag.text.trim();
                                  if (tag.isEmpty || tag.length < 3) {
                                    MyTheme.showToast(
                                        'Tag invalid! (min. 3 character)');
                                    return;
                                  }

                                  String title = _title.text.trim();
                                  if (title.isEmpty || tag.length < 6) {
                                    MyTheme.showToast(
                                        'Title invalid! (min. 6 charachter)');
                                    return;
                                  }

                                  String note = _description.text.trim();
                                  if (note.isEmpty || tag.length < 15) {
                                    MyTheme.showToast(
                                        'Description invalid! (min. 15 charachter)');
                                    return;
                                  }

                                  CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.confirm,
                                      text: 'want_to_proceed'.tr,
                                      confirmBtnText: 'yes'.tr,
                                      cancelBtnText: 'no'.tr,
                                      confirmBtnColor: Colors.green,
                                      onConfirmBtnTap: () async {
                                        Get.back();

                                        EasyLoading.show(status: 'Loading...');
                                        await Future.delayed(
                                            const Duration(milliseconds: 600));
                                        Get.back();

                                        callback({
                                          "success": "1",
                                          "flag": (topTitle
                                                      .contains('Article') ||
                                                  topTitle.contains('Artikel'))
                                              ? "2"
                                              : "1",
                                          "title": title,
                                          "category":
                                              categModels[catSelected.value].id,
                                          "city":
                                              cityModels[citySelected.value].id,
                                          "tag": tag,
                                          "description": note,
                                          "image1": fileImage1.value == ''
                                              ? null
                                              : fileImage1.value,
                                          "image2": fileImage2.value == ''
                                              ? null
                                              : fileImage2.value,
                                          "image3": fileImage3.value == ''
                                              ? null
                                              : fileImage3.value,
                                        });

                                        await Future.delayed(
                                            const Duration(milliseconds: 1800),
                                            () {});

                                        Future.delayed(
                                            const Duration(milliseconds: 800),
                                            () {
                                          EasyLoading.showSuccess(
                                              'Process successful...');
                                          x.asyncHome();
                                        });
                                      });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  margin: const EdgeInsets.only(
                                      left: 0, right: 0, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Get.theme.primaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                        ),
                      ),
                      spaceHeight20,
                      spaceHeight50,
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

  static final CustomPopupMenuController _controllerPopup =
      CustomPopupMenuController();
  static Widget createCustomPopupPlan(final Widget child, final bool selected) {
    return SizedBox(
      child: CustomPopupMenu(
        controller: _controllerPopup,
        menuBuilder: () => ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: Get.width / 2.5,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            color: Get.theme.cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _controllerPopup.hideMenu();
                    isSelected.value = !isSelected.value;
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          isSelected.value
                              ? BootstrapIcons.x
                              : BootstrapIcons.check_circle,
                          size: 15,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            isSelected.value ? "Deselect" : "Select",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _controllerPopup.hideMenu();
                    final XController x = XController.to;
                    final List<MyPlanModel> origins =
                        x.itemHome.value.myplans ?? [];
                    if (origins.isNotEmpty) {
                      List<MyPlanModel> plans = [];
                      for (var element in origins) {
                        MyPlanModel mp = element;
                        mp.isSelected = true;
                        plans.add(mp);
                      }

                      if (plans.isNotEmpty) {
                        deleteAllPlanAsync(x, plans);
                      }
                    }
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          BootstrapIcons.x_circle,
                          size: 15,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text(
                            "Delete All",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        pressType: PressType.singleClick,
        horizontalMargin: -10,
        verticalMargin: -20,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: child,
        ),
      ),
    );
  }

  // add new plan
  static showDialogAddPlan(final XController x, final String title,
      final Function(dynamic result) callback) {
    _title.text = '';
    _description.text = '';
    imageType.value = 0;
    imageSelected.value = 0;

    return showCupertinoModalBottomSheet(
      barrierColor: Get.theme.disabledColor.withOpacity(.4),
      context: Get.context!,
      builder: (context) => Container(
        width: Get.width,
        height: Get.height * 3,
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
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        margin: const EdgeInsets.only(top: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        child: Container(
                          padding: const EdgeInsets.only(top: 0, bottom: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Text(
                                title,
                                style: Get.theme.textTheme.headline5!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Get.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: Get.width,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 5),
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.zero,
                                    width: Get.width,
                                    height: 160,
                                    child: Obx(
                                      () => Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: defAvatar.map((e) {
                                          final int idx = defAvatar.indexOf(e);
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Stack(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    imageSelected.value = idx;
                                                  },
                                                  child: InputContainer(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    backgroundColor:
                                                        imageSelected.value ==
                                                                idx
                                                            ? Get.theme
                                                                .primaryColor
                                                                .withOpacity(.9)
                                                            : Colors.grey[100],
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        25,
                                                      ),
                                                      child:
                                                          ExtendedImage.network(
                                                        e,
                                                        height: 80,
                                                        width: 80,
                                                        fit: BoxFit.fitWidth,
                                                        cache: true,
                                                        compressionRatio: 0.01,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                if (imageSelected.value == idx)
                                                  Positioned(
                                                    bottom: 10,
                                                    right: 10,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Get.theme
                                                            .backgroundColor,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(
                                                            10,
                                                          ),
                                                        ),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                        2,
                                                      ),
                                                      child: Icon(
                                                        BootstrapIcons
                                                            .check2_circle,
                                                        color: Get
                                                            .theme.primaryColor,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 20,
                                    right: 20,
                                    bottom: 0,
                                    child: SizedBox(
                                      height: 35,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                              "Select  your default avatar..."),
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
                            controller: _title,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Title *",
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
                            textInputAction: TextInputAction.done,
                            controller: _description,
                            maxLines: 6,
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Description *",
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
                              String title = _title.text.trim();
                              if (title.isEmpty) {
                                MyTheme.showToast('Title invalid!');
                                return;
                              }

                              String note = _description.text.trim();
                              if (note.isEmpty) {
                                MyTheme.showToast('Description invalid!');
                                return;
                              }

                              var dataPush = jsonEncode({
                                "iu": x.thisUser.value.id,
                                "im": defAvatar[imageSelected.value],
                                "tl": title,
                                "ds": note,
                              });

                              debugPrint(dataPush);

                              Get.back();
                              EasyLoading.show(status: 'Loading...');

                              await Future.delayed(
                                  const Duration(milliseconds: 600), () {
                                x.provider
                                    .pushResponse('post/add_plan', dataPush);
                              });

                              Future.delayed(const Duration(milliseconds: 1200),
                                  () {
                                x.asyncHome();
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
}
