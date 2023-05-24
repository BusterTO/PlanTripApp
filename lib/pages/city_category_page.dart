import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/models/city_category_model.dart';
import 'package:plantripapp/models/comment_model.dart';
import 'package:plantripapp/pages/gallery_photo.dart';
import 'package:plantripapp/pages/map_page.dart';
import 'package:plantripapp/pages/other_profile_page.dart';
import 'package:plantripapp/pages/places_page.dart';
import 'package:plantripapp/pages/reviewlist_page.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/input_container.dart';

class CityCategoryPage extends StatelessWidget {
  final CityCategoryModel cityCategoryModel;
  final String title;
  CityCategoryPage(
      {Key? key, required this.title, required this.cityCategoryModel})
      : super(key: key) {
    thisCityCateg.value = cityCategoryModel;
  }

  final thisCityCateg = CityCategoryModel().obs;

  @override
  Widget build(BuildContext context) {
    final List<dynamic> images = cityCategoryModel.listObjectImages();
    final XController x = XController.to;
    debugPrint("CityCategoryPage onBuild...");

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        topHeader(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15, right: 0),
                          child: createSlider(images),
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
                                    width: Get.width / 2.1,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 19, vertical: 5),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${cityCategoryModel.location}",
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                      ),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 19, vertical: 5),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${cityCategoryModel.nmCategory}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, bottom: 10, left: 5, right: 0),
                          child: Text("${cityCategoryModel.title}",
                              style: Get.theme.textTheme.headline5!.copyWith(
                                  fontWeight: FontWeight.w900, height: 1.1)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 5, right: 0, bottom: 10, top: 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text("(${cityCategoryModel.totalRating})",
                                      style: textBold.copyWith(fontSize: 15)),
                                  spaceWidth5,
                                  RatingBar.builder(
                                    initialRating: cityCategoryModel.rating!,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    ignoreGestures: true,
                                    itemSize: 20,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
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
                                        final result = await PlacePage
                                            .showDialogInputReview(
                                                x, null, cityCategoryModel);
                                        debugPrint(result.toString());

                                        if (result != null) {
                                          var jsonBody = jsonEncode({
                                            "id": cityCategoryModel.id,
                                            "iu": x.thisUser.value.id,
                                            "lat": x.latitude,
                                          });
                                          final response = await x.provider
                                              .pushResponse(
                                                  'city/get_categ_byid',
                                                  jsonBody);
                                          if (response != null &&
                                              response.statusCode == 200) {
                                            String respString =
                                                response.bodyString!;
                                            debugPrint(respString);
                                            dynamic dataresult =
                                                jsonDecode(respString);
                                            if (dataresult['result'] != null &&
                                                dataresult['result'].length >
                                                    0) {
                                              final dynamic datapost =
                                                  dataresult['result'][0];
                                              thisCityCateg.value =
                                                  CityCategoryModel.fromMap(
                                                      datapost);
                                            }
                                          }

                                          await Future.delayed(const Duration(
                                              milliseconds: 2200));
                                          x.asyncHome();
                                        }
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            alignment: Alignment.center,
                                            child: Row(
                                              children: [
                                                Icon(Icons.send,
                                                    color:
                                                        Get.theme.primaryColor,
                                                    size: 22),
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
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 15, left: 0, right: 0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (cityCategoryModel.user!.id !=
                                        x.thisUser.value.id &&
                                    cityCategoryModel.user!.id != '0') {
                                  Get.to(OtherProfilePage(
                                      user: cityCategoryModel.user!));
                                }
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor:
                                        Get.theme.primaryColorLight,
                                    child: cityCategoryModel.user!.image!
                                            .contains("http")
                                        ? CircleAvatar(
                                            radius: 12,
                                            child: ClipOval(
                                              child: ExtendedImage.network(
                                                cityCategoryModel.user!.image!,
                                                cache: true,
                                                fit: BoxFit.contain,
                                                width: 50,
                                                height: 50,
                                              ),
                                            ),
                                          )
                                        : CircleAvatar(
                                            radius: 12,
                                            child: ClipOval(
                                              child: ExtendedImage.asset(
                                                cityCategoryModel.user!.image!,
                                                fit: BoxFit.cover,
                                                width: 50,
                                                height: 50,
                                              ),
                                            ),
                                          ),
                                  ),
                                  spaceWidth10,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "${cityCategoryModel.user!.fullname}",
                                          style:
                                              textBold.copyWith(fontSize: 16)),
                                      Text(
                                          MyTheme.formattedTimeFromString(
                                              cityCategoryModel.createdAt!),
                                          style: textSmallGrey)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 15, left: 5, right: 0),
                          child: Text(
                            "${cityCategoryModel.description}",
                            style: textSmallGrey.copyWith(fontSize: 16),
                          ),
                        ),
                        (cityCategoryModel.topThreeComments().isEmpty)
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Review",
                                      style: textBold.copyWith(fontSize: 16),
                                    ),
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      iconSize: 18,
                                      onPressed: () {
                                        if (cityCategoryModel
                                            .topThreeComments()
                                            .isNotEmpty) {
                                          Get.to(ReviewListPage(
                                              comments:
                                                  cityCategoryModel.comments!));
                                        }
                                      },
                                      icon: const Icon(
                                          BootstrapIcons.chevron_right),
                                    ),
                                  ],
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 0, right: 0),
                          child:
                              listReview(cityCategoryModel.topThreeComments()),
                        ),
                        spaceHeight50,
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

  Widget createSlider(final List<dynamic> datas) {
    List<dynamic> sliders = datas..shuffle();
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
                    images: datas, initialIndex: datas.indexOf(e)));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Get.theme.backgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: cityCategoryModel.listImages().isNotEmpty
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

  Widget listReview(final List<CommentModel> comments) {
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
                child: oneRowComment(e),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget oneRowComment(final CommentModel e) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipOval(
              child: ExtendedImage.network(
                "${e.user!.image}",
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
        Row(
          children: [
            Text("${e.getRating()}", style: textBold.copyWith(fontSize: 11)),
            spaceWidth5,
            RatingBar.builder(
              initialRating: cityCategoryModel.rating!,
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

  Widget topHeader() {
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
                          Get.to(MapPage(place: cityCategoryModel.toJson()),
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
                                  place: cityCategoryModel.toJson(),
                                  isRoute: true),
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
}
