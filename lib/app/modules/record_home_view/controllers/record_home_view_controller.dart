import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:q4me/api/api_auth_provider.dart';
import 'package:q4me/base_model/base_model.dart';
import 'package:q4me/constants/enum.dart';
import 'package:path_provider/path_provider.dart';

class RecordHomeViewController extends BaseController {
  Directory appDirectory;
  List<String> records = [];
  ApiAuthProvider apiAuthProvider = ApiAuthProvider();
  int from;
  void mapRecording({String fileName}) async {
    var formData = dio.FormData.fromMap({
      // "file": await dio.MultipartFile.fromFile(compressedImage.path),
    });
    sendImage(formData);
  }

  Future sendImage(myRecordingMap) async {
    setState(ViewState.Busy);

    await apiAuthProvider.uploadRecording(myRecordingMap);

    setState(ViewState.Retrieved);
  }

  onRecordComplete() {
    records.clear();
    appDirectory.list().listen((onData) {
      if (onData.path.contains('.aac')) {
        if (records.length >= 1) {
          {
            records.removeAt(0);
            records.add(onData.path);
            update();
          }
        }
      }
      ;
    }).onDone(() {
      records.sort();
      records = records.reversed.toList();
      update();
    });
  }

  @override
  void onInit() {
    super.onInit();
    from = Get.arguments["from"];
    print("this is from: $from");
    getRecords();
  }

  void getRecords() {
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      appDirectory.list().listen((onData) {
        if (onData.path.contains('.aac')) records.add(onData.path);
      }).onDone(() {
        records = records.reversed.toList();
        update();
      });
    });
    update();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    appDirectory.delete();
    super.onClose();
  }
}
