import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/models/comment_model.dart';
import 'package:plantripapp/pages/places_page.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/input_container.dart';

class ReviewListPage extends StatelessWidget {
  final List<CommentModel> comments;
  ReviewListPage({Key? key, required this.comments}) : super(key: key) {
    Future.microtask(() => listReviews.value = comments);
  }

  final ScrollController _controller = ScrollController();
  final XController x = XController.to;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      _controller.addListener(_scrollListener);
    });

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: Get.mediaQuery.padding.top * 0.35,
                    left: paddingSize * 0.8,
                    right: paddingSize * 0.8,
                  ),
                  child: topHeader(),
                ),
                spaceHeight10,
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: paddingSize * 0.8,
                      right: paddingSize * 0.8,
                    ),
                    child: createBody(x),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final listReviews = <CommentModel>[].obs;
  final isProcessLoad = false.obs;
  final loading = false.obs;
  final pagingLimit = "0,10".obs;

  _scrollListener() {
    //debugPrint("_scrollListener running...");

    try {
      if (_controller.offset >= _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange) {
        //controll load more duplicated
        if (isProcessLoad.value) return;
        isProcessLoad.value = true;
        Future.delayed(const Duration(milliseconds: 3500), () {
          isProcessLoad.value = false;
        });

        debugPrint("load more...");
        loading.value = true;
        var split1 = pagingLimit.value.split(",");
        int start = int.parse(split1[0]) + pagePaging;

        String nextPage = "$start,${split1[1]}";
        debugPrint("nextPagePage... $nextPage");

        Future.microtask(() async {
          final response = await x.provider.pushResponse(
              "post/get_comment",
              jsonEncode({
                "lt": nextPage,
                "ip": comments[0].idPost ?? "",
              }));

          if (response != null && response.statusCode == 200) {
            dynamic dataresult = jsonDecode(response.bodyString!);

            if (dataresult['code'] == '200') {
              List<dynamic>? posts = dataresult['result'];
              List<CommentModel> temps = [];
              if (posts != null && posts.isNotEmpty) {
                for (dynamic e in posts) {
                  //debugPrint(e.toString());
                  try {
                    temps.add(CommentModel.fromMap(e));
                  } catch (e) {
                    debugPrint("Error4444 ${e.toString()}");
                  }
                }
              }

              debugPrint("Length Post: ${temps.length}");
              listReviews.value = temps;

              pagingLimit.value = nextPage;
            }
          }

          loading.value = false;
        });
      }

      if (_controller.offset <= _controller.position.minScrollExtent &&
          !_controller.position.outOfRange) {}
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
    }
  }

  Widget createBody(final XController x) {
    return SingleChildScrollView(
      controller: _controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spaceHeight10,
          Obx(
            () => listOfReview(x, listReviews, loading.value),
          ),
          spaceHeight20,
        ],
      ),
    );
  }

  Widget listOfReview(final XController x, final List<CommentModel>? comments,
      final bool isLoading) {
    return SizedBox(
      width: Get.width,
      child: comments!.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset("assets/empty_data.png",
                        width: Get.width / 2),
                  ),
                  Text("not_found".tr,
                      textAlign: TextAlign.center, style: textBold),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: comments.map((e) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: InputContainer(
                        backgroundColor:
                            Get.theme.scaffoldBackgroundColor.withOpacity(.5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: PlacePage.onePlaceRowComment(x, e),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                if (isLoading)
                  Container(
                    width: Get.width,
                    alignment: Alignment.center,
                    padding: padding20,
                    child: MyTheme.loading(),
                  ),
                spaceHeight50,
              ],
            ),
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
                size: 25,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 0),
            child: Text(
              "Review".tr,
              style: textTitle.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
