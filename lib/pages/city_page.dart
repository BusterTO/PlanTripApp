import 'dart:ui';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:plantripapp/core/ads_helper.dart';
import 'package:plantripapp/models/city_model.dart';
import 'package:plantripapp/pages/detail_city.dart';
import 'package:plantripapp/theme.dart';

class CityPage extends StatelessWidget {
  final List<CityModel> cities;
  const CityPage({Key? key, required this.cities}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Container adContainer = Container();

    if (AdsHelper.bannerAd != null) {
      adContainer = Container(
        alignment: Alignment.center,
        width: AdsHelper.bannerAd!.size.width.toDouble(),
        height: AdsHelper.bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: AdsHelper.bannerAd!),
      );
    }

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
            child: Stack(
              children: [
                Column(
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
                        child: createBody(),
                      ),
                    ),
                  ],
                ),
                if (AdsHelper.bannerAd != null)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      width: Get.width,
                      child: adContainer,
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createBody() {
    final List<CityModel> dataCities = cities;

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
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(4),
              children: dataCities.map((e) {
                return SizedBox(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Get.to(DetailCity(info: e));
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: Container(
                              alignment: Alignment.center,
                              child: ClipRRect(
                                child: ImageFiltered(
                                  imageFilter: ImageFilter.blur(
                                      sigmaX: 2.5, sigmaY: 2.5),
                                  child: ExtendedImage.network(
                                    e.image!,
                                    width: Get.width,
                                    height: Get.height / 4,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Get.theme.primaryColor
                                          .withOpacity(.6),
                                    ),
                                    child: Text(
                                      e.title!,
                                      style: textBig.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          spaceHeight50,
        ],
      ),
    );
  }

  Widget createBodyOld() {
    final List<CityModel> dataCities = cities;

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
            child: GridView.builder(
              padding: const EdgeInsets.only(left: 10, right: 10),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.75,
                crossAxisSpacing: 5,
              ),
              itemBuilder: (_, index) => Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Get.to(DetailCity(info: cities[index]));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                    ),
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
                            child: ClipOval(
                              child: ExtendedImage.network(
                                dataCities[index].image!,
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
                            "${dataCities[index].title}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              itemCount: dataCities.length,
            ),
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
              "cities".tr,
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
