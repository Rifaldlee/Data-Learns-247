import 'package:data_learns_247/core/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final String? videoUrl;
  final String title;
  final String authorName;
  final String authorPicture;

  const VideoWidget({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.authorName,
    required this.authorPicture
  });

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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 12
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(widget.authorPicture),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        widget.authorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: kWhiteColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: kWhiteColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}