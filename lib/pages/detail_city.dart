import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/models/city_model.dart';
import 'package:plantripapp/models/post_model.dart';
import 'package:plantripapp/screens/happening_screen.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/input_container.dart';

class DetailCity extends StatelessWidget {
  final CityModel info;
  DetailCity({Key? key, required this.info}) : super(key: key) {
    final XController x = XController.to;
    Future.microtask(() async {
      final response = await x.provider.pushResponse(
          "post/latest",
          jsonEncode({
            "ct": info.id,
            "iu": x.thisUser.value.id,
          }));

      if (response != null && response.statusCode == 200) {
        dynamic dataresult = jsonDecode(response.bodyString!);

        if (dataresult['code'] == '200') {
          List<dynamic>? posts = dataresult['result'];
          List<PostModel> tempPosts = [];
          if (posts != null && posts.isNotEmpty) {
            for (dynamic e in posts) {
              //debugPrint(e.toString());
              try {
                tempPosts.add(PostModel.fromMap(e));
              } catch (e) {
                debugPrint("Error4444 ${e.toString()}");
              }
            }
          }

          debugPrint("Length Post: ${tempPosts.length}");
          dataPosts.value = tempPosts;
        }
      }

      isRefresh.value = false;
    });
  }

  final dataPosts = <PostModel>[].obs;
  final isRefresh = true.obs;

  @override
  Widget build(BuildContext context) {
    //final title = 'Floating App Bar';
    var tgl = info.createdAt;
    //debugPrint("image ${info.image}");
    try {
      if (info.createdAt != null && info.createdAt!.length > 5) {
        var newDateTimeObj2 =
            DateFormat("yyyy-MM-dd HH:mm:ss").parse(info.createdAt!);
        tgl = DateFormat().add_yMMMEd().add_Hms().format(newDateTimeObj2);
      }
    } catch (e) {
      debugPrint("error1 ${e.toString()}");
    }

    //debugPrint(tgl);

    return Container(
      width: Get.width,
      height: Get.height,
      color: Get.theme.scaffoldBackgroundColor,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: CustomScrollView(
            slivers: <Widget>[
              // Add the app bar to the CustomScrollView.
              SliverAppBar(
                backgroundColor: Get.theme.scaffoldBackgroundColor,
                elevation: 0.1,
                automaticallyImplyLeading: false,
                // Provide a standard title.
                title: Container(
                  padding: EdgeInsets.zero,
                  child: topHeader(),
                ),
                floating: true,
                pinned: true,
                snap: false,
                stretch: true,
                expandedHeight: Get.height / 3,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const <StretchMode>[
                    StretchMode.zoomBackground,
                    StretchMode.fadeTitle,
                  ],
                  background: InkWell(
                    onTap: () {
                      debugPrint("click photo...");
                      Get.dialog(MyTheme.photoView('${info.image}'),
                          transitionCurve: Curves.bounceInOut);
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 0),
                          child: ExtendedImage.network(
                            '${info.image}',
                            fit: BoxFit.fill,
                          ),
                        ),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0.0, 0.5),
                              end: Alignment(0.0, 0.0),
                              colors: <Color>[
                                Color(0x60000000),
                                Color(0x00000000),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Next, create a SliverList
              SliverList(
                // Use a delegate to build items as they're scrolled on screen.
                delegate: SliverChildBuilderDelegate(
                  // The builder function returns a ListTile with a title that
                  // displays the index of the current item.
                  (context, index) => Container(
                    padding: const EdgeInsets.all(0),
                    margin: const EdgeInsets.only(bottom: 20),
                    color: Get.theme.scaffoldBackgroundColor,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              spaceHeight10,
                              Container(
                                width: Get.width,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: Text(
                                  '${info.title}',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              Container(
                                width: Get.width,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: Text(
                                  tgl!,
                                  textAlign: TextAlign.left,
                                  style: textSmallGrey,
                                ),
                              ),
                              spaceHeight5,
                              Obx(
                                () => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  width: Get.width,
                                  child: Text(
                                    '${dataPosts.length} place(s) found',
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              spaceHeight10,
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Obx(
                                  () => dataPosts.isNotEmpty
                                      ? HappeningScreen.listPosts(
                                          dataPosts, 0, null)
                                      : Container(
                                          padding: const EdgeInsets.all(10),
                                          width: Get.width,
                                          child: Center(
                                            child: isRefresh.value
                                                ? MyTheme.loading()
                                                : SizedBox(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        spaceHeight20,
                                                        Image.asset(
                                                          "assets/not_found.png",
                                                          height: 110,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      30,
                                                                  vertical: 5),
                                                          child: Text(
                                                            "No Data Found!",
                                                            style: Get
                                                                .theme
                                                                .textTheme
                                                                .headline6!
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      30,
                                                                  vertical: 0),
                                                          child: Text(
                                                            "Try another category or city",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: textSmall
                                                                .copyWith(
                                                              color: Get
                                                                  .theme
                                                                  .textTheme
                                                                  .caption!
                                                                  .color,
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
                                ),
                              ),
                              spaceHeight10,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Builds 1000 ListTiles
                  childCount: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget topHeader() {
    return Container(
      margin: EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
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
                    Get.back();
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
                            Icon(BootstrapIcons.chevron_left,
                                size: 18,
                                color: Get.isDarkMode
                                    ? Get.theme.primaryColorLight
                                    : Get.theme.primaryColor),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: InputContainer(
                    backgroundColor: Get.theme.backgroundColor,
                    radius: 17,
                    boxShadow: BoxShadow(
                      color: Colors.grey.withOpacity(.3),
                      offset: const Offset(1, 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 10, bottom: 10, top: 10, right: 5),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              LikeButton(
                                size: 17,
                                likeBuilder: (bool isLiked) {
                                  return Icon(
                                    isLiked
                                        ? BootstrapIcons.bookmark_fill
                                        : BootstrapIcons.bookmark,
                                    color: isLiked
                                        ? Colors.red
                                        : Get.isDarkMode
                                            ? Get.theme.primaryColorLight
                                            : Get.theme.primaryColor,
                                    size: 17,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                spaceWidth5,
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
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
                          MyTheme.onShare("Information", contentToShare, []);
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
                                  Icon(
                                    BootstrapIcons.share,
                                    color: Get.isDarkMode
                                        ? Get.theme.primaryColorLight
                                        : Get.theme.primaryColor,
                                    size: 18,
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
