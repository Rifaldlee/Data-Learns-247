import 'package:data_learns_247/core/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoGridItem extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoGridItem({super.key, required this.videoUrl, required this.title});

  @override
  State<VideoGridItem> createState() {
    return _VideoGridItemState();
  }
}

class _VideoGridItemState extends State<VideoGridItem>
    with AutomaticKeepAliveClientMixin {
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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.all(4),
              child: Text(
                widget.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: kWhiteColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}