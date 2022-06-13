import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:q4me/api/api_auth_provider.dart';
import 'package:q4me/app/routes/app_pages.dart';
import 'package:q4me/base_model/base_model.dart';
import 'package:q4me/constants/enum.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:q4me/icomoon_icons.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:q4me/utils/string.dart';

class RecordAudioController extends BaseController {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  var isPlayingPressed =
      false.obs; //variable to check if recorded audio is being played
  var microphonePressed =
      true.obs; //variable to check if microphone is being used
  var makeDoneButtonVisible =
      false.obs; //if recording is stopped done button is made visible
  IconData recordIcon = Icomoon.mic;
  String recordText =
      'Click To Start'; //recording text shown in record audio view
  RecordingState recordingState = RecordingState.UnSet; //audio recorder state
  Function onSaved;
  Recording current;
  String recordPath;
  List<double> recordingHeight = []; //frequency of audio being recorded
  List<double> recordPlayingHeight = []; //frequency of audio being played
  Recording record;
  var recordFinished = false.obs; //variable to check if record is finished
  int fromm;
  BuildContext contexts;

  // Recorder properties
  FlutterAudioRecorder2 audioRecorder;
  ScrollController scrollController = ScrollController();
  final SharedPreferencesManager sharedPreferencesManager =
      locator<SharedPreferencesManager>();

  @override
  void onInit() {
    super.onInit();
    FlutterAudioRecorder2.hasPermissions.then(
      (hasPermision) {
        if (hasPermision) {
          recordingState = RecordingState.Set;
          recordIcon = Icomoon.mic;
          recordText = 'Click to Start';
          update();
        }
      },
    );
  }

//update recording frequency list
  updateRecordHeightList({double height}) {
    listKey.currentState
        .insertItem(0, duration: const Duration(milliseconds: 50));
    recordingHeight = []
      ..add(height)
      ..addAll(recordingHeight);
    update();
  }

  assignFunction({Function function, int from, BuildContext context}) {
    onSaved = function;
    fromm = from;
    print("abcc $fromm");
    contexts = context;
  }

  Future<void> onRecordButtonPressed({BuildContext context}) async {
    switch (recordingState) {
      case RecordingState.Set:
        await _recordVoice(context: context);
        break;

      case RecordingState.Recording:
        await pauseRecording();
        print(microphonePressed.value);
        await _recordVoice(context: context);
        recordingState = RecordingState.paused;
        recordIcon = Icons.fiber_manual_record;
        recordText = 'continue recording';
        update();
        break;

      case RecordingState.paused:
        print(microphonePressed.value);
        await _resumeRecording();
        recordingState = RecordingState.Recording;
        recordText = 'recording';
        recordIcon = Icons.pause;
        update();
        break;

      case RecordingState.Stopped:
        await _recordVoice(context: context);
        break;

      case RecordingState.UnSet:
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please allow recording from settings.'),
        ));
        break;
    }
  }

  _initRecorder() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String filePath = appDirectory.path +
        '/' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.aac';

    audioRecorder =
        FlutterAudioRecorder2(filePath, audioFormat: AudioFormat.AAC);
    await audioRecorder.initialized;

    fetchAvgPower(audioRecorder);
    update();
  }

  fetchAvgPower(FlutterAudioRecorder2 audioRecorder2) async {
    var _current = await audioRecorder.current(channel: 0);
    current = _current;
    print("power meter ${current?.metering?.averagePower}");
    update();
  }

  _startRecording() async {
    await audioRecorder.start();
    var recording = await audioRecorder.current(channel: 0);
    recordFinished.value = false;
    current = recording;
    update();

    const tick = const Duration(milliseconds: 50);
    new Timer.periodic(tick, (Timer t) async {
      if (recordingState == RecordingState.paused) {
        t.cancel();
      } else if (recordingState == RecordingState.Stopped) {
        t.cancel();

        recordingHeight.clear();
      }

      var _current = await audioRecorder.current(channel: 0);

      current = _current;
      updateRecordHeightList(
          height: (current?.metering?.averagePower == -120
                  ? 122 + (current?.metering?.averagePower)
                  : current.metering.averagePower <= -39
                      ? 1
                      : 120 + 3 * (current?.metering?.averagePower)) /
              1.5);

      update();
    });
  }

  pauseRecording() async {
    await audioRecorder.pause();
    recordingState = RecordingState.paused;
  }

  Color dividerColor = GLOBAL_GREEN_COLOR;
  playWaveAnimation() async {
    const tick = const Duration(milliseconds: 50);
    new Timer.periodic(tick, (Timer t) async {
      for (int i; i <= recordingHeight.length; i++) {
        if (recordingHeight[i] == recordingHeight[i]) dividerColor = Colors.red;
      }
      if (current.metering.averagePower != null &&
          current?.metering?.averagePower != -120) {
        updateRecordHeightList(
            height: (current?.metering?.averagePower == -120
                    ? 122 + (current?.metering?.averagePower)
                    : current.metering.averagePower <= -39
                        ? 1
                        : 120 + 3 * (current?.metering?.averagePower)) /
                1.5);

        update();
      }
    });
  }

  _resumeRecording() async {
    await audioRecorder.resume();
    const tick = const Duration(milliseconds: 50);
    new Timer.periodic(tick, (Timer t) async {
      if (recordingState == RecordingState.paused) {
        t.cancel();
      } else if (recordingState == RecordingState.Stopped) {
        t.cancel();

        recordingHeight.clear();
      }

      var _current = await audioRecorder.current(channel: 0);

      current = _current;
      if (current.metering.averagePower != null &&
          current?.metering?.averagePower != -120) {
        updateRecordHeightList(
            height: (current?.metering?.averagePower == -120
                    ? 122 + (current?.metering?.averagePower)
                    : current.metering.averagePower <= -39
                        ? 1
                        : 120 + 3 * (current?.metering?.averagePower)) /
                1.5);

        update();
      }
    });
  }

  stopRecording() async {
    record = await audioRecorder.stop();
    recordPath = record.path;
    print("record ${recordPath}");
    recordingState = RecordingState.Stopped;
    recordIcon = Icomoon.mic;
    recordText = "";
    recordFinished.value = true;
    recordingHeight.clear();
    update();
    onSaved();
    if (record != null) {
      record = null;
      update();
    }
  }

  Future<void> _recordVoice({BuildContext context}) async {
    final hasPermission = await FlutterAudioRecorder2.hasPermissions;
    if (hasPermission ?? false) {
      await _initRecorder();
      await _startRecording();
      recordingState = RecordingState.Recording;
      recordIcon = Icons.pause;
      recordText = 'Recording';
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please allow recording from settings.'),
      ));
    }
    update();
  }

  ApiAuthProvider apiAuthProvider = ApiAuthProvider();

  void mapRecording({String fileName}) async {
    var formData = dio.FormData.fromMap({
      "upload_file": await dio.MultipartFile.fromFile(fileName),
    });
    sendFile(formData);
  }

  Future sendFile(myRecordingMap) async {
    setState(ViewState.Busy);

    bool success = await apiAuthProvider.uploadRecording(myRecordingMap);
    if (success) {
      Fluttertoast.showToast(
        msg: "Recording Uploaded",
      );
      if (fromm == 1 || fromm == 2) {
        Get.back();
      } else {
        Get.offAllNamed(Routes.HOMEPAGE);
      }
    }
    recordPath = null;
    isPlayingPressed.value = false;
    update();
    setState(ViewState.Retrieved);
  }

  @override
  void onClose() {
    recordingState = RecordingState.UnSet;
    recordingHeight.clear();
    super.onClose();
  }
}
