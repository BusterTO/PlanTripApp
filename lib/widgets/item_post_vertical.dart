import 'dart:convert';
import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/main.dart';
import 'package:plantripapp/models/post_model.dart';
import 'package:plantripapp/pages/detail_post.dart';
import 'package:plantripapp/pages/other_profile_page.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/input_container.dart';
import 'package:plantripapp/widgets/item_stat.dart';
import 'package:plantripapp/widgets/item_user_circle.dart';

class ItemPostVertical extends StatelessWidget {
  final XController x;
  final PostModel post;
  final double defHeight;
  final bool isMyPost;
  final bool isBookmark;
  final VoidCallback? callback;
  ItemPostVertical({
    Key? key,
    required this.x,
    required this.post,
    required this.defHeight,
    this.isMyPost = false,
    this.isBookmark = false,
    this.callback,
  }) : super(key: key) {
    postLiked.value = post.liked == 1;
  }

  final postLiked = false.obs;

  @override
  Widget build(BuildContext context) {
    final PostModel e = post;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.to(DetailPost(postModel: e, x: x), preventDuplicates: false);
        },
        child: Container(
          width: Get.width,
          height:
              (e.listImages().isNotEmpty) ? defHeight * .91 : defHeight / 2.55,
          margin: const EdgeInsets.only(
            left: paddingSize,
            right: paddingSize,
            bottom: paddingSize,
          ),
          child: InputContainer(
            backgroundColor: Get.theme.backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (e.listImages().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Stack(
                      children: [
                        Container(
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
                            child: e.listImages().length > 1
                                ? createSliderPost(e.listImages())
                                : e.image1!.startsWith("/")
                                    ? ExtendedImage.file(
                                        File(e.image1!),
                                        width: Get.width,
                                        height: witdhIcon * 2.25,
                                        fit: BoxFit.cover,
                                      )
                                    : ExtendedImage.network(
                                        e.image1!,
                                        width: Get.width,
                                        height: witdhIcon * 2.25,
                                        fit: BoxFit.cover,
                                      ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  if (e.user!.id != x.thisUser.value.id) {
                                    Get.to(OtherProfilePage(user: e.user!));
                                  }
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor:
                                          Get.theme.primaryColorLight,
                                      child: e.user!.image!.contains("http")
                                          ? CircleAvatar(
                                              radius: 12,
                                              child: ClipOval(
                                                child: ExtendedImage.network(
                                                  e.user!.image!,
                                                  cache: true,
                                                  fit: BoxFit.cover,
                                                  width: 80,
                                                  height: 80,
                                                ),
                                              ),
                                            )
                                          : CircleAvatar(
                                              radius: 12,
                                              child: ClipOval(
                                                child: ExtendedImage.asset(
                                                  e.user!.image!,
                                                  fit: BoxFit.cover,
                                                  width: 80,
                                                  height: 80,
                                                ),
                                              ),
                                            ),
                                    ),
                                    spaceWidth5,
                                    Text(
                                      "@${e.user!.username}",
                                      style: textSmall.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (isMyPost)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    deletePostAsync(e);
                                  },
                                  child: AnimatedContainer(
                                    height: 30,
                                    duration: const Duration(milliseconds: 300),
                                    decoration: BoxDecoration(
                                      color: Get.theme.primaryColor,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      child: Icon(
                                        BootstrapIcons.trash,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                spaceHeight15,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: e.richTextHashtag(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          e.desc!,
                          maxLines: e.listImages().isNotEmpty ? 3 : 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(height: 1.1),
                        ),
                      ),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Column(
                            children: [
                              if (isMyPost && e.listImages().isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 3, bottom: 5),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () async {
                                        deletePostAsync(e);
                                      },
                                      child: AnimatedContainer(
                                        height: 25,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        decoration: BoxDecoration(
                                          color: Get.theme.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 0),
                                          child: Icon(
                                            BootstrapIcons.trash,
                                            color: Colors.white,
                                            size: 11,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              LikeButton(
                                size: 18,
                                isLiked: postLiked.value,
                                likeBuilder: (bool isLiked) {
                                  return Icon(
                                    BootstrapIcons.bookmark_fill,
                                    color: isLiked ? Colors.amber : Colors.grey,
                                    size: 18,
                                  );
                                },
                                onTap: (bool isLiked) async {
                                  Future.microtask(() =>
                                      MyHomePage.pushLikeOrDislike(
                                          x, e, null, !isLiked));
                                  await Future.delayed(
                                      const Duration(milliseconds: 600));
                                  final bool resCallback = !isLiked;
                                  postLiked.value = resCallback;
                                  return resCallback;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                spaceHeight5,
                if (e.location != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        const Icon(BootstrapIcons.geo_alt,
                            size: 12, color: Colors.deepOrange),
                        spaceWidth5,
                        Text(
                          "${e.location}${e.getDistance()}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              textSmallGrey.copyWith(color: Colors.deepOrange),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 15,
                    bottom: 0,
                    top: 0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ItemStat(e: e),
                      (e.otherUsers != null && e.otherUsers!.isNotEmpty)
                          ? ItemUserCircle(otherUser: e.otherUsers!, radius: 12)
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // delete post function
  deletePostAsync(final PostModel e) async {
    if (e.id! != '') {
      EasyLoading.show(status: 'Loading...');
      await Future.delayed(const Duration(milliseconds: 800), () async {
        final dataPost = jsonEncode({
          "id": e.id,
          "act": "delete",
        });
        debugPrint(dataPost);
        x.provider.pushResponse("post/get_byid", dataPost);
      });

      await Future.delayed(const Duration(milliseconds: 800), () {
        EasyLoading.showSuccess('deletesuccess'.tr);
        callback!();
      });
    }
  }

  static Widget createSliderPost(final List<String> images) {
    return SizedBox(
      child: SizedBox(
        height: Get.height / 5,
        width: Get.width,
        child: Carousel(
          boxFit: BoxFit.contain,
          autoplay: false,
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
          images: images.map((e) {
            return Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Get.theme.backgroundColor,
                  // borderRadius: BorderRadius.circular(15),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: ExtendedImage.network(
                    e,
                    fit: BoxFit.cover,
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
