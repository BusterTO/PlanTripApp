import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:plantripapp/widgets/input_container.dart';

class GalleryPhoto extends StatelessWidget {
  final List<dynamic> images;
  final int initialIndex;
  GalleryPhoto({Key? key, required this.images, required this.initialIndex})
      : pageController = PageController(initialPage: initialIndex),
        super(key: key) {
    idx.value = initialIndex;
  }

  final PageController pageController; // = PageController(initialPage: 0);
  final idx = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider:
                      ExtendedNetworkImageProvider(images[index]['image']),
                  initialScale: PhotoViewComputedScale.contained * 0.95,
                  heroAttributes:
                      PhotoViewHeroAttributes(tag: images[index]['image']),
                );
              },
              itemCount: images.length,
              loadingBuilder: (context, event) => Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes!,
                  ),
                ),
              ),
              backgroundDecoration:
                  BoxDecoration(color: Get.theme.scaffoldBackgroundColor),
              pageController: pageController,
              onPageChanged: (int index) {
                idx.value = index;
              },
            ),
            Obx(
              () => Container(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Swipe Left-Right, Image ${idx.value + 1}",
                  style: const TextStyle(
                    //color: Colors.black87,
                    fontSize: 17.0,
                    decoration: null,
                  ),
                ),
              ),
            ),
            Positioned(
              top: Get.mediaQuery.padding.top,
              left: 10,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: InputContainer(
                  backgroundColor: Get.theme.backgroundColor,
                  radius: 35,
                  boxShadow: BoxShadow(
                    color: Colors.grey.withOpacity(.3),
                    offset: const Offset(1, 2),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Icon(BootstrapIcons.chevron_left,
                                    color: Get.theme.primaryColor, size: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
