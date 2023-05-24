import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/models/post_model.dart';
import 'package:plantripapp/screens/happening_screen.dart';
import 'package:plantripapp/theme.dart';

class ResultSearchPage extends StatelessWidget {
  final String query;

  ResultSearchPage({Key? key, required this.query}) : super(key: key) {
    final XController x = XController.to;
    Future.microtask(() async {
      final response = await x.provider.pushResponse(
          "post/latest", jsonEncode({"qy": query, "iu": x.thisUser.value.id}));

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
    });
  }

  final dataPosts = <PostModel>[].obs;
  @override
  Widget build(BuildContext context) {
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
                    top: Get.mediaQuery.padding.top / 3.5,
                    bottom: 0,
                    left: paddingSize * 0.3,
                    right: paddingSize * 0.8,
                  ),
                  child: topHeader(),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      right: 0,
                    ),
                    child: Obx(
                      () => createBody(dataPosts),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createBody(final List<PostModel> results) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 0,
              right: 0,
            ),
            child: HappeningScreen.listPosts(results, 0, null),
          ),
          spaceHeight50,
        ],
      ),
    );
  }

  Widget topHeader() {
    return Container(
      margin: const EdgeInsets.only(left: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            iconSize: 18,
            constraints: const BoxConstraints(),
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              BootstrapIcons.chevron_left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 0),
            child: Text(
              "Result of $query",
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
