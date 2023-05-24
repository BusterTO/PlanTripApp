import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/models/category_model.dart';
import 'package:plantripapp/models/post_model.dart';
import 'package:plantripapp/pages/places_page.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/input_container.dart';
import 'package:plantripapp/widgets/item_user_circle.dart';
import 'package:plantripapp/widgets/row_maploc.dart';

class HappeningScreen extends StatelessWidget {
  HappeningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final XController x = XController.to;

    return Obx(
      () => createBody(x, x.isDarkMode.value, indexCollectionSelected.value),
    );
  }

  Widget createBody(
      final XController x, final bool isDark, final int selected) {
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
                  Padding(
                    padding:
                        EdgeInsets.only(top: Get.mediaQuery.padding.top * 0.65),
                    child: listCategoriesHorizontal(
                        x.itemHome.value.categories!, selected),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child:
                        descHappening(x.itemHome.value.categories![selected]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: listPosts(x.itemHome.value.all!, selected,
                        x.itemHome.value.categories![selected]),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget descHappening(final CategoryModel category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: paddingSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${category.title}",
              style: Get.theme.textTheme.headline6!
                  .copyWith(fontWeight: FontWeight.bold)),
          //spaceHeight10,
          Text("${category.description}",
              style: Get.theme.textTheme.caption!.copyWith(fontSize: 15)),
        ],
      ),
    );
  }

  static Widget listPosts(final List<PostModel> datas, final int isSelected,
      final CategoryModel? categ) {
    List<PostModel> infos = [];
    for (var element in datas) {
      if (categ != null) {
        if (element.idCategory == categ.id) {
          infos.add(element);
        }
      } else {
        infos.add(element);
      }
    }

    return SizedBox(
      width: Get.width,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: infos.map((PostModel e) {
          final int index = infos.indexOf(e);
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Get.to(PlacePage(postModel: e));
              },
              child: Container(
                width: Get.width,
                height:
                    GetPlatform.isAndroid ? Get.height / 1.9 : Get.height / 2.2,
                margin: EdgeInsets.only(
                    left: paddingSize / 1.5,
                    right: paddingSize / 1.5,
                    bottom: index >= (infos.length - 1)
                        ? (spaceIcon * 3)
                        : spaceIcon * 1.5),
                child: InputContainer(
                  backgroundColor: Get.theme.backgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Get.theme.backgroundColor,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                            ),
                            child: e.listImages().isNotEmpty
                                ? ExtendedImage.network(
                                    e.image1!,
                                    width: Get.width,
                                    height: witdhIcon * 2.25,
                                    fit: BoxFit.cover,
                                  )
                                : ExtendedImage.asset(
                                    e.getDefaultImage(),
                                    width: Get.width,
                                    height: witdhIcon * 2.25,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 15, top: 5, bottom: 5),
                        child: SizedBox(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  "${e.title}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              index.isEven
                                  ? Icon(
                                      BootstrapIcons.arrow_up_right,
                                      color: Get.theme.primaryColor,
                                      size: 18,
                                    )
                                  : const Icon(
                                      BootstrapIcons.arrow_down_right,
                                      color: Colors.redAccent,
                                      size: 18,
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text("${e.desc}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.grey,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 15,
                          bottom: 0,
                          top: 10,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("${e.rating}",
                                    style: textBold.copyWith(fontSize: 15)),
                                spaceWidth5,
                                RatingBar.builder(
                                  initialRating: e.rating!,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  ignoreGestures: true,
                                  itemSize: 12,
                                  itemCount: 5,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  itemBuilder: (context, _) => const Icon(
                                    BootstrapIcons.star_fill,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    debugPrint(rating.toString());
                                  },
                                ),
                              ],
                            ),
                            (e.otherUsers != null && e.otherUsers!.isNotEmpty)
                                ? ItemUserCircle(otherUser: e.otherUsers!)
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(0),
                        margin: const EdgeInsets.only(
                          left: tabIconSize,
                          right: tabIconSize,
                          bottom: 8,
                          top: 15,
                        ),
                        child: RowMapLoc(e: e),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  final indexCollectionSelected = 0.obs;
  Widget listCategoriesHorizontal(
      final List<CategoryModel> collects, final int isSelected) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: collects.map((CategoryModel e) {
          final int index = collects.indexOf(e);
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                indexCollectionSelected.value = index;
              },
              child: Container(
                margin: EdgeInsets.only(
                    left: index == 0 ? (paddingSize - 10) : 0,
                    right: index >= (collects.length - 1)
                        ? (spaceIcon * 2)
                        : spaceIcon - 5,
                    bottom: 8),
                child: InputContainer(
                  backgroundColor: isSelected == index
                      ? Get.theme.primaryColor
                      : Get.theme.backgroundColor,
                  radius: 10,
                  boxShadow: BoxShadow(
                    color: Colors.grey.withOpacity(.3),
                    offset: const Offset(1, 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 19),
                        alignment: Alignment.center,
                        child: Text(
                          "${e.title}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected == index
                                  ? Get.theme.backgroundColor
                                  : Get.theme.textTheme.bodyText2!.color),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
