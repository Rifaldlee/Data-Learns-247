import 'package:data_learns_247/core/tools/youtube_extractor.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerHelper {
  YoutubePlayerController? controller;
  bool isSeeking = false;
  bool wasPlayingBeforeTransition = false;
  double? lastPlaybackPosition;

  void initialize({
    required String content,
    required VoidCallback onError,
    required VoidCallback listener,
  }) {
    final ytId = YoutubeExtractor.extract(content: content, attribute: 'src');
    print("YT ID: $ytId");
    if (ytId.isEmpty) {
      onError();
      return;
    }

    if (controller != null && controller!.initialVideoId != ytId) {
      controller!.load(ytId);
    }

    controller ??= YoutubePlayerController(
      initialVideoId: ytId.toString(),
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        enableCaption: false,
        controlsVisibleAtStart: true,
      ),
    );

    controller!.addListener(listener);
  }

  void listener(VoidCallback playAfterSeek) {
    if (controller == null) return;
    if (!isSeeking && controller!.value.isReady && lastPlaybackPosition != null) {
      isSeeking = true;
      controller!.seekTo(Duration(seconds: lastPlaybackPosition!.toInt()));
      if (wasPlayingBeforeTransition) {
        playAfterSeek();
      }
      lastPlaybackPosition = null;
      isSeeking = false;
    }
  }

  void enterFullScreen({
    required VoidCallback onEnter,
  }) {
    if (controller != null) {
      wasPlayingBeforeTransition = controller!.value.isPlaying;
      lastPlaybackPosition = controller!.value.position.inSeconds.toDouble();
    }

    onEnter();

    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (wasPlayingBeforeTransition && controller != null) {
        controller!.play();
      }
    });
  }

  void exitFullScreen({
    required VoidCallback onExit,
  }) {
    if (controller != null) {
      wasPlayingBeforeTransition = controller!.value.isPlaying;
      lastPlaybackPosition = controller!.value.position.inSeconds.toDouble();
    }

    onExit();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (wasPlayingBeforeTransition && controller != null) {
        controller!.play();
      }
    });
  }

  void dispose(VoidCallback onDispose) {
    controller?.removeListener(onDispose);
    controller?.dispose();
  }
}