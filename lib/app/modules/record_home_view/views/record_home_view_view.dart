import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q4me/app/modules/record_home_view/controllers/record_home_view_controller.dart';
import 'package:q4me/app/modules/recordaudio/views/recordaudio_view.dart';

class RecorderHomeView extends StatelessWidget {
  final RecordHomeViewController _recordHomeViewController =
      Get.put(RecordHomeViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder<RecordHomeViewController>(
      builder: (value) => RecorderView(
          onSaved: _recordHomeViewController.onRecordComplete,
          from: _recordHomeViewController.from),
    ));
  }
}
