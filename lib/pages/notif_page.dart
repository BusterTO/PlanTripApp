import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/models/notif_model.dart';
import 'package:plantripapp/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class NotifPage extends StatelessWidget {
  NotifPage({Key? key}) : super(key: key) {
    Future.microtask(() {
      listNotifs.value = x.itemHome.value.notifs!;
    });
  }

  final ScrollController _controller = ScrollController();
  final XController x = XController.to;

  final isProcessLoad = false.obs;
  final loading = false.obs;

  final listNotifs = <NotifModel>[].obs;

  _scrollListener() {
    //debugPrint("_scrollListener running...");

    try {
      if (_controller.offset >= _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange) {
        //controll load more duplicated
        reloadData();
      }

      if (_controller.offset <= _controller.position.minScrollExtent &&
          !_controller.position.outOfRange) {}
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
    }
  }

  reloadData() async {
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
    List<NotifModel> temps = [];
    Future.microtask(() async {
      final response = await x.provider.pushResponse("post/get_notif",
          jsonEncode({"lt": nextPage, "iu": x.thisUser.value.id}));

      if (response != null && response.statusCode == 200) {
        dynamic dataresult = jsonDecode(response.bodyString!);

        if (dataresult['code'] == '200') {
          List<dynamic>? posts = dataresult['result'];

          if (posts != null && posts.isNotEmpty) {
            for (dynamic e in posts) {
              //debugPrint(e.toString());
              try {
                temps.add(NotifModel.fromMap(e));
              } catch (e) {
                debugPrint("Error4444 ${e.toString()}");
              }
            }
            debugPrint("Length Post: ${temps.length}");
            listNotifs.value = temps;

            x.updateLimitPage(nextPage);
          } else {
            listNotifs.value = temps;
          }
        }
      } else {
        listNotifs.value = temps;
      }

      loading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("NotifPage ${x.isDarkMode.value}");
    Future.delayed(const Duration(seconds: 3), () {
      _controller.addListener(_scrollListener);
    });

    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          body: SizedBox(
            width: Get.width,
            height: Get.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: Get.mediaQuery.padding.top),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 0, top: 8, bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: Get.back,
                        icon: const Icon(BootstrapIcons.chevron_left, size: 28),
                      ),
                      Text("Notification",
                          style: Get.theme.textTheme.headline6),
                      spaceWidth50,
                    ],
                  ),
                ),
                //spaceHeight5,
                Flexible(
                  child: SingleChildScrollView(
                    controller: _controller,
                    physics: const BouncingScrollPhysics(),
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          spaceHeight10,
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            child: listNotif(listNotifs),
                          ),
                          if (loading.value)
                            Container(
                              width: Get.width,
                              alignment: Alignment.center,
                              padding: padding20,
                              child: MyTheme.loading(),
                            ),
                          spaceHeight50,
                        ],
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
  }

  Widget listNotif(final List<NotifModel> notifs) {
    return notifs.isEmpty
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
                Text("not_found".tr, style: textBold),
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: notifs.map((NotifModel e) {
              final int idx = notifs.indexOf(e);
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    showDialogDetail(e);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 19, vertical: 13),
                    decoration: BoxDecoration(
                      //color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Get.theme.backgroundColor.withOpacity(.5),
                          blurRadius: 5.0,
                          offset: const Offset(2, 5),
                        )
                      ],
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(left: 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${e.title}",
                              style: textBold.copyWith(fontSize: 14)),
                          Text(
                            "${e.description}",
                            maxLines: 3,
                            style: textSmall.copyWith(
                              fontSize: 12,
                            ),
                          ),
                          Container(
                            height: 33,
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  MyTheme.formattedComment(e.dateCreated!),
                                  style: textSmallGrey,
                                ),
                                IconButton(
                                  onPressed: () async {
                                    EasyLoading.show(status: 'Loading...');
                                    await Future.delayed(
                                        const Duration(milliseconds: 1200),
                                        () async {
                                      await x.provider.pushResponse(
                                          "post/get_notif",
                                          jsonEncode(
                                              {"act": "delete", "id": e.id!}));
                                      reloadData();

                                      EasyLoading.dismiss();
                                    });

                                    Future.delayed(
                                        const Duration(milliseconds: 1500), () {
                                      if (listNotifs.length < 2) {
                                        listNotifs.value = [];
                                      } else {
                                        listNotifs.removeAt(idx);
                                      }
                                      x.asyncHome();
                                    });
                                  },
                                  icon: const Icon(
                                    BootstrapIcons.trash,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
  }

  showDialogDetail(final NotifModel model) {
    showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (context) => Container(
        width: Get.width,
        height: Get.height * 2,
        color: Get.theme.backgroundColor,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: Get.width,
                height: Get.height,
                margin: const EdgeInsets.only(top: 60),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.width,
                      child: Text(
                        "information".tr,
                        textAlign: TextAlign.center,
                        style: textBold.copyWith(fontSize: 18),
                      ),
                    ),
                    spaceHeight20,
                    Text("${model.title}",
                        style: textBold.copyWith(fontSize: 16)),
                    Text(
                      "${model.description}",
                      style: textSmall.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      height: 33,
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${model.dateCreated}",
                            style: textSmallGrey,
                          ),
                        ],
                      ),
                    ),
                    spaceHeight15,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            margin: const EdgeInsets.only(
                                left: 0, right: 0, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("close".tr,
                                    style: textSmall.copyWith(fontSize: 18))
                              ],
                            ),
                          ),
                        ),
                        spaceWidth10,
                      ],
                    ),
                    spaceHeight20,
                    spaceHeight20,
                  ],
                ),
              ),
              Positioned(
                top: 10,
                left: 0,
                child: Container(
                  margin: const EdgeInsets.only(top: 0),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(BootstrapIcons.chevron_down, size: 30)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
