import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/models/post_model.dart';
import 'package:plantripapp/screens/home_screen.dart';
import 'package:plantripapp/theme.dart';

class ListArticlePage extends StatelessWidget {
  final List<PostModel> datas;
  final String? title;
  const ListArticlePage({Key? key, required this.title, required this.datas})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final XController x = XController.to;
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
                      top: 0,
                      right: 0,
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

  Widget createBody(final XController x) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
              right: 0,
            ),
            child: HomeScreen.listTopArticles(x, datas, 0),
          ),
          spaceHeight50,
        ],
      ),
    );
  }

  Widget topHeader() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15, left: 5),
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
              title!,
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
