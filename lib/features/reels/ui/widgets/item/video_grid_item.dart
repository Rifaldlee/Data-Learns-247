import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoGridItem extends StatefulWidget {
  final String videoUrl;

  const VideoGridItem({super.key, required this.videoUrl});

  @override
  State<VideoGridItem> createState() {
    return _VideoGridItemState();
  }
}

class _VideoGridItemState extends State<VideoGridItem> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller)
        )
      ),
    );
  }
}