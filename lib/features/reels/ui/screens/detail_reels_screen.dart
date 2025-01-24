import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/reels/cubit/detail_reels_cubit.dart';
import 'package:data_learns_247/features/reels/cubit/list_reels_cubit.dart';
import 'package:data_learns_247/features/reels/ui/widgets/video_widget.dart';
import 'package:data_learns_247/shared_ui/widgets/error_dialog.dart';
import 'package:video_player/video_player.dart';

class DetailReelsScreen extends StatefulWidget {
  final String id;

  const DetailReelsScreen({super.key, required this.id});

  @override
  State<DetailReelsScreen> createState() => _DetailReelsScreenState();
}

class _DetailReelsScreenState extends State<DetailReelsScreen> {
  int currentIndex = 0;
  late PageController pageController;
  final Map<String, VideoPlayerController> _videoControllers = {};

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    context.read<DetailReelsCubit>().fetchDetailReels(widget.id);
    context.read<ListReelsCubit>().fetchListReels();
  }

  @override
  void dispose() {
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    pageController.dispose();
    super.dispose();
  }

  VideoPlayerController getController(String videoUrl) {
    if (!_videoControllers.containsKey(videoUrl)) {
      final tempController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      tempController.initialize().then((_) {
        setState(() {
          tempController.setLooping(true);
          tempController.play();
        });
      });
      _videoControllers[videoUrl] = tempController;
    }
    return _videoControllers[videoUrl]!;
  }

  void initializeNextVideo(int currentIndex, List<dynamic> reelsList) {
    final nextIndex = currentIndex + 1;
    if (nextIndex < reelsList.length) {
      final nextReel = reelsList[nextIndex];
      final nextVideoUrl = nextReel.videoUrl.toString();

      if (!_videoControllers.containsKey(nextVideoUrl)) {
        final tempController = VideoPlayerController.networkUrl(Uri.parse(nextVideoUrl));
        tempController.initialize().then((_) {
          tempController.setLooping(true);
          _videoControllers[nextVideoUrl] = tempController;
        });
      }
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        message: message,
        onClose: () {
          Navigator.of(context).pop();
          context.read<ListReelsCubit>().fetchListReels();
        },
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kBlackColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: kBlackColor,
        body: BlocBuilder<ListReelsCubit, ListReelsState>(
          builder: (context, listState) {
            return BlocBuilder<DetailReelsCubit, DetailReelsState>(
              builder: (context, detailState) {
                if (detailState is DetailReelsLoading || listState is ListReelsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: kGreenColor,
                    ),
                  );
                } else if (detailState is DetailReelsCompleted && listState is ListReelsCompleted) {
                  final detailVideo = detailState.detailReels;
                  final reelsList = listState.listReels
                    .where((item) => item.id.toString() != widget.id).toList();

                  return PageView.builder(
                    controller: pageController,
                    scrollDirection: Axis.vertical,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                      initializeNextVideo(index - 1, reelsList);
                    },
                    itemCount: reelsList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return VideoWidget(
                          controller: getController(detailVideo.videoUrl.toString()),
                          title: detailVideo.title!,
                          authorName: detailVideo.fieldDisplayName!,
                          authorPicture: detailVideo.userPicture!,
                        );
                      } else {
                        final reel = reelsList[index - 1];
                        return VideoWidget(
                          controller: getController(reel.videoUrl.toString()),
                          title: reel.title!,
                          authorName: reel.author!,
                          authorPicture: reel.authorPhoto!,
                        );
                      }
                    },
                  );
                } else if (detailState is DetailReelsError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showErrorDialog(detailState.message);
                  });
                } else if (listState is ListReelsError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showErrorDialog(listState.message);
                  });
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}