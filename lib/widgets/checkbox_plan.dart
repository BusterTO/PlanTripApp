import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantripapp/models/myplan_model.dart';

class CheckBoxPlan extends StatelessWidget {
  final MyPlanModel model;
  final Function(bool checked) callback;
  CheckBoxPlan({Key? key, required this.model, required this.callback})
      : super(key: key) {
    isChecked.value = model.isSelected!;
  }

  final isChecked = false.obs;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(65),
          color: Get.theme.backgroundColor,
        ),
        child: Checkbox(
          onChanged: (b) {
            isChecked.value = b!;
            callback(b);
          },
          value: isChecked.value,
        ),
      ),
    );
  }
}
