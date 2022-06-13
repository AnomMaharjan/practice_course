import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class RecordingPlaybackController extends GetxController {
  int totalDuration;
  int currentDuration;
  double completedPercentage = 0.0;
  var isPlaying = "not_playing".obs;

  int selectedIndex = -1;
  AudioPlayer audioPlayer = AudioPlayer();

  void changeIndex(int i) {
    selectedIndex = i;
    update();
  }

  Future<void> onPlay({String filePath}) async {
    if (isPlaying.value == "not_playing") {
      audioPlayer.play(filePath, isLocal: true);

      completedPercentage = 0.0;
      isPlaying.value = "playing";

      audioPlayer.onPlayerCompletion.listen((_) {
        isPlaying.value = "not_playing";
        completedPercentage = 0.0;
        update();
      });
      audioPlayer.onDurationChanged.listen((duration) {
        totalDuration = duration.inMicroseconds;
        update();
      });

      audioPlayer.onAudioPositionChanged.listen((duration) {
        currentDuration = duration.inMicroseconds;
        completedPercentage =
            currentDuration.toDouble() / totalDuration.toDouble();
        update();
      });
    }
  }

  Future<void> onReplay({String filePath}) async {
    onStop();
    isPlaying.value = "playing";
    await audioPlayer.play(filePath, isLocal: true);
    update();
  }

  Future<void> onStop() async {
    isPlaying.value = "not_playing";
    completedPercentage = 0.0;
    var result = audioPlayer.stop();
    print("k response ho yo $result");
    update();
    return result;
  }

  Future<void> onPause() async {
    isPlaying.value = "paused";
    await audioPlayer.pause();
    update();
  }

  Future<void> onResume() async {
    isPlaying.value = "playing";
    await audioPlayer.resume();
    update();
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
