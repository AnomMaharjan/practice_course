import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q4me/app/modules/recording_list/controllers/recording_list_controller.dart';

class RecordListView extends StatelessWidget {
  final List<String> records;

  RecordListView({
    this.records,
  });

  final RecordingPlaybackController _recordingListController =
      Get.put(RecordingPlaybackController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecordingPlaybackController>(
        builder: (value) => records.isEmpty
            ? Center(child: Text('No records yet'))
            : ListView.builder(
                itemCount: records.length,
                shrinkWrap: true,
                // reverse: true,
                itemBuilder: (BuildContext context, int i) {
                  return ExpansionTile(
                    title: Text('New recoding ${records.length - i}'),
                    onExpansionChanged: ((newState) {
                      if (newState) {
                        _recordingListController.changeIndex(i);
                      }
                    }),
                    children: [
                      Container(
                        height: 100,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LinearProgressIndicator(
                              minHeight: 5,
                              backgroundColor: Colors.black,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.green),
                              value: _recordingListController.selectedIndex == i
                                  ? _recordingListController.completedPercentage
                                  : 0,
                            ),
                            IconButton(
                              icon: _recordingListController.selectedIndex == i
                                  ? _recordingListController.isPlaying.value ==
                                          true
                                      ? Icon(Icons.pause)
                                      : Icon(Icons.play_arrow)
                                  : Icon(Icons.play_arrow),
                              onPressed: () => _recordingListController.onPlay(
                                filePath: records.elementAt(i),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ));
  }
}
