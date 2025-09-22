import 'package:data_learns_247/core/route/page_cubit.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/features/reels/cubit/analytic_reels_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/core/utils/error_dialog.dart';
import 'package:data_learns_247/features/reels/cubit/detail_reels_cubit.dart';
import 'package:data_learns_247/features/reels/data/dto/analytic_reels_payload.dart';
import 'package:data_learns_247/features/reels/data/models/detail_reels_model.dart';
import 'package:data_learns_247/features/reels/ui/widgets/video_widget.dart';

class DetailReelsScreen extends StatefulWidget {
  final String id;

  const DetailReelsScreen({super.key, required this.id});

  @override
  State<DetailReelsScreen> createState() => _DetailReelsScreenState();
}

class _DetailReelsScreenState extends State<DetailReelsScreen> {
  bool showIcon = false;
  bool isTitleExpanded = false;
  bool isDescriptionExpanded = false;
  int currentIndex = 0;
  late PageController pageController;
  final Map<int, VideoPlayerController> _videoControllers = {};
  final Map<int, DateTime> _videoStartTimes = {};
  final Map<int, Duration> _videoWatchTimes = {};
  final Map<int, int> _videoPlayCounts = {};
  final Map<int, double> _videoDurations = {};

  List<DetailReels> _reelsList = [];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    context.read<DetailReelsCubit>().fetchDetailReels(widget.id);
  }

  @override
  void dispose() {
    stopVideo();
    pageController.dispose();
    super.dispose();
  }

  void stopVideo() {
    for (var controller in _videoControllers.values) {
      controller.pause();
      controller.removeListener(() {});
      controller.dispose();
      controller.setVolume(0.0);
    }
    _videoStartTimes.clear();
    _videoWatchTimes.clear();
    _videoPlayCounts.clear();
    _videoDurations.clear();
  }

  VideoPlayerController getController(int reelId, String videoUrl) {
    if (!_videoControllers.containsKey(reelId)) {
      final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      final previousPosition = _videoWatchTimes[reelId] ?? Duration.zero;

      controller.initialize().then((_) async {
        if (!mounted) return;

        controller.setLooping(true);
        await controller.seekTo(previousPosition);

        _videoControllers[reelId] = controller;
        _videoDurations[reelId] = controller.value.duration.inSeconds.toDouble();
        _videoWatchTimes[reelId] ??= Duration.zero;
        _videoPlayCounts[reelId] = (_videoPlayCounts[reelId] ?? 0) + 1;

        controller.play();
        startVideoTracking(reelId);

        setState(() {});
      }).catchError((e) {
        debugPrint("Error initializing video: $e");
      });

      controller.addListener(() {
        if (!controller.value.isPlaying) {
          stopVideoTracking(reelId);
          _videoWatchTimes[reelId] = controller.value.position;
        } else {
          startVideoTracking(reelId);
        }
      });

      _videoControllers[reelId] = controller;
    }

    return _videoControllers[reelId]!;
  }

  void initializeNextVideo(int currentIndex, List<DetailReels> reelsList) async {
    final nextIndex = currentIndex + 1;
    if (nextIndex >= reelsList.length) return;

    final nextReel = reelsList[nextIndex];
    final reelId = nextReel.id ?? 0;
    final nextVideoUrl = nextReel.videoUrl.toString();

    if (!_videoControllers.containsKey(reelId)) {
      final tempController = VideoPlayerController.networkUrl(Uri.parse(nextVideoUrl));

      try {
        await tempController.initialize();
        if (!mounted) return;

        await tempController.setLooping(true);
        await tempController.seekTo(Duration.zero);

        await tempController.play();
        await Future.delayed(const Duration(milliseconds: 300));
        await tempController.pause();

        _videoControllers[reelId] = tempController;
        _videoStartTimes[reelId] = DateTime.now();
        _videoDurations[reelId] = tempController.value.duration.inSeconds.toDouble();
        _videoWatchTimes[reelId] ??= Duration.zero;
        _videoPlayCounts[reelId] = (_videoPlayCounts[reelId] ?? 0) + 1;

      } catch (e) {
        debugPrint("Failed to preload next video: $e");
      }
    }
  }

  void getAnalyticData(DetailReels reel) {
    final now = DateTime.now();
    final reelId = reel.id ?? 0;

    final controller = _videoControllers[reelId];
    if (controller == null || !controller.value.isInitialized) return;

    if (_videoStartTimes.containsKey(reelId)) {
      final elapsed = now.difference(_videoStartTimes[reelId]!);
      _videoWatchTimes[reelId] = (_videoWatchTimes[reelId] ?? Duration.zero) + elapsed;
      _videoStartTimes.remove(reelId);
    }

    final watchTime = _videoWatchTimes[reelId]?.inSeconds ?? 0;
    final duration = _videoDurations[reelId]?.toInt() ?? 0;

    if (reelId != 0 && watchTime > 0) {
      final payload = AnalyticReelsPayload(
        reelId: reelId,
        watchTime: watchTime,
        duration: duration,
      );
      sendAnalyticData(payload);
    }
  }

  Future<void> sendAnalyticData(AnalyticReelsPayload data) async {
    try {
      context.read<AnalyticReelsCubit>().postAnalyticReels(data);
    } catch (e, stackTrace) {
      debugPrint('Error sending playback log: $e');
      debugPrint('StackTrace: $stackTrace');
    }
  }

  void startVideoTracking(int reelId) {
    if (_videoStartTimes[reelId] == null) {
      _videoStartTimes[reelId] = DateTime.now();
    }
  }

  void stopVideoTracking(int reelId) {
    if (_videoStartTimes.containsKey(reelId)) {
      final now = DateTime.now();
      final elapsed = now.difference(_videoStartTimes[reelId]!);
      _videoWatchTimes[reelId] = (_videoWatchTimes[reelId] ?? Duration.zero) + elapsed;
      _videoStartTimes.remove(reelId);
    }
  }

  void showErrorDialog(String message) {
    ErrorDialog.showErrorDialog(context, message, () {
      Navigator.of(context).pop();
      context.read<DetailReelsCubit>().fetchDetailReels(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kBlackColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if(!didPop) {
            stopVideo();
            context.read<PageCubit>().setPage(0);
            context.pushNamed(
              RouteConstants.mainFrontPage,
            );
            getAnalyticData(_reelsList[currentIndex]);
          }
        },
        child: Scaffold(
          backgroundColor: kBlackColor,
          body: BlocBuilder<DetailReelsCubit, DetailReelsState>(
            builder: (context, detailState) {
              if (detailState is DetailReelsLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: kGreenColor),
                );
              } else if (detailState is DetailReelsCompleted) {
                _reelsList = detailState.detailReels;

                return PageView.builder(
                  controller: pageController,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (index) {
                    final reel = _reelsList[currentIndex];
                    getAnalyticData(reel);

                    setState(() {
                      currentIndex = index;
                    });
                    final currentReel = _reelsList[index];
                    final controller = getController(currentReel.id ?? 0, currentReel.videoUrl.toString());
                    controller.play();

                    initializeNextVideo(index, _reelsList);
                  },
                  itemCount: _reelsList.length,
                  itemBuilder: (context, index) {
                    final reel = _reelsList[index];
                    return VideoWidget(
                      controller: getController(reel.id ?? 0, reel.videoUrl.toString()),
                      detailReels: reel,
                    );
                  },
                );
              } else if (detailState is DetailReelsError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showErrorDialog(detailState.message);
                });
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}