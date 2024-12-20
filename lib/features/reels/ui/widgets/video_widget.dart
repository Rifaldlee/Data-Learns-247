import 'package:data_learns_247/core/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final String? videoUrl;

  const VideoWidget({super.key, required this.videoUrl});

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController? controller;
  bool showIcon = false;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!))
      ..initialize().then((_) {
        setState(() {
          controller!.play();
          controller!.setLooping(true);
        });
      });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (controller!.value.isPlaying) {
            controller!.pause();
            showIcon = true;
          } else {
            controller!.play();
            showIcon = false;
          }
        });
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          controller!.value.isInitialized ? FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: controller!.value.size.width,
              height: controller!.value.size.height,
              child: VideoPlayer(controller!),
            ),
          ) : const Center(child: CircularProgressIndicator(color: kGreenColor)),
          if (showIcon)
            Center(
              child: Icon(
                Icons.play_arrow,
                size: 64,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
        ],
      ),
    );
  }
}