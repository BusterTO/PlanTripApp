import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/models/user_model.dart';
import 'package:plantripapp/pages/searchable_user.dart';
import 'package:plantripapp/theme.dart';

class ItemUserCircle extends StatelessWidget {
  final List<UserModel> otherUser;
  final double radius;
  final int totalCounter;
  const ItemUserCircle(
      {Key? key,
      required this.otherUser,
      this.radius = 16,
      this.totalCounter = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final XController x = XController.to;
    // get for top 4 only
    List<UserModel> circleUser = [];
    if (otherUser.isNotEmpty) {
      int i = 0;
      for (var element in otherUser) {
        if (i < 4) {
          circleUser.add(element);
        }
        i++;
      }
    }

    return InkWell(
      onTap: () {
        debugPrint("clickeddd");
        try {
          if (otherUser.length == 1 && otherUser[0].id == x.thisUser.value.id) {
            return;
          }
          Get.to(SearchableList(otherUsers: otherUser));
        } catch (e) {
          debugPrint("errr ItemCircle ${e.toString()}");
        }
      },
      child: SizedBox(
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: circleUser.map((UserModel e) {
            final int idx = circleUser.indexOf(e);
            final double ratioRadius = radius + 3;
            final int maxSize = ratioRadius.floor() * circleUser.length;

            return Padding(
              padding: EdgeInsets.only(
                  left: double.parse("$maxSize") - (ratioRadius * idx)),
              child: CircleAvatar(
                radius: radius,
                backgroundColor: Get.theme.primaryColor,
                child: idx == 0 && circleUser.length > 3
                    ? CircleAvatar(
                        radius: radius - 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            "+",
                            style: textSmall.copyWith(
                                color: Colors.white, fontSize: radius * 1.20),
                          ),
                        ),
                      )
                    : e.image!.contains("http")
                        ? CircleAvatar(
                            radius: radius - 2,
                            child: ClipOval(
                              child: ExtendedImage.network(
                                e.image!,
                                cache: true,
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                              ),
                            ),
                          )
                        : CircleAvatar(
                            radius: radius - 2,
                            child: ClipOval(
                              child: ExtendedImage.asset(
                                e.image!,
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                              ),
                            ),
                          ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
