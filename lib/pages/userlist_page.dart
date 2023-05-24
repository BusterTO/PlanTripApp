import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/models/user_model.dart';
import 'package:plantripapp/pages/other_profile_page.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/input_container.dart';

class UserListPage extends StatelessWidget {
  UserListPage({Key? key}) : super(key: key) {
    Future.microtask(() {
      listUsers.value = x.itemHome.value.users!;
      tempUsers.value = x.itemHome.value.users!;
    });
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
                    right: paddingSize * 0.45,
                  ),
                  child: topHeader(x),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                    left: paddingSize * 0.8,
                    right: paddingSize * 0.45,
                  ),
                  child: inputSearch(x.isDarkMode.value),
                ),
                spaceHeight10,
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: paddingSize * 0.8,
                      right: paddingSize * 0.45,
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

  final listUsers = <UserModel>[].obs;
  final tempUsers = <UserModel>[].obs;

  final isProcessLoad = false.obs;
  final loading = false.obs;

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
        var split1 = x.pagingLimit.value.split(",");
        int start = int.parse(split1[0]) + pagePaging;

        String nextPage = "$start,${split1[1]}";
        debugPrint("nextPagePage... $nextPage");

        Future.microtask(() async {
          final response = await x.provider.pushResponse(
              "user/get_user",
              jsonEncode({
                "lt": nextPage,
              }));

          if (response != null && response.statusCode == 200) {
            dynamic dataresult = jsonDecode(response.bodyString!);

            if (dataresult['code'] == '200') {
              List<dynamic>? posts = dataresult['result'];
              List<UserModel> temps = [];
              if (posts != null && posts.isNotEmpty) {
                for (dynamic e in posts) {
                  //debugPrint(e.toString());
                  try {
                    temps.add(UserModel.fromJson(e));
                  } catch (e) {
                    debugPrint("Error4444 ${e.toString()}");
                  }
                }
              }

              debugPrint("Length Post: ${temps.length}");
              listUsers.value = temps;
              tempUsers.value = temps;

              x.updateLimitPage(nextPage);
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
            () => listOfPeople(x, listUsers, loading.value),
          ),
          spaceHeight20,
        ],
      ),
    );
  }

  onSearch(String search) {
    listUsers.value = tempUsers
        .where((user) => user.fullname!.toLowerCase().contains(search))
        .toList();
  }

  Widget inputSearch(final bool isDark) {
    return SizedBox(
      child: InputContainer(
        backgroundColor: Get.theme.backgroundColor,
        child: TextField(
          onChanged: (value) => onSearch(value),
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

  Widget listOfPeople(final XController x, final List<UserModel>? peoples,
      final bool isLoading) {
    return SizedBox(
      width: Get.width,
      child: peoples!.isEmpty
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
                GridView.builder(
                  // controller: _controller,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (_, index) => Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Get.to(OtherProfilePage(user: peoples[index]),
                            transition: Transition.fadeIn);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 0),
                        child: Column(
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
                                padding: const EdgeInsets.all(3),
                                child: ClipOval(
                                  child: ExtendedImage.network(
                                    peoples[index].image!,
                                    width: witdhIcon / 1.2,
                                    height: witdhIcon / 1.2,
                                    fit: BoxFit.cover,
                                    cache: true,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                peoples[index].fullname!,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  height: 1.1,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  itemCount: peoples.length,
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

  Widget topHeader(final XController x) {
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
            child: Row(
              children: [
                Text(
                  "users".tr,
                  style: textTitle.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                spaceWidth5,
                Text(
                  "(${MyTheme.numberFormatDisplay(x.itemHome.value.totalUsers)})",
                  style: textTitle.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
