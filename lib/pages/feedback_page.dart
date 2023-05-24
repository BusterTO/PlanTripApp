import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/theme.dart';

class FeedbackPage extends StatelessWidget {
  final TextEditingController _deController = TextEditingController();

  FeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var thisRating = 5.0;
    final XController x = XController.to;

    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Get.theme.backgroundColor,
            elevation: 0.5,
            centerTitle: true,
            title: Text(
              "feedback".tr,
            ),
          ),
          body: Container(
            height: Get.height,
            width: Get.width,
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    child: Text(
                      "information".tr,
                      textAlign: TextAlign.center,
                      style: Get.theme.textTheme.headline6,
                    ),
                  ),
                  spaceHeight20,
                  spaceHeight10,
                  Container(
                    alignment: Alignment.center,
                    child: RatingBar.builder(
                      initialRating: 5,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        //debugPrint(rating);
                        thisRating = rating;
                        debugPrint(thisRating.toString());
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                        controller: _deController,
                        enabled: true,
                        maxLines: 5,
                        maxLength: 150,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'genius_feedback'.tr,
                          hintStyle: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                debugPrint("submitted");
                                String desc = _deController.text;
                                if (desc.isEmpty) {
                                  EasyLoading.showToast(
                                      "Description invalid...");
                                  return;
                                }
                                //Get.back();
                                EasyLoading.show(status: 'Loading...');
                                var dataPush = jsonEncode({
                                  "iu": "${x.thisUser.value.id}",
                                  "ds": desc.trim(),
                                  "rt": "$thisRating",
                                });

                                debugPrint(dataPush);

                                await x.provider.pushResponse(
                                  "user/feedback",
                                  dataPush,
                                );

                                await Future.delayed(
                                    const Duration(milliseconds: 1800));
                                EasyLoading.dismiss();
                                EasyLoading.showToast("done_thank".tr);
                                Get.back();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Get.theme.textTheme.button!.color!
                                          .withOpacity(0.2),
                                      blurRadius: 1.0,
                                      offset: const Offset(0.0, 6),
                                    )
                                  ],
                                  color: Get.theme.scaffoldBackgroundColor
                                      .withOpacity(.8),
                                  borderRadius: BorderRadius.circular(42),
                                ),
                                padding: const EdgeInsets.all(10),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 2, right: 5),
                                        child: const Icon(BootstrapIcons.check,
                                            size: 16, color: Colors.white),
                                      ),
                                      Text(
                                        "Submit",
                                        style: Get.theme.textTheme.subtitle2!
                                            .copyWith(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                debugPrint("submitted");

                                var phone = waPhone;
                                String text = "Hi $appName";

                                MyTheme.sendWA(phone, text);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Get.theme.textTheme.button!.color!
                                          .withOpacity(0.2),
                                      blurRadius: 1.0,
                                      offset: const Offset(0.0, 6),
                                    )
                                  ],
                                  color: Colors.green[600],
                                  borderRadius: BorderRadius.circular(42),
                                ),
                                padding: const EdgeInsets.all(10),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 2, right: 5),
                                        child: const Icon(
                                            BootstrapIcons.chat_square,
                                            size: 16,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        "WhatsApp",
                                        style: Get.theme.textTheme.subtitle2!
                                            .copyWith(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
