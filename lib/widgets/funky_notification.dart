import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FunkyNotification extends StatefulWidget {
  final String? text;
  final Color? backgroundColor;
  final int duration;
  const FunkyNotification(
      {Key? key, this.text, this.backgroundColor, this.duration = 2200})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => FunkyNotificationState();
}

class FunkyNotificationState extends State<FunkyNotification>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<Offset>? position;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));
    position = Tween<Offset>(begin: const Offset(0.0, -4.0), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: controller!, curve: Curves.bounceInOut));

    controller?.forward();

    Future.delayed(Duration(milliseconds: widget.duration), () {
      controller?.reverse();
    });
  }

  @override
  void dispose() {
    if (controller != null) controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: SlideTransition(
              position: position!,
              child: Container(
                decoration: ShapeDecoration(
                  color: widget.backgroundColor ?? Get.theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    widget.text ?? 'Notification!',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
