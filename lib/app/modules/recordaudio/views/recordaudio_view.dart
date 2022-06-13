import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:q4me/app/modules/recordaudio/controllers/recordaudio_controller.dart';
import 'package:q4me/app/modules/recording_list/controllers/recording_list_controller.dart';
import 'package:q4me/app/routes/app_pages.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:q4me/widgets/bottom_nav_bar.dart';
import 'package:q4me/widgets/slide_transition.dart';

class RecorderView extends StatelessWidget {
  final Function onSaved;
  final int from;

  RecorderView({this.onSaved, this.from});

  final RecordAudioController _recordAudioController =
      Get.put(RecordAudioController());
  final RecordingPlaybackController _recordingPlaybackController =
      Get.put(RecordingPlaybackController());

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    print(size.height);
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GetBuilder<RecordAudioController>(
              init: _recordAudioController.assignFunction(
                  function: onSaved, from: from, context: context),
              builder: (value) => Stack(
                children: [
                  //top card
                  size.height >= 926
                      ? Container(
                          height: size.height * 0.325,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: Color(0xff13253A),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(42),
                                bottomRight: Radius.circular(42)),
                          ),
                        )
                      : size.height > 684
                          ? Container(
                              height: size.height * 0.35,
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: Color(0xff13253A),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(42),
                                    bottomRight: Radius.circular(42)),
                              ),
                            )
                          : Container(
                              height: size.height * 0.36,
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: Color(0xff13253A),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(42),
                                    bottomRight: Radius.circular(42)),
                              ),
                            ),
                  Stack(
                    children: [
                      //text ("we suggest")

                      _recordAudioController //Checking if recording is completed or not to display the topcard title
                                          .microphonePressed
                                          .value ==
                                      true &&
                                  _recordAudioController.recordPath == null ||
                              _recordAudioController.recordingState ==
                                  RecordingState.UnSet
                          ? _recordAudioController.recordFinished.value !=
                                      true &&
                                  _recordAudioController.recordingState !=
                                      RecordingState.paused
                              ? Container(
                                  padding: size.height >= 926
                                      ? const EdgeInsets.only(top: 350.0)
                                      : size.height > 684
                                          ? const EdgeInsets.only(top: 320.0)
                                          : const EdgeInsets.only(top: 330.0),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "We Suggest:",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 50.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "\"Hi, it's " +
                                                    locator<SharedPreferencesManager>()
                                                        .getString("username")
                                                        .split("@")
                                                        .first +
                                                    "\"",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox()
                          : SizedBox(),
                      _recordAudioController.recordText == "Click to start"
                          ? Container(
                              padding: size.height >= 926
                                  ? const EdgeInsets.only(top: 350.0)
                                  : size.height > 684
                                      ? const EdgeInsets.only(top: 320.0)
                                      : const EdgeInsets.only(top: 330.0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "We Suggest:",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 50.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "\"Hi, it's " +
                                                locator<SharedPreferencesManager>()
                                                    .getString("username")
                                                    .split("@")
                                                    .first +
                                                "\"",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          from == 0
                              ? Align(
                                  alignment: Alignment.topLeft,
                                  child: TextButton(
                                    onPressed: () =>
                                        Get.offAllNamed(Routes.HOMEPAGE),
                                    child: Text(
                                      "SKIP",
                                      style: TextStyle(
                                        color: Color(0xff8BC34C),
                                      ),
                                    ),
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.topLeft,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(Icons.arrow_back_ios),
                                    color: Color(0xff8BC34C),
                                  ),
                                ),
                          Obx(
                            () =>
                                _recordAudioController //Checking if recording is completed or not to display the topcard title
                                            .microphonePressed
                                            .value ==
                                        true
                                    ? _recordAudioController
                                                .recordFinished.value !=
                                            true
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: size.height * 0.0125,
                                              ),
                                              Text(
                                                'Record Your \nOwn Intro',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.25,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                'This is what will play to the call\ncentre person who answers.',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Check Your\nSound Good',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.25,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                "It's important the cell centre \nperson knows who you are so \ncheck it's recorded nice and \nclear!",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: size.height * 0.05,
                                          ),
                                          Text(
                                            'Recording',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w700,
                                                height: 1.25,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'This is what will play to the \ncall centre person who answers.',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 21,
                                          ),
                                        ],
                                      ),
                          ),
                          //Condition to display audio waves
                          //Displays audio waves only when recording
                          Obx(
                            () => _recordAudioController.recordFinished.value ==
                                    false
                                ? Center(
                                    child: Container(
                                      height: size.height * 0.4,
                                      child: AnimatedList(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        key: _recordAudioController.listKey,
                                        reverse: true,
                                        initialItemCount: _recordAudioController
                                            .recordingHeight.length,
                                        itemBuilder: (
                                          context,
                                          index,
                                          animation,
                                        ) {
                                          return slideIt(
                                              animation,
                                              _recordAudioController
                                                  .recordingHeight[index],
                                              _recordAudioController
                                                  .dividerColor);
                                        },
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height: size.height * 0.05,
                                  ),
                          ),

                          Obx(
                            () => _recordAudioController.state == ViewState.Busy
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 68.0),
                                      child: CircularProgressIndicator(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //Checks if recording is finished or not to show audio player
                                      //If completed audio player is displayed
                                      _recordAudioController.recordPath ==
                                                  null ||
                                              _recordAudioController
                                                      .recordFinished.value ==
                                                  false
                                          ? SizedBox()
                                          : Container(
                                              height: size.height * 0.25,
                                              margin: EdgeInsets.only(top: 47),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GetBuilder<
                                                      RecordingPlaybackController>(
                                                    builder: (builder) =>
                                                        ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child:
                                                                LinearPercentIndicator(
                                                              animation: true,
                                                              barRadius: Radius
                                                                  .circular(10),
                                                              lineHeight: 8,
                                                              
                                                              restartAnimation:
                                                                  false,
                                                              animateFromLastPercent:
                                                                  true,
                                                              backgroundColor:
                                                                  Color(
                                                                      0xffdedede),
                                                              percent:
                                                                  _recordingPlaybackController
                                                                      .completedPercentage,
                                                              linearStrokeCap:
                                                                  // ignore: deprecated_member_use
                                                                  LinearStrokeCap
                                                                      .roundAll,
                                                              progressColor:
                                                                  Color(
                                                                      0xff8cc34c),
                                                            )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      //To display the recording text according to recording state
                                      _recordingPlaybackController
                                                  .isPlaying.value ==
                                              true
                                          ? SizedBox()
                                          : Center(
                                              child: Text(_recordAudioController
                                                  .recordText),
                                            ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          _recordAudioController
                                                      .isPlayingPressed.value ==
                                                  false
                                              ? SizedBox()
                                              : SizedBox(
                                                  width: 24,
                                                ),
                                          _recordAudioController.recordPath ==
                                                      null ||
                                                  _recordAudioController
                                                          .recordFinished
                                                          .value ==
                                                      false
                                              ? SizedBox()
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xffdddddd),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: IconButton(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        constraints:
                                                            BoxConstraints(),
                                                        icon:
                                                            Icon(Icons.replay),
                                                        onPressed: _recordingPlaybackController
                                                                        .isPlaying
                                                                        .value ==
                                                                    "paused" ||
                                                                _recordingPlaybackController
                                                                        .isPlaying
                                                                        .value ==
                                                                    "playing"
                                                            ? () {
                                                                _recordAudioController
                                                                    .playWaveAnimation();
                                                                _recordingPlaybackController
                                                                    .onReplay(
                                                                        filePath:
                                                                            _recordAudioController.recordPath);
                                                              }
                                                            : () {},
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                  ],
                                                ),
                                          _recordAudioController.recordPath ==
                                                      null ||
                                                  _recordAudioController
                                                          .recordFinished
                                                          .value ==
                                                      false
                                              ? SizedBox(
                                                  width: _recordAudioController
                                                              .makeDoneButtonVisible
                                                              .value ==
                                                          false
                                                      ? 0
                                                      : 38,
                                                )
                                              : Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xffdddddd),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: IconButton(
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        constraints:
                                                            BoxConstraints(),
                                                        icon: _recordingPlaybackController
                                                                    .isPlaying
                                                                    .value ==
                                                                "playing"
                                                            ? Icon(Icons
                                                                .pause_rounded)
                                                            : Icon(Icons
                                                                .play_arrow_rounded),
                                                        onPressed: () {
                                                          _recordingPlaybackController
                                                                      .isPlaying
                                                                      .value ==
                                                                  "playing"
                                                              ? _recordingPlaybackController
                                                                  .onPause()
                                                              : _recordingPlaybackController
                                                                          .isPlaying
                                                                          .value ==
                                                                      "paused"
                                                                  ? _recordingPlaybackController
                                                                      .onResume()
                                                                  : _recordingPlaybackController.onPlay(
                                                                      filePath:
                                                                          _recordAudioController
                                                                              .recordPath);
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                  ],
                                                ),
                                          MaterialButton(
                                            onPressed: () async {
                                              _recordAudioController
                                                      .microphonePressed.value =
                                                  !_recordAudioController
                                                      .microphonePressed.value;
                                              _recordAudioController
                                                  .makeDoneButtonVisible
                                                  .value = true;
                                              _recordAudioController
                                                          .recordPath ==
                                                      null
                                                  ? await _recordAudioController
                                                      .onRecordButtonPressed(
                                                          context: context)
                                                  : _recordingPlaybackController
                                                      .onPause()
                                                      .then((value) =>
                                                          _recordAudioController
                                                              .onRecordButtonPressed(
                                                                  context:
                                                                      context));
                                              _recordAudioController
                                                  .recordFinished.value = false;
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Container(
                                              width: 80,
                                              height: 80,
                                              margin: EdgeInsets.only(top: 6),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xff8BC34C),
                                              ),
                                              child: Icon(
                                                _recordAudioController
                                                    .recordIcon,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                          _recordAudioController.recordPath ==
                                                      null ||
                                                  _recordAudioController
                                                          .recordFinished
                                                          .value ==
                                                      false
                                              ? SizedBox()
                                              : Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 6,
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xffdddddd),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: IconButton(
                                                        constraints:
                                                            BoxConstraints(),
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        onPressed: () {
                                                          _recordingPlaybackController
                                                              .onStop();
                                                        },
                                                        icon: new Icon(
                                                          Icons.stop_rounded,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                  ],
                                                ),
                                          _recordAudioController
                                                      .makeDoneButtonVisible
                                                      .value ==
                                                  false
                                              ? SizedBox()
                                              : _recordAudioController
                                                              .recordPath ==
                                                          null ||
                                                      _recordAudioController
                                                              .recordFinished
                                                              .value ==
                                                          false
                                                  ? MaterialButton(
                                                      minWidth: 0,
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      onPressed: () async {
                                                        _recordAudioController
                                                            .recordFinished
                                                            .value = true;
                                                        _recordAudioController //Checking if recording is completed or not to display the topcard title
                                                            .microphonePressed
                                                            .value = true;
                                                        await _recordAudioController
                                                            .stopRecording();
                                                      },
                                                      child: Text("DONE",
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xff29394C),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                    )
                                                  : MaterialButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(22),
                                                      ),
                                                      minWidth: 0,
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      onPressed: () {
                                                        _recordAudioController
                                                            .mapRecording(
                                                                fileName:
                                                                    _recordAudioController
                                                                        .recordPath);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 9,
                                                          ),
                                                          Text(
                                                            "Save"
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color(
                                                                  0xff29394C),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 16,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                        ],
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: from == 0 ? null : BottomNavBar(from: 3),
    );
  }
}
