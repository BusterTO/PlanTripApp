import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:plantripapp/models/post_model.dart';
import 'package:plantripapp/theme.dart';

class ItemStat extends StatelessWidget {
  final PostModel e;
  final double? fontSize;
  const ItemStat({Key? key, required this.e, this.fontSize = 12})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Text(MyTheme.numberFormatDisplay(e.totalRating),
              style: textBold.copyWith(fontSize: fontSize)),
          spaceWidth5,
          Icon(BootstrapIcons.star, size: fontSize! - 1),
          spaceWidth15,
          Text(MyTheme.numberFormatDisplay(e.totalLike),
              style: textBold.copyWith(fontSize: fontSize)),
          spaceWidth5,
          Icon(BootstrapIcons.bookmark, size: fontSize! - 1),
          spaceWidth15,
          Text(MyTheme.numberFormatDisplay(e.totalShare),
              style: textBold.copyWith(fontSize: fontSize)),
          spaceWidth5,
          Icon(BootstrapIcons.share, size: fontSize! - 3)
        ],
      ),
    );
  }
}
