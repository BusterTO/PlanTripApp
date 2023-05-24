import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:plantripapp/models/comment_model.dart';
import 'package:plantripapp/theme.dart';

class ItemComment extends StatelessWidget {
  final CommentModel? e;
  const ItemComment({Key? key, required this.e}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Get.theme.primaryColorLight,
                      child: e!.user!.image!.contains("http")
                          ? CircleAvatar(
                              radius: 14,
                              child: ClipOval(
                                child: ExtendedImage.network(
                                  e!.user!.image!,
                                  cache: true,
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                            )
                          : CircleAvatar(
                              radius: 14,
                              child: ClipOval(
                                child: ExtendedImage.asset(
                                  e!.user!.image!,
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                            ),
                    ),
                    spaceWidth5,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "@${e!.user!.username}",
                          style: textSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Get.theme.primaryColorLight,
                          ),
                        ),
                        Text(
                          "${e!.user!.fullname}",
                          style: textSmallGrey,
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    BootstrapIcons.hand_thumbs_up,
                    size: 18,
                    color: Get.theme.primaryColor,
                  ),
                )
              ],
            ),
            spaceHeight5,
            Text(MyTheme.formattedComment(e!.dateCreated!),
                style: textSmall.copyWith(
                    color: Get.theme.textTheme.caption!.color!)),
            RatingBar.builder(
              initialRating: e!.rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemSize: 12,
              itemCount: 5,
              itemPadding: const EdgeInsets.only(right: 4.0),
              itemBuilder: (context, _) => const Icon(
                BootstrapIcons.star_fill,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                debugPrint(rating.toString());
              },
            ),
            spaceHeight5,
            Text(
              e!.comment!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: textNormal,
            ),
          ],
        ),
      ),
    );
  }
}
