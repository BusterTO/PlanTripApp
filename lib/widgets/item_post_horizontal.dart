import 'dart:convert';
import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/main.dart';
import 'package:plantripapp/models/post_model.dart';
import 'package:plantripapp/pages/other_profile_page.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/input_container.dart';
import 'package:plantripapp/widgets/item_stat.dart';
import 'package:plantripapp/widgets/item_user_circle.dart';

class ItemPostHorizontal extends StatelessWidget {
  final PostModel post;
  final XController x;
  ItemPostHorizontal({Key? key, required this.post, required this.x})
      : super(key: key) {
    postLiked.value = post.liked == 1;
    thisPost.value = post;
  }

  final postLiked = false.obs;
  final thisPost = PostModel().obs;

  fetchSinglePost() async {
    try {
      var jsonBody = jsonEncode({
        "id": post.id,
        "iu": x.thisUser.value.id,
        "lat": x.latitude,
      });
      final response = await x.provider.pushResponse('post/get_byid', jsonBody);
      if (response != null && response.statusCode == 200) {
        String respString = response.bodyString!;
        //debugPrint(respString);
        dynamic dataresult = jsonDecode(respString);
        if (dataresult['result'] != null && dataresult['result'].length > 0) {
          final dynamic datapost = dataresult['result'][0];
          thisPost.value = PostModel.fromMap(datapost);
        }
      }
      //await Future.delayed(const Duration(milliseconds: 1200), () {});
      //x.asyncHome();
    } catch (e) {
      debugPrint("Error fetchSinglePost ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => createItem(thisPost.value));
  }

  Widget createItem(final PostModel e) {
    return InputContainer(
      backgroundColor: Get.theme.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
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
                    child: e.listImages().isNotEmpty
                        ? e.image1!.startsWith("/")
                            ? ExtendedImage.file(
                                File(e.image1!),
                                width: witdhIcon * 3.5,
                                height: witdhIcon * 1.75,
                                fit: BoxFit.cover,
                              )
                            : e.image1!.contains("http")
                                ? ExtendedImage.network(
                                    e.image1!,
                                    width: witdhIcon * 3.5,
                                    height: witdhIcon * 1.75,
                                    fit: BoxFit.cover,
                                  )
                                : ExtendedImage.asset(
                                    e.image1!,
                                    width: witdhIcon * 3.5,
                                    height: witdhIcon * 1.75,
                                    fit: BoxFit.cover,
                                  )
                        : ExtendedImage.asset(
                            e.getDefaultImage(),
                            width: witdhIcon * 3.5,
                            height: witdhIcon * 1.75,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 3),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor:
                          Get.theme.backgroundColor.withOpacity(.7),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 3, left: 3),
                        child: Obx(
                          () => LikeButton(
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
                              Future.microtask(() {
                                MyHomePage.pushLikeOrDislike(
                                    x, e, null, !isLiked);
                              });

                              await Future.delayed(
                                  const Duration(milliseconds: 400), () {
                                fetchSinglePost();
                              });
                              debugPrint("isLiked ${!isLiked}");
                              postLiked.value = !postLiked.value;
                              return !isLiked;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (e.user!.id != x.thisUser.value.id) {
                          Get.to(OtherProfilePage(user: e.user!));
                        }
                      },
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
                                  backgroundColor: Get.theme.primaryColorLight,
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
                                  ),
                                )
                              ],
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
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 10, bottom: 5),
            child: e.richTextHashtag(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 10),
            child: SizedBox(
              child: Text(
                "${e.title}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  height: 1.2,
                ),
              ),
            ),
          ),
          spaceHeight10,
          if (e.location != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(BootstrapIcons.geo_alt,
                      size: 12, color: Colors.deepOrange),
                  spaceWidth5,
                  Text(
                    e.location!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textSmallGrey.copyWith(color: Colors.deepOrange),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 0),
            child: Row(
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
    );
  }
}
