import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantripapp/models/post_model.dart';
import 'package:plantripapp/pages/map_page.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/input_container.dart';

class RowMapLoc extends StatelessWidget {
  final PostModel e;
  const RowMapLoc({Key? key, required this.e}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InputContainer(
          backgroundColor: Get.theme.backgroundColor,
          boxShadow: BoxShadow(
            color: Colors.grey.withOpacity(.3),
            offset: const Offset(1, 2),
          ),
          radius: 5,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Get.to(MapPage(place: e.toJson()),
                    transition: Transition.cupertinoDialog);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    spaceWidth5,
                    Icon(BootstrapIcons.geo_alt,
                        color: Get.theme.primaryColor, size: 18),
                    spaceWidth10,
                    const Text("Location"),
                    spaceWidth5,
                  ],
                ),
              ),
            ),
          ),
        ),
        spaceWidth10,
        InputContainer(
          backgroundColor: Get.theme.backgroundColor,
          boxShadow: BoxShadow(
            color: Colors.grey.withOpacity(.3),
            offset: const Offset(1, 2),
          ),
          radius: 5,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Get.to(MapPage(place: e.toJson(), isRoute: true),
                    transition: Transition.cupertinoDialog);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    spaceWidth5,
                    Icon(BootstrapIcons.pin_map,
                        color: Get.theme.primaryColor, size: 18),
                    spaceWidth10,
                    const Text("Route"),
                    spaceWidth5,
                  ],
                ),
              ),
            ),
          ),
        ),
        //spaceWidth5,
      ],
    );
  }
}
