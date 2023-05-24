import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/models/city_model.dart';
import 'package:plantripapp/pages/detail_city.dart';
import 'package:plantripapp/pages/result_search_page.dart';
import 'package:plantripapp/screens/happening_screen.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/input_container.dart';
import 'package:shimmer/shimmer.dart';

class SearchPage extends StatelessWidget {
  final isLoading = false.obs;

  SearchPage({Key? key}) : super(key: key) {
    Future.microtask(() {
      isLoading.value = true;
      Future.delayed(const Duration(milliseconds: 1800), () {
        isLoading.value = false;
      });
    });
  }
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
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            width: Get.width,
            height: Get.height,
            color: Colors.transparent,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: Get.mediaQuery.padding.top * 0.45,
                      left: 0,
                      right: 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: paddingSize,
                            right: paddingSize,
                          ),
                          child: topHeader(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: paddingSize,
                            right: paddingSize,
                            bottom: 15,
                          ),
                          child: Text(
                            "Popular City",
                            style: Get.theme.textTheme.headline6!.copyWith(
                              fontSize: 18,
                              height: 1.2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 15,
                            right: paddingSize,
                            left: paddingSize,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                                child: wrapPopular(x.itemHome.value.cities!)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            right: paddingSize,
                            left: paddingSize,
                            bottom: 25,
                          ),
                          child: Text(
                            "Latest",
                            style: Get.theme.textTheme.headline6!.copyWith(
                              fontSize: 18,
                              height: 1.2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.zero,
                          child: Obx(
                            () => isLoading.value
                                ? shimmerList(isLoading.value)
                                : HappeningScreen.listPosts(
                                    x.itemHome.value.all!, 0, null),
                          ),
                        ),
                        spaceHeight50,
                      ],
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

  Widget wrapPopular(final List<CityModel> datas) {
    return SizedBox(
        child: Wrap(
      children: datas.map((e) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: InputContainer(
            backgroundColor: Get.theme.backgroundColor,
            boxShadow: BoxShadow(
              color: Colors.grey.withOpacity(.3),
              offset: const Offset(1, 2),
            ),
            radius: 15,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  //Get.to(DetailCategory(info: e));
                  Get.to(DetailCity(info: e));
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text("${e.title}", style: textBold),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ));
  }

  Widget shimmerList(final bool enabled) {
    return Container(
      width: Get.width,
      height: Get.height,
      margin: const EdgeInsets.only(top: 15),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        enabled: enabled,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: Get.width,
                  height: 148.0,
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                Container(
                  width: double.infinity,
                  height: 8.0,
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                ),
                Container(
                  width: double.infinity,
                  height: 8.0,
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                ),
                Container(
                  width: 40.0,
                  height: 8.0,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          itemCount: 6,
        ),
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
                size: 20,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: inputSearch(),
          ),
        ],
      ),
    );
  }

  Widget inputSearch() {
    return SizedBox(
      width: Get.width / 1.3,
      height: 50,
      child: InputContainer(
        backgroundColor: Get.theme.backgroundColor,
        radius: 25,
        child: TextField(
          onSubmitted: (text) {
            if (text.isNotEmpty) {
              Get.to(ResultSearchPage(query: text),
                  transition: Transition.cupertino);
            }
          },
          decoration: inputForm(Get.theme.backgroundColor, 25,
                  const EdgeInsets.only(left: 0, right: 0, top: 12, bottom: 0))
              .copyWith(
            hintText: 'Search',
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10, right: 5, top: 0),
              child: Icon(
                BootstrapIcons.search,
                color: Get.theme.primaryColor,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
