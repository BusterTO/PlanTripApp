import 'dart:convert';
import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:plantripapp/core/ads_helper.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/main.dart';
import 'package:plantripapp/models/comment_model.dart';
import 'package:plantripapp/models/post_model.dart';
import 'package:plantripapp/pages/gallery_photo.dart';
import 'package:plantripapp/pages/other_profile_page.dart';
import 'package:plantripapp/pages/places_page.dart';
import 'package:plantripapp/pages/reviewlist_page.dart';
import 'package:plantripapp/screens/home_screen.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/input_container.dart';
import 'package:plantripapp/widgets/item_comment.dart';
import 'package:plantripapp/widgets/item_stat.dart';
import 'package:plantripapp/widgets/item_user_circle.dart';

class DetailPost extends StatelessWidget {
  final PostModel postModel;
  final XController x;

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  DetailPost({Key? key, required this.postModel, required this.x})
      : super(key: key) {
    thisPost.value = postModel;
    scrollController.addListener(() {
      isExpanded.value = scrollController.hasClients &&
          scrollController.offset > ((heightExpanded - 50) - kToolbarHeight);
    });

    // show interstitial Ads
    Future.delayed(const Duration(milliseconds: 600), () {
      if (AdsHelper.interstitialAd != null) {
        AdsHelper.interstitialAd!.show();
      }
    });
  }

  final isExpanded = false.obs;
  final thisPost = PostModel().obs;

