import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/models/post_model.dart';
import 'package:plantripapp/screens/home_screen.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/input_container.dart';

class MyPostListPage extends StatelessWidget {
  MyPostListPage({Key? key}) : super(key: key) {
    fetchDataPost("1");
  }

  final XController x = XController.to;
  final dataPlaces = <PostModel>[].obs;
  final dataArticles = <PostModel>[].obs;
  final dataTemps = <PostModel>[].obs;

  onSearch(final String search, final int selected) {
    if (selected == 0) {
      dataPlaces.value = dataTemps
          .where((user) => user.title!.toLowerCase().contains(search))
          .toList();
    } else {
      dataArticles.value = dataTemps
          .where((user) => user.title!.toLowerCase().contains(search))
          .toList();
    }
  }

  fetchDataPost(final String flag) {
    debugPrint("fetchDataPost running flag $flag");
    final XController x = XController.to;
    Future.microtask(() async {
      final dataPost = jsonEncode({
        "lt": "0,100",
        "iu": x.thisUser.value.id,
        "lat": x.latitude,
        "fl": flag
      });
      debugPrint(dataPost);
      final response =
          await x.provider.pushResponse("post/get_byid_user", dataPost);

      if (response != null && response.statusCode == 200) {
        dynamic dataresult = jsonDecode(response.bodyString!);

        if (dataresult['code'] == '200') {
          List<dynamic>? posts = dataresult['result'];
          List<PostModel> tempPosts = [];
          if (posts != null && posts.isNotEmpty) {
            for (dynamic e in posts) {
              //debugPrint(e.toString());
              try {
                if (flag == e['flag']) {
                  tempPosts.add(PostModel.fromMap(e));
                }
              } catch (e) {
                debugPrint("Error4444 ${e.toString()}");
              }
            }
          }

          debugPrint("Length Post: ${tempPosts.length}");
          if (flag == '1') {
            dataPlaces.value = tempPosts;
            dataTemps.value = tempPosts;
          } else {
            dataArticles.value = tempPosts;
            dataTemps.value = tempPosts;
          }
        }
      }
    });
  }

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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: Get.mediaQuery.padding.top * 0.35,
                      left: paddingSize * 0.8,
                      right: paddingSize * 0.45,
                    ),
                    child: topHeader(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: Get.mediaQuery.padding.top * 0.25,
                      left: paddingSize * 0.8,
                      right: paddingSize * 0.8,
                    ),
                    child: Obx(
                      () => inputSearch(x.isDarkMode.value, selectedMenu.value),
                    ),
                  ),
                  spaceHeight20,
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 0,
                      right: 0,
                    ),
                    child: Obx(
                      () => HomeScreen.listTopPosts(
                        x,
                        selectedMenu.value == 0 ? dataPlaces : dataArticles,
                        false,
                        true,
                        () {
                          //callback
                          fetchDataPost(selectedMenu.value == 0 ? "1" : "2");
                        },
                      ),
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

  Widget inputSearch(final bool isDark, final int selected) {
    return SizedBox(
      child: InputContainer(
        backgroundColor: Get.theme.backgroundColor,
        child: TextField(
          onChanged: (value) => onSearch(value, selected),
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
    );
  }

  final List<String> menus = ["Place", "Article"];
  final selectedMenu = 0.obs;

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
              child: Row(
                children: [
                  const Icon(
                    BootstrapIcons.chevron_left,
                    size: 25,
                  ),
                  spaceWidth5,
                  Text("My Post",
                      style: textBig.copyWith(fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 0),
            child: Obx(
              () => Row(
                children: menus.map((e) {
                  final index = menus.indexOf(e);
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        selectedMenu.value = index;
                        fetchDataPost(selectedMenu.value == 0 ? "1" : "2");
                      },
                      child: Container(
                        padding: const EdgeInsets.only(right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e,
                              style: textTitle.copyWith(
                                  fontSize:
                                      selectedMenu.value == index ? 14 : 12,
                                  color: selectedMenu.value == index
                                      ? Get.theme.textTheme.bodyText1!.color!
                                      : Colors.grey),
                            ),
                            if (selectedMenu.value == index)
                              Container(
                                color: Get.theme.primaryColor,
                                width: 30,
                                height: 5,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
