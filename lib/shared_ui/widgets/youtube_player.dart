import 'package:data_learns_247/core/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatelessWidget {
  final YoutubePlayerController controller;
  final Function()? onEnterFullScreen;
  final Function()? onExitFullScreen;
  final Function()? onEnded;

  const YoutubePlayerWidget({
    super.key,
    required this.controller,
    this.onEnterFullScreen,
    this.onExitFullScreen,
    this.onEnded,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: YoutubePlayerBuilder(
        onEnterFullScreen: onEnterFullScreen,
        onExitFullScreen: onExitFullScreen,
        player: YoutubePlayer(
          controller: controller,
          showVideoProgressIndicator: true,
          onEnded: (_) => onEnded?.call(),
          progressColors: const ProgressBarColors(
            playedColor: kGreenColor,
            handleColor: kGreenColor,
          ),
        ),
        builder: (context, player) => player,
      ),
    );
  }
}