import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/models/city_category_model.dart';
import 'package:plantripapp/models/comment_model.dart';
import 'package:plantripapp/models/post_model.dart';
import 'package:plantripapp/pages/gallery_photo.dart';
import 'package:plantripapp/pages/map_page.dart';
import 'package:plantripapp/pages/other_profile_page.dart';
import 'package:plantripapp/pages/reviewlist_page.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/input_container.dart';

class PlacePage extends StatelessWidget {
  final PostModel postModel;
  PlacePage({Key? key, required this.postModel}) : super(key: key) {
    thisPost.value = postModel;
  }

  final thisPost = PostModel().obs;

  @override
  Widget build(BuildContext context) {
    final XController x = XController.to;
    debugPrint("PlacePage onBuild...");

    return Container(
      width: Get.width,
      height: Get.height,
      color: Get.theme.backgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.zero,
            width: Get.width,
            height: Get.height,
            color: Colors.transparent,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: Get.mediaQuery.padding.top * 0.35,
                      left: paddingSize * 0.8,
                      right: paddingSize * 0.8,
                    ),
                    child: Obx(() => createBody(x, thisPost.value)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget createBody(final XController x, final PostModel placeModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        topHeader(placeModel),
        Padding(
          padding: const EdgeInsets.only(bottom: 15, right: 0),
          child: (placeModel.listObjectImages().isNotEmpty)
              ? createSlider(placeModel.listObjectImages())
              : Container(
                  decoration: BoxDecoration(
                    color: Get.theme.backgroundColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: ExtendedImage.asset(
                      placeModel.getDefaultImage(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
        ),
        Row(
          children: [
            InputContainer(
              backgroundColor: Get.theme.primaryColorLight,
              radius: 15,
              boxShadow: BoxShadow(
                color: Colors.grey.withOpacity(.3),
                offset: const Offset(1, 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 19, vertical: 5),
                    alignment: Alignment.center,
                    child: Text(
                      "${placeModel.location}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
            spaceWidth10,
            InputContainer(
              backgroundColor: Get.theme.primaryColorLight,
              radius: 15,
              boxShadow: BoxShadow(
                color: Colors.grey.withOpacity(.3),
                offset: const Offset(1, 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 19, vertical: 5),
                    alignment: Alignment.center,
                    child: Text(
                      "${placeModel.nmCategory}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 15, bottom: 10, left: 5, right: 0),
          child: Text("${placeModel.title}",
              style: Get.theme.textTheme.headline5!
                  .copyWith(fontWeight: FontWeight.w900)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 0, bottom: 10, top: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text("${placeModel.getRating()}",
                      style: textBold.copyWith(fontSize: 15)),
                  spaceWidth5,
                  RatingBar.builder(
                    initialRating: placeModel.rating!,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    ignoreGestures: true,
                    itemSize: 20,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => const Icon(
                      BootstrapIcons.star_fill,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      debugPrint(rating.toString());
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(0),
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
                        debugPrint("clicked...");
                        final result = await PlacePage.showDialogInputReview(
                            x, placeModel, null);
                        debugPrint(result.toString());

                        if (result != null) {
                          var jsonBody = jsonEncode({
                            "id": placeModel.id,
                            "iu": x.thisUser.value.id,
                            "lat": x.latitude,
                          });
                          final response = await x.provider
                              .pushResponse('post/get_byid', jsonBody);
                          if (response != null && response.statusCode == 200) {
                            String respString = response.bodyString!;
                            //debugPrint(respString);
                            dynamic dataresult = jsonDecode(respString);
                            if (dataresult['result'] != null &&
                                dataresult['result'].length > 0) {
                              final dynamic datapost = dataresult['result'][0];
                              thisPost.value = PostModel.fromMap(datapost);
                            }
                          }
                          await Future.delayed(
                              const Duration(milliseconds: 2200));
                          x.asyncHome();
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Icon(Icons.send,
                                    color: Get.theme.primaryColor, size: 22),
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
        Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 15, left: 5, right: 0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Get.theme.primaryColorLight,
                child: ClipOval(
                  child: ExtendedImage.network(
                    placeModel.user!.image!,
                    fit: BoxFit.cover,
                    width: 26,
                  ),
                ),
              ),
              spaceWidth10,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${placeModel.user!.fullname}",
                      style: textBold.copyWith(fontSize: 16)),
                  Text(MyTheme.formattedTimeFromString(placeModel.createAt!),
                      style: textSmallGrey)
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 15, left: 5, right: 0),
          child: Text(
            "${placeModel.desc}",
            style: textSmallGrey.copyWith(fontSize: 16),
          ),
        ),
        (placeModel.topThreeComments().isEmpty)
            ? SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, left: 5, right: 0),
                  child: Text(
                    "No Review Yet",
                    style: textBold.copyWith(fontSize: 16),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 0, left: 5, right: 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Review",
                      style: textBold.copyWith(fontSize: 16),
                    ),
                    IconButton(
                      constraints: const BoxConstraints(),
                      iconSize: 18,
                      onPressed: () {
                        if (placeModel.topThreeComments().isNotEmpty) {
                          Get.to(
                              ReviewListPage(comments: placeModel.comments!));
                        }
                      },
                      icon: const Icon(BootstrapIcons.chevron_right),
                    ),
                  ],
                ),
              ),
        if (placeModel.topThreeComments().isNotEmpty)
          Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 0),
            child: listPlaceReview(x, placeModel.topThreeComments()),
          ),
        spaceHeight50,
      ],
    );
  }

  Widget createSlider(final List<dynamic> sliders) {
    return SizedBox(
      height: Get.height / 5,
      width: Get.width,
      child: Carousel(
        boxFit: BoxFit.cover,
        autoplay: true,
        autoplayDuration: const Duration(milliseconds: 1000 * 22),
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: const Duration(milliseconds: 1000),
        dotIncreaseSize: 6.0,
        dotSize: 5.0,
        dotSpacing: 15,
        dotIncreasedColor: Get.theme.primaryColor,
        dotBgColor: Colors.transparent,
        dotPosition: DotPosition.bottomRight,
        dotVerticalPadding: 2.0,
        dotHorizontalPadding: 10,
        showIndicator: true,
        indicatorBgPadding: 3.0,
        images: sliders.map((e) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Get.to(GalleryPhoto(
                    images: sliders, initialIndex: sliders.indexOf(e)));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Get.theme.backgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: sliders.isNotEmpty
                      ? ExtendedImage.network(
                          e['image'],
                          fit: BoxFit.cover,
                        )
                      : ExtendedImage.asset(
                          e.getDefaultImage(),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget listPlaceReview(
      final XController x, final List<CommentModel> comments) {
    return SizedBox(
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: comments.map((e) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: InputContainer(
              backgroundColor:
                  Get.theme.scaffoldBackgroundColor.withOpacity(.5),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: onePlaceRowComment(x, e),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  static Widget onePlaceRowComment(final XController x, final CommentModel e) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (e.user!.id != x.thisUser.value.id) {
                Get.to(OtherProfilePage(user: e.user!));
              }
            },
            child: Row(
              children: [
                ClipOval(
                  child: ExtendedImage.network(
                    e.user!.image!,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
                spaceWidth10,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${e.user!.fullname}",
                        style: textBold.copyWith(fontSize: 16)),
                    Text(MyTheme.formattedTimeFromStringShort(e.dateCreated!),
                        style: textSmallGrey)
                  ],
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Text("${e.getRating()}", style: textBold.copyWith(fontSize: 11)),
            spaceWidth5,
            RatingBar.builder(
              initialRating: e.rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              ignoreGestures: true,
              itemSize: 12,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
              itemBuilder: (context, _) => const Icon(
                BootstrapIcons.star_fill,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                debugPrint(rating.toString());
              },
            ),
          ],
        ),
        Text("${e.comment}", style: textSmallGrey.copyWith(fontSize: 14)),
      ],
    );
  }

  Widget topHeader(final PostModel placeModel) {
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
            padding: const EdgeInsets.only(right: 0),
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
                        onTap: () {
                          Get.to(MapPage(place: placeModel.toJson()),
                              transition: Transition.cupertinoDialog);
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
                                  Icon(BootstrapIcons.geo_alt,
                                      color: Get.theme.primaryColor, size: 15),
                                  spaceWidth5,
                                  Text(
                                    "Locations",
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
                spaceWidth5,
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
                        onTap: () {
                          Get.to(
                              MapPage(
                                  place: placeModel.toJson(), isRoute: true),
                              transition: Transition.cupertinoDialog);
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
                                  Icon(BootstrapIcons.pin_map,
                                      color: Get.theme.primaryColor, size: 15),
                                  spaceWidth5,
                                  Text(
                                    "Route",
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

  //static dialog re-usabled
  static final TextEditingController _noteReview = TextEditingController();
  static final ratingReview = 2.5.obs;
  static showDialogInputReview(final XController x, final PostModel? post,
      final CityCategoryModel? cityCateg) {
    _noteReview.text = '';
    ratingReview.value = 2.5;

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
                        margin: EdgeInsets.zero,
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
                                "Review",
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
                            RatingBar.builder(
                              initialRating: 2.5,
                              allowHalfRating: true,
                              minRating: 1,
                              direction: Axis.horizontal,
                              unratedColor: Colors.orange.withAlpha(50),
                              itemCount: 5,
                              itemSize: 40.0,
                              itemPadding: const EdgeInsets.symmetric(
                                horizontal: 2.0,
                              ),
                              itemBuilder: (context, _) => const Icon(
                                BootstrapIcons.star_fill,
                                color: Colors.orange,
                              ),
                              onRatingUpdate: (rating) {
                                ratingReview.value = rating;
                              },
                            ),
                          ],
                        ),
                      ),
                      spaceHeight20,
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
                            controller: _noteReview,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            minLines: 3,
                            maxLines: 6,
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Your genius comment",
                            ),
                          ),
                        ),
                      ),
                      spaceHeight20,
                      spaceHeight10,
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
                                children: [
                                  Text(
                                    "close".tr,
                                    style: const TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                          ),
                          spaceWidth10,
                          InkWell(
                            onTap: () async {
                              String note = _noteReview.text.trim();
                              if (note.isEmpty) {
                                MyTheme.showToast('Note review invalid!');
                                return;
                              }

                              EasyLoading.show(status: 'Loading...');

                              String? flag = "1";
                              if (cityCateg != null) {
                                flag = "2"; //${cityCateg.flag}";
                              }

                              //{"ip":"","ic":"2","fl":"1","ds":"Best place in London.. Great!","rt":5.0,"iu":"2"}

                              var dataReview = jsonEncode({
                                "ip": post != null ? post.id : "",
                                "ic": cityCateg != null ? cityCateg.id : "",
                                "fl": flag,
                                "ds": note.trim(),
                                "rt": ratingReview.value,
                                "iu": "${x.thisUser.value.id}",
                              });

                              debugPrint(dataReview);

                              Future.delayed(const Duration(milliseconds: 600),
                                  () async {
                                await x.provider
                                    .pushResponse('post/comment', dataReview);
                              });

                              await Future.delayed(
                                  const Duration(milliseconds: 1800), () {
                                x.asyncHome();
                              });

                              Future.delayed(const Duration(milliseconds: 800),
                                  () {
                                EasyLoading.showSuccess('Review successful...');
                                Get.back(result: {"success": "1"});
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
                      spaceHeight50,
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
                  margin: EdgeInsets.zero,
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
