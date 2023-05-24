import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantripapp/core/xcontroller.dart';

class InputContainer extends StatelessWidget {
  final Widget child;
  final double? radius;
  final Color? backgroundColor;
  final BoxShadow? boxShadow;
  final BoxBorder? boxBorder;
  final EdgeInsets? padding;
  const InputContainer({
    Key? key,
    required this.child,
    this.radius,
    this.backgroundColor,
    this.boxShadow,
    this.boxBorder,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final XController x = XController.to;
    return Obx(() => createBody(x.isDarkMode.value));
  }

  Widget createBody(final bool isDark) {
    //print("InputContainer createBody isDark: $isDark");

    return Container(
      padding: padding ?? const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(radius ?? 25),
        border: boxBorder,
        boxShadow: [
          boxShadow ??
              BoxShadow(
                color: Colors.grey.withOpacity(.3),
                blurRadius: 5.0,
                spreadRadius: 1,
                offset: const Offset(2, 5),
              )
        ],
      ),
      child: child,
    );
  }
}