  fetchSinglePost() async {
    try {
      var jsonBody = jsonEncode({
        "id": postModel.id,
        "iu": x.thisUser.value.id,
        "lat": x.latitude,
      });
      final response = await x.provider.pushResponse('post/get_byid', jsonBody);
      if (response != null && response.statusCode == 200) {
        String respString = response.bodyString!;
        //debugPrint(respString);
        dynamic dataresult = jsonDecode(respString);
        if (dataresult['result'] != null && dataresult['result'].length > 0) {
          dynamic datapost = dataresult['result'][0];
          thisPost.value = PostModel.fromMap(datapost);
        }
      }
      await Future.delayed(const Duration(milliseconds: 1200), () {});
      x.asyncHome();
    } catch (e) {
      debugPrint("Error fetchSinglePost ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          Obx(
            () => createBody(x, isExpanded.value, thisPost.value),
          ),
          Obx(
            () => sliverBody(x, thisPost.value),
          ),
        ],
      ),
    );
  }

  Widget createBody(
      final XController x, final bool isExpanded, final PostModel post) {
    Color backTop = x.isDarkMode.value
        ? Get.theme.backgroundColor.withOpacity(.7)
        : Colors.white;
    return SliverAppBar(
      systemOverlayStyle: x.isDarkMode.value
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      pinned: true,
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: CircleAvatar(
          radius: 10,
          backgroundColor: isExpanded ? Colors.transparent : backTop,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: InkWell(
              child: Icon(
                BootstrapIcons.chevron_left,
                size: 16,
                color: isExpanded
                    ? Colors.white
                    : Get.theme.textTheme.bodyText1!.color!,
              ),
              onTap: () {
                Get.back();
              },
            ),
          ),
        ),
      ),
      title: SizedBox(
        width: Get.width,
        child: Opacity(
          opacity: isExpanded ? 1 : 0,
          child: Text(
            (post.title == null || post.title!.isEmpty)
                ? 'Information'
                : post.title!,
            style: textTitle,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: isExpanded ? Colors.transparent : backTop,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 3, left: 3),
              child: LikeButton(
                size: 14,
                isLiked: post.liked == 1,
                likeBuilder: (bool isLiked) {
                  return Icon(
                    BootstrapIcons.bookmark_fill,
                    color: isLiked
                        ? Colors.amber
                        : isExpanded
                            ? Colors.white
                            : Colors.grey,
                    size: 14,
                  );
                },
                onTap: (bool isLiked) async {
                  Future.microtask(() =>
                      MyHomePage.pushLikeOrDislike(x, post, null, !isLiked));
                  await Future.delayed(const Duration(milliseconds: 400), () {
                    fetchSinglePost();
                  });
                  return !isLiked;
                },
              ),
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              String content = "${post.title}\n\n${post.desc}";
              MyTheme.onShare("Post Share", content, []);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: isExpanded ? Colors.transparent : backTop,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2, left: 0),
                  child: Icon(
                    BootstrapIcons.share,
                    color: isExpanded ? Colors.white : Colors.grey,
                    size: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
      expandedHeight: heightExpanded,
      flexibleSpace: FlexibleSpaceBar(
        background: post.listImages().isNotEmpty
            ? post.listImages().length > 1
                ? createSliderPost(post.listImages(), heightExpanded)
                : Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        List<dynamic> datas = [
                          {"image": post.image1!}
                        ];
                        Get.to(GalleryPhoto(images: datas, initialIndex: 0));
                      },
                      child: post.image1!.startsWith("/")
                          ? ExtendedImage.file(
                              File(post.image1!),
                              height: heightExpanded,
                              fit: BoxFit.cover,
                            )
                          : ExtendedImage.network(
                              post.image1!,
                              height: heightExpanded,
                              fit: BoxFit.cover,
                            ),
                    ),
                  )
            : ExtendedImage.asset(
                post.getDefaultImage(),
                height: heightExpanded,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget createSliderPost(final List<String> images, final double heightSlide) {
    return SizedBox(
      child: SizedBox(
        height: heightSlide,
        width: Get.width,
        child: Carousel(
          boxFit: BoxFit.cover,
          autoplay: false,
          //autoplayDuration: const Duration(milliseconds: 1000 * 35),
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
              child: InkWell(
                onTap: () {
                  List<dynamic> datas = [];
                  for (var element in images) {
                    datas.add({"image": element});
                  }

                  Get.to(GalleryPhoto(
                      images: datas, initialIndex: images.indexOf(e)));
                },
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
                    //borderRadius: BorderRadius.circular(15),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: e.startsWith("/")
                        ? ExtendedImage.file(
                            File(e),
                            fit: BoxFit.cover,
                          )
                        : ExtendedImage.network(
                            e,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget sliverBody(final XController x, final PostModel e) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          spaceHeight10,
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 15,
              bottom: 0,
              top: 5,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ItemStat(e: e, fontSize: 17),
                (e.otherUsers != null && e.otherUsers!.isNotEmpty)
                    ? ItemUserCircle(otherUser: e.otherUsers!, radius: 17)
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          spaceHeight15,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
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
                      radius: 16,
                      backgroundColor: Get.theme.primaryColorLight,
                      child: e.user!.image!.contains("http")
                          ? CircleAvatar(
                              radius: 14,
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
                              radius: 14,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "@${e.user!.username}",
                          style: textSmall.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${e.user!.fullname}",
                          style: textSmallGrey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          spaceHeight5,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              MyTheme.formattedTimeFromString(e.createAt!),
              style: textSmallGrey,
            ),
          ),
          if (e.location != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RatingBar.builder(
              initialRating: e.rating!,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemSize: 12,
              itemCount: 5,
              itemPadding: const EdgeInsets.only(right: 4.0),
              itemBuilder: (context, _) => const Icon(
                BootstrapIcons.star_fill,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                debugPrint(rating.toString());
              },
            ),
          ),
          spaceHeight15,
          if (e.title != null && e.title!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(e.title!,
                  style: textBig.copyWith(
                      fontWeight: FontWeight.w800, height: 1.1)),
            ),
          Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 5),
              child: e.richTextHashtag(),
            ),
          ),
          buildDescription(e),
          spaceHeight20,
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Review",
                  style: Get.theme.textTheme.headline6!.copyWith(
                    fontSize: 18,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                    iconSize: 18,
                    onPressed: () {
                      if (e.topThreeComments().isNotEmpty) {
                        Get.to(ReviewListPage(comments: e.comments!));
                      }
                    },
                    icon: const Icon(BootstrapIcons.chevron_right)),
              ],
            ),
          ),
          spaceHeight10,
          buildComment(e.topThreeComments()),
          inputNewComment(x, x.isDarkMode.value, e),
          spaceHeight15,
          Container(
            width: Get.width,
            color: Get.theme.canvasColor,
            height: heightDivider,
            margin: const EdgeInsets.only(top: 5, bottom: 5),
          ),
          spaceHeight15,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Nearby you",
              style: Get.theme.textTheme.headline6!.copyWith(
                fontSize: 18,
                height: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          spaceHeight20,
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: HomeScreen.listTopPosts(
                x, x.itemHome.value.nearbys!, false, false, null),
          ),
          spaceHeight50
        ],
      ),
    );
  }

  Widget buildComment(final List<CommentModel> comments) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        child: Column(
          children: comments
              .map(
                (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: ItemComment(e: e)),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget inputNewComment(
      final XController x, final bool isDark, final PostModel post) {
    //print("inputSearch isDark : $isDark");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: InputContainer(
        backgroundColor: Get.theme.backgroundColor,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              debugPrint("click hreeee");

              final result =
                  await PlacePage.showDialogInputReview(x, post, null);
              debugPrint(result.toString());

              if (result != null) {
                var jsonBody = jsonEncode({
                  "id": post.id,
                  "iu": x.thisUser.value.id,
                  "lat": x.latitude,
                });
                final response =
                    await x.provider.pushResponse('post/get_byid', jsonBody);
                if (response != null && response.statusCode == 200) {
                  String respString = response.bodyString!;
                  debugPrint(respString);
                  dynamic dataresult = jsonDecode(respString);
                  if (dataresult['result'] != null &&
                      dataresult['result'].length > 0) {
                    dynamic datapost = dataresult['result'][0];
                    thisPost.value = PostModel.fromMap(datapost);
                  }
                }
                await Future.delayed(const Duration(milliseconds: 1200), () {});
                x.asyncHome();
              }
            },
            child: TextField(
              enabled: false,
              decoration: inputForm(
                Get.theme.backgroundColor,
                25,
                const EdgeInsets.only(left: 0, right: 0, top: 12, bottom: 0),
              ).copyWith(
                hintText: 'New comment',
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  child: Icon(
                    BootstrapIcons.star,
                    color: Get.theme.primaryColor,
                    size: 16,
                  ),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 10),
                  child: Icon(
                    Icons.send,
                    color: Get.theme.primaryColor,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDescription(final PostModel e) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              e.desc!,
            ),
          ),
        ],
      ),
    );
  }
}
