import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/main.dart';
import 'package:plantripapp/models/category_model.dart';
import 'package:plantripapp/models/city_category_model.dart';
import 'package:plantripapp/models/city_model.dart';
import 'package:plantripapp/models/follow_model.dart';
import 'package:plantripapp/models/post_model.dart';
import 'package:plantripapp/models/slide_model.dart';
import 'package:plantripapp/models/user_model.dart';
import 'package:plantripapp/pages/city_category_page.dart';
import 'package:plantripapp/pages/city_page.dart';
import 'package:plantripapp/pages/detail_article.dart';
import 'package:plantripapp/pages/detail_city.dart';
import 'package:plantripapp/pages/detail_post.dart';
import 'package:plantripapp/pages/gallery_photo.dart';
import 'package:plantripapp/pages/list_article_page.dart';
import 'package:plantripapp/pages/list_following_page.dart';
import 'package:plantripapp/pages/list_post_page.dart';
import 'package:plantripapp/pages/other_profile_page.dart';
import 'package:plantripapp/pages/search_page.dart';
import 'package:plantripapp/pages/userlist_page.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/input_container.dart';
import 'package:plantripapp/widgets/item_post_horizontal.dart';
import 'package:plantripapp/widgets/item_post_vertical.dart';
import 'package:plantripapp/widgets/item_stat.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? callback;
  final bool? isUploading;
  HomeScreen({Key? key, this.callback, this.isUploading}) : super(key: key);
  final isPosting = false.obs;

  @override
  Widget build(BuildContext context) {
    final XController x = XController.to;

    return RefreshIndicator(
      onRefresh: () async {
        x.asyncLatitude();

        await Future.delayed(const Duration(seconds: 2), () {
          x.asyncHome();
        });
      },
      child: Obx(() => createBody(
          x,
          x.isDarkMode.value,
          x.itemHome.value.cities,
          isPosting.value,
          x.itemHome.value.sliders,
          x.itemHome.value.users)),
    );
  }

  fakeUploadingPost() {
    isPosting.value = true;
    Future.delayed(const Duration(seconds: 3500), () {
      isPosting.value = false;
    });
  }

  Widget createBody(
      final XController x,
      final bool isDark,
      final List<CityModel>? dataCities,
      final isUploading,
      final List<SlideModel>? dataSlides,
      final List<UserModel>? dataUsers) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: Get.theme.backgroundColor,
      child: SafeArea(
        child: Scaffold(
          //floatingActionButton: const FancyFab(),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            width: Get.width,
            height: Get.height,
            color: Colors.transparent,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: Get.mediaQuery.padding.top * 0.60,
                      left: paddingSize,
                      right: paddingSize / 3,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Get.width / 1.4,
                          child: Text(
                            "top_title".tr,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 21,
                              height: 1.2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(BootstrapIcons.list),
                          onPressed: () async {
                            callback!();
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 25, left: paddingSize, right: paddingSize),
                    child: inputSearch(isDark),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 25, left: paddingSize, right: paddingSize),
                    child: Row(
                      children: [
                        Icon(BootstrapIcons.geo_alt_fill,
                            size: 11, color: Get.theme.primaryColor),
                        spaceWidth5,
                        Text(x.location, style: textSmallGrey),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0, left: paddingSize, right: paddingSize),
                    child: Text(
                      "explorer_cities".tr,
                      style: Get.theme.textTheme.headline6!.copyWith(
                        fontSize: 18,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: dataCities != null && dataCities.isNotEmpty
                        ? listCitiesHorizontal(dataCities)
                        : Container(
                            padding: const EdgeInsets.all(10),
                            width: Get.width,
                            child: Center(
                              child: MyTheme.loading(),
                            ),
                          ),
                  ),
                  Container(
                    width: Get.width,
                    color: Get.theme.canvasColor,
                    height: heightDivider,
                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 15,
                        left: paddingSize,
                        right: paddingSize - 2),
                    child: dataSlides != null && dataSlides.isNotEmpty
                        ? createSlider(dataSlides)
                        : Container(
                            padding: const EdgeInsets.all(10),
                            width: Get.width,
                            child: Center(
                              child: MyTheme.loading(),
                            ),
                          ),
                  ),
                  (x.itemHome.value.followings != null &&
                          x.itemHome.value.followings!.isNotEmpty)
                      ? spaceHeight5
                      : spaceHeight20,
                  if (isUploading)
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0,
                          bottom: 15,
                          left: paddingSize,
                          right: paddingSize),
                      child: LinearPercentIndicator(
                        width: Get.width - (paddingSize * 2.1),
                        animation: true,
                        lineHeight: 8.0,
                        animationDuration: 2000,
                        percent: 1.0,
                        //linearStrokeCap: LinearStrokeCap.roundAll,
                        barRadius: const Radius.circular(20),
                        progressColor: Colors.amber,
                        backgroundColor: Get.theme.primaryColor,
                      ),
                    ),
                  if (x.itemHome.value.followings != null &&
                      x.itemHome.value.followings!.isNotEmpty)
                    Padding(
                      padding:
                          const EdgeInsets.only(left: paddingSize, right: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "following".tr,
                            style: Get.theme.textTheme.headline6!.copyWith(
                              fontSize: 18,
                              height: 1.2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                              iconSize: 18,
                              onPressed: () {
                                Get.to(const ListFollowingPage());
                              },
                              icon: const Icon(BootstrapIcons.chevron_right)),
                        ],
                      ),
                    ),
                  if (x.itemHome.value.followings != null &&
                      x.itemHome.value.followings!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Obx(
                        () => x.itemHome.value.followings != null &&
                                x.itemHome.value.followings!.isNotEmpty
                            ? listPostFollowingHorizontal(
                                x, x.itemHome.value.followings!)
                            : Container(
                                padding: const EdgeInsets.all(10),
                                width: Get.width,
                                child: Center(
                                  child: MyTheme.loading(),
                                ),
                              ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: paddingSize, right: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "latest_post".tr,
                          style: Get.theme.textTheme.headline6!.copyWith(
                            fontSize: 18,
                            height: 1.2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                            iconSize: 18,
                            onPressed: () {
                              Get.to(ListPostPage(
                                  title: "latest_post".tr,
                                  datas: x.itemHome.value.posts!));
                            },
                            icon: const Icon(BootstrapIcons.chevron_right)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Obx(
                      () => x.itemHome.value.posts != null &&
                              x.itemHome.value.posts!.isNotEmpty
                          ? listPostHorizontal(x, x.itemHome.value.posts!)
                          : Container(
                              padding: const EdgeInsets.all(10),
                              width: Get.width,
                              child: Center(
                                child: MyTheme.loading(),
                              ),
                            ),
                    ),
                  ),
                  spaceHeight10,
                  Container(
                    width: Get.width,
                    color: Get.theme.canvasColor,
                    height: heightDivider,
                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: paddingSize, right: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "users".tr,
                          style: Get.theme.textTheme.headline6!.copyWith(
                            fontSize: 18,
                            height: 1.2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                            iconSize: 18,
                            onPressed: () {
                              Get.to(UserListPage(),
                                  transition: Transition.fadeIn);
                            },
                            icon: const Icon(BootstrapIcons.chevron_right)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: dataUsers != null && dataUsers.isNotEmpty
                        ? listUsersHorizontal(dataUsers)
                        : Container(
                            padding: const EdgeInsets.all(10),
                            width: Get.width,
                            child: Center(
                              child: MyTheme.loading(),
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 25, left: paddingSize, right: paddingSize),
                    child: Text(
                      "insider_travel_guide".tr,
                      style: Get.theme.textTheme.headline6!.copyWith(
                        fontSize: 18,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25, bottom: 15),
                    child: Obx(
                      () => x.itemHome.value.travels != null &&
                              x.itemHome.value.travels!.isNotEmpty
                          ? listInfosTravel(x.itemHome.value.travels!)
                          : Container(
                              padding: const EdgeInsets.all(10),
                              width: Get.width,
                              child: Center(
                                child: MyTheme.loading(),
                              ),
                            ),
                    ),
                  ),
                  Container(
                    width: Get.width,
                    color: Get.theme.canvasColor,
                    height: heightDivider,
                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: paddingSize,
                      right: 5,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "recommend_article".tr,
                          style: Get.theme.textTheme.headline6!.copyWith(
                            fontSize: 18,
                            height: 1.2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                            iconSize: 18,
                            onPressed: () {
                              Get.to(
                                  ListArticlePage(
                                    title: "recommend_article".tr,
                                    datas: x.itemHome.value.articles!,
                                  ),
                                  transition: Transition.leftToRight);
                            },
                            icon: const Icon(BootstrapIcons.chevron_right)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Obx(
                      () => x.itemHome.value.articles != null &&
                              x.itemHome.value.articles!.isNotEmpty
                          ? listArticlesHorizontal(
                              x, x.itemHome.value.articles!)
                          : Container(
                              padding: const EdgeInsets.all(10),
                              width: Get.width,
                              child: Center(
                                child: MyTheme.loading(),
                              ),
                            ),
                    ),
                  ),
                  Container(
                    width: Get.width,
                    color: Get.theme.canvasColor,
                    height: heightDivider,
                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 35,
                      left: paddingSize,
                      right: paddingSize,
                    ),
                    child: Text(
                      "special_hotel_collection".tr,
                      style: Get.theme.textTheme.headline6!.copyWith(
                        fontSize: 18,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25, bottom: 10),
                    child: Obx(
                      () => x.itemHome.value.categories != null &&
                              x.itemHome.value.categories!.isNotEmpty
                          ? listCategoryHorizontal(x.itemHome.value.categories!,
                              indexCollectionSelected.value)
                          : Container(
                              padding: const EdgeInsets.all(10),
                              width: Get.width,
                              child: Center(
                                child: MyTheme.loading(),
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Obx(
                      () => x.itemHome.value.hotels != null &&
                              x.itemHome.value.hotels!.isNotEmpty
                          ? listHotelCollectionsHorizontal(
                              x.itemHome.value.hotels!,
                              indexCollectionSelected.value)
                          : Container(
                              padding: const EdgeInsets.all(10),
                              width: Get.width,
                              child: Center(
                                child: MyTheme.loading(),
                              ),
                            ),
                    ),
                  ),
                  Container(
                    width: Get.width,
                    color: Get.theme.canvasColor,
                    height: heightDivider,
                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 35,
                      left: paddingSize,
                      right: paddingSize,
                    ),
                    child: Text(
                      "top_post".tr,
                      style: Get.theme.textTheme.headline6!.copyWith(
                        fontSize: 18,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  spaceHeight10,
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Obx(
                      () => x.itemHome.value.all != null &&
                              x.itemHome.value.all!.isNotEmpty
                          ? listTopPosts(
                              x, x.itemHome.value.all!, false, false, null)
                          : Container(
                              padding: const EdgeInsets.all(10),
                              width: Get.width,
                              child: Center(
                                child: MyTheme.loading(),
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

  static Widget listTopPosts(
      final XController x,
      final List<PostModel>? infos,
      final bool isBookmark,
      final bool isMyPost,
      final VoidCallback? callback) {
    return SizedBox(
      width: Get.width,
      child: infos != null && infos.isEmpty
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
                      "There's No Post Found",
                      style: Get.theme.textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  spaceHeight10,
                ],
              ),
            )
          : ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: infos!.map((PostModel e) {
                final double defHeight = GetPlatform.isAndroid
                    ? Get.height / 2.05
                    : Get.height / 2.4;
                if (isMyPost) {
                  return ItemPostVertical(
                    x: x,
                    post: e,
                    defHeight: defHeight,
                    isBookmark: isBookmark,
                    isMyPost: isMyPost,
                    callback: callback,
                  );
                } else {
                  return ItemPostVertical(
                    x: x,
                    post: e,
                    defHeight: defHeight,
                    isBookmark: isBookmark,
                    isMyPost: isMyPost,
                  );
                }
              }).toList(),
            ),
    );
  }

  static Widget listTopArticles(
      final XController x, final List<PostModel> datas, final int isSelected) {
    List<PostModel> infos = datas..shuffle();
    return SizedBox(
      width: Get.width,
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: infos.map((PostModel e) {
          final int index = infos.indexOf(e);
          final double defHeight =
              GetPlatform.isAndroid ? Get.height / 2.05 : Get.height / 2.4;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Get.to(DetailPost(postModel: e, x: x),
                    preventDuplicates: false);
              },
              child: Container(
                width: Get.width,
                height: (e.listImages().isNotEmpty)
                    ? defHeight * .91
                    : defHeight / 2.55,
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
                                      ? ItemPostVertical.createSliderPost(
                                          e.listImages())
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
                                          Get.to(
                                              OtherProfilePage(user: e.user!));
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 14,
                                            backgroundColor:
                                                Get.theme.primaryColorLight,
                                            child: e.user!.image!
                                                    .contains("http")
                                                ? CircleAvatar(
                                                    radius: 12,
                                                    child: ClipOval(
                                                      child:
                                                          ExtendedImage.network(
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
                                                      child:
                                                          ExtendedImage.asset(
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
                            ],
                          ),
                        ),
                      spaceHeight15,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: e.richTextHashtag(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                e.desc!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            LikeButton(
                              size: 18,
                              isLiked: e.liked == 1,
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
                                return !isLiked;
                              },
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
                                e.location!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textSmallGrey.copyWith(
                                    color: Colors.deepOrange),
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
                            Text(
                              "${e.sizeFile} MB",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textSmallGrey.copyWith(
                                fontWeight: FontWeight.w800,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  final indexCollectionSelected = 0.obs;
  Widget listCategoryHorizontal(
      final List<CategoryModel> collects, final int isSelected) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: collects.map((CategoryModel e) {
          final int index = collects.indexOf(e);
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                indexCollectionSelected.value = index;
              },
              child: Container(
                margin: EdgeInsets.only(
                    left: index == 0 ? paddingSize : 0,
                    right: index >= (collects.length - 1)
                        ? (spaceIcon * 2)
                        : spaceIcon - 5,
                    bottom: 8),
                child: InputContainer(
                  backgroundColor: isSelected == index
                      ? Get.theme.primaryColor
                      : Get.theme.backgroundColor,
                  radius: 20,
                  boxShadow: BoxShadow(
                    color: Colors.grey.withOpacity(.3),
                    offset: const Offset(1, 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 19),
                        alignment: Alignment.center,
                        child: Text(
                          "${e.title}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected == index
                                  ? Get.theme.backgroundColor
                                  : Get.theme.textTheme.bodyText2!.color),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  static Widget listPostFollowingHorizontal(
      final XController x, final List<FollowModel> followings) {
    List<PostModel> datas = [];
    for (var element in followings) {
      if (element.post != null) {
        datas.add(element.post!);
      }
    }

    return SizedBox(
      height: GetPlatform.isAndroid ? Get.height / 2.55 : Get.height / 2.95,
      child: ListView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: datas.map((e) {
          final int index = datas.indexOf(e);
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Get.to(DetailPost(postModel: e, x: x),
                    preventDuplicates: false);
              },
              child: Container(
                width: witdhIcon * 3.5,
                height: 190,
                margin: EdgeInsets.only(
                    left: index == 0 ? paddingSize : 0,
                    right: index >= (datas.length - 1)
                        ? (spaceIcon * 2)
                        : spaceIcon,
                    bottom: 8),
                child: ItemPostHorizontal(post: e, x: x),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  static Widget listPostHorizontal(
      final XController x, final List<PostModel> datas) {
    return SizedBox(
      height: GetPlatform.isAndroid ? Get.height / 2.55 : Get.height / 2.95,
      child: ListView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: datas.map((e) {
          final int index = datas.indexOf(e);
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Get.to(DetailPost(postModel: e, x: x),
                    preventDuplicates: false);
              },
              child: Container(
                width: witdhIcon * 3.5,
                height: 190,
                margin: EdgeInsets.only(
                    left: index == 0 ? paddingSize : 0,
                    right: index >= (datas.length - 1)
                        ? (spaceIcon * 2)
                        : spaceIcon,
                    bottom: 8),
                child: ItemPostHorizontal(post: e, x: x),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget listArticlesHorizontal(
      final XController x, final List<PostModel> datas) {
    return SizedBox(
      height: GetPlatform.isAndroid ? Get.height / 2.55 : Get.height / 2.95,
      child: ListView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: datas.map((e) {
          final int index = datas.indexOf(e);
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Get.to(DetailArticle(article: e));
              },
              child: Container(
                width: witdhIcon * 3.5,
                height: 190,
                margin: EdgeInsets.only(
                    left: index == 0 ? paddingSize : 0,
                    right: index >= (datas.length - 1)
                        ? (spaceIcon * 2)
                        : spaceIcon,
                    bottom: 8),
                child: InputContainer(
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
                                    ? ExtendedImage.network(
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
                                    padding: const EdgeInsets.only(
                                        bottom: 3, left: 3),
                                    child: LikeButton(
                                      size: 15,
                                      isLiked: e.liked == 1,
                                      likeBuilder: (bool isLiked) {
                                        return Icon(
                                          BootstrapIcons.bookmark_fill,
                                          color: isLiked
                                              ? Colors.amber
                                              : Colors.grey,
                                          size: 15,
                                        );
                                      },
                                      onTap: (bool isLiked) async {
                                        Future.microtask(() =>
                                            MyHomePage.pushLikeOrDislike(
                                                x, e, null, !isLiked));
                                        await Future.delayed(
                                            const Duration(milliseconds: 600));
                                        return !isLiked;
                                      },
                                    ),
                                  ),
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
                                                    child:
                                                        ExtendedImage.network(
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
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 5),
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
                                style: textSmallGrey.copyWith(
                                    color: Colors.deepOrange),
                              ),
                            ],
                          ),
                        ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ItemStat(e: e),
                            Text(
                              e.getSizeFile(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textSmallGrey.copyWith(
                                fontWeight: FontWeight.w800,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget listHotelCollectionsHorizontal(
      final List<CityCategoryModel> datas, final int isSelected) {
    List<CityCategoryModel> infos = datas..shuffle();

    return SizedBox(
      height: GetPlatform.isAndroid ? Get.height / 2.7 : Get.height / 3.1,
      child: ListView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: infos.map((e) {
          final int index = infos.indexOf(e);
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Get.to(CityCategoryPage(
                  title: 'Special Hotel Collection',
                  cityCategoryModel: e,
                ));
              },
              child: Container(
                width: witdhIcon * 3,
                height: 190,
                margin: EdgeInsets.only(
                    left: index == 0 ? paddingSize : 0,
                    right: index >= (infos.length - 1)
                        ? (spaceIcon * 2)
                        : spaceIcon,
                    bottom: 8),
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
                              e.image1!,
                              width: witdhIcon * 3,
                              height: witdhIcon * 1.75,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 10, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${e.nmCategory}".toUpperCase(),
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Row(
                              children: [
                                Text("${e.getRating()}",
                                    style: textBold.copyWith(fontSize: 15)),
                                spaceWidth5,
                                RatingBar.builder(
                                  initialRating: e.rating!,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  ignoreGestures: true,
                                  itemSize: 15,
                                  itemCount: 1,
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
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 5),
                        child: SizedBox(
                          child: Text(
                            "${e.title}",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget listInfosTravel(final List<CityCategoryModel> guides) {
    return SizedBox(
      height: GetPlatform.isAndroid ? Get.height / 2.7 : Get.height / 3.1,
      child: ListView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: guides.map((e) {
          final int index = guides.indexOf(e);
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Get.to(CityCategoryPage(
                  title: 'insider_travel_guide'.tr,
                  cityCategoryModel: e,
                ));
              },
              child: Container(
                width: witdhIcon * 3,
                height: 190,
                margin: EdgeInsets.only(
                    left: index == 0 ? paddingSize : 0,
                    right: index >= (guides.length - 1)
                        ? (spaceIcon * 2)
                        : spaceIcon,
                    bottom: 8),
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
                              e.image1!,
                              width: witdhIcon * 3,
                              height: witdhIcon * 1.75,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 10, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${e.nmCategory}".toUpperCase(),
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Row(
                              children: [
                                Text("${e.getRating()}",
                                    style: textBold.copyWith(fontSize: 15)),
                                spaceWidth5,
                                RatingBar.builder(
                                  initialRating: e.rating!,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  ignoreGestures: true,
                                  itemSize: 15,
                                  itemCount: 1,
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
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 5),
                        child: SizedBox(
                          child: Text(
                            "${e.title}",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                height: 1.2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget listInfosHorizontal(final List<dynamic> infos) {
    return SizedBox(
      height: GetPlatform.isAndroid ? Get.height / 2.7 : Get.height / 3.1,
      child: ListView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: infos.map((e) {
          final int index = infos.indexOf(e);
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Get.to(DetailArticle(article: e));
              },
              child: Container(
                width: witdhIcon * 3,
                height: 190,
                margin: EdgeInsets.only(
                    left: index == 0 ? paddingSize : 0,
                    right: index >= (infos.length - 1)
                        ? (spaceIcon * 2)
                        : spaceIcon,
                    bottom: 8),
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
                              e['image'],
                              width: witdhIcon * 3,
                              height: witdhIcon * 1.75,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 10),
                        child: Text("${e['category']}".toUpperCase(),
                            style: const TextStyle(color: Colors.grey)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 5),
                        child: SizedBox(
                          child: Text(
                            "${e['title']}",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                height: 1.2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget createSlider(final List<SlideModel> datas) {
    List<SlideModel> sliders = datas..shuffle();
    return SizedBox(
      child: SizedBox(
        height: Get.height / 5,
        width: Get.width,
        child: Carousel(
          boxFit: BoxFit.contain,
          autoplay: true,
          autoplayDuration: const Duration(milliseconds: 1000 * 35),
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
          images: sliders.map((SlideModel e) {
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  List<dynamic> dataImages = [];
                  for (var e in sliders) {
                    dataImages.add({"image": e.image!});
                  }

                  Get.to(GalleryPhoto(
                      images: dataImages, initialIndex: sliders.indexOf(e)));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Get.theme.backgroundColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: ExtendedImage.network(
                      e.image!,
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

  Widget listCitiesHorizontal(final List<CityModel>? temps) {
    List<CityModel> temp2 = temps!..shuffle();
    List<CityModel> dataCities = [];
    for (CityModel e in temp2) {
      dataCities.add(e);
    }

    dataCities.add(CityModel(title: 'More'));

    return SizedBox(
      height: Get.height / 5.5,
      child: ListView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: dataCities.map((e) {
          final int index = dataCities.indexOf(e);
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (e.title == 'More') {
                  Get.to(CityPage(cities: temps));
                } else {
                  Get.to(DetailCity(info: e));
                }
              },
              child: Container(
                width: witdhIcon,
                height: 190,
                margin: EdgeInsets.only(
                    left: index == 0 ? paddingSize : 0,
                    right: index >= (dataCities.length - 1)
                        ? (spaceIcon * 2)
                        : spaceIcon),
                child: e.title == 'More'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Get.theme.backgroundColor,
                                shape: BoxShape.circle,
                              ),
                              width: witdhIcon,
                              height: witdhIcon,
                              child: const Center(
                                child:
                                    Icon(BootstrapIcons.chevron_double_right),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "${e.title}",
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Get.theme.backgroundColor,
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: ExtendedImage.network(
                                  e.image!,
                                  width: witdhIcon,
                                  height: witdhIcon,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "${e.title}",
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  static Widget listUsersHorizontal(final List<UserModel>? temps) {
    List<UserModel> temp2 = temps!..shuffle();
    List<UserModel> dataLists = [];
    for (UserModel e in temp2) {
      if (e.image != null) {
        dataLists.add(e);
      }
    }

    dataLists.add(UserModel(id: "xxx", fullname: 'More'));

    return SizedBox(
      height: Get.height / 5.5,
      child: ListView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: dataLists.map((e) {
          final int index = dataLists.indexOf(e);
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (e.id == 'xxx') {
                  Get.to(UserListPage(), transition: Transition.fadeIn);
                } else {
                  Get.to(OtherProfilePage(user: e));
                }
              },
              child: Container(
                width: witdhIcon,
                height: 190,
                margin: EdgeInsets.only(
                    left: index == 0 ? paddingSize : 5,
                    right: index >= dataLists.length - 1 ? 15 : 5),
                child: e.id == 'xxx'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Get.theme.backgroundColor,
                                shape: BoxShape.circle,
                              ),
                              width: witdhIcon,
                              height: witdhIcon,
                              child: const Center(
                                child:
                                    Icon(BootstrapIcons.chevron_double_right),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "${e.fullname}",
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Get.theme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(3),
                              child: ClipOval(
                                child: ExtendedImage.network(
                                  e.image!,
                                  width: witdhIcon / 1.3,
                                  height: witdhIcon / 1.3,
                                  fit: BoxFit.cover,
                                  cache: true,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "${e.fullname}",
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  static Widget inputSearch(final bool isDark) {
    //print("inputSearch isDark : $isDark");
    return SizedBox(
      child: InputContainer(
        backgroundColor: Get.theme.backgroundColor,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Get.to(SearchPage());
            },
            child: TextField(
              enabled: false,
              decoration: inputForm(
                Get.theme.backgroundColor,
                25,
                const EdgeInsets.only(left: 0, right: 0, top: 12, bottom: 0),
              ).copyWith(
                hintText: 'Search',
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  child: Icon(
                    BootstrapIcons.search,
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
}
