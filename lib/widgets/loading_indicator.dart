/// Flutter code sample for LinearProgressIndicator

// This example shows a [LinearProgressIndicator] with a changing value.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// This is the stateful widget that the main application instantiates.
class LinearLoadingWidget extends StatefulWidget {
  const LinearLoadingWidget({Key key}) : super(key: key);

  @override
  State<LinearLoadingWidget> createState() => _LinearLoadingWidget();
}

/// This is the private State class that goes with MyStatefulWidget.
/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _LinearLoadingWidget extends State<LinearLoadingWidget>
    with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width / 4.5,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: LinearProgressIndicator(
          value: controller.value,
        ),
      ),
    );
  }
}
