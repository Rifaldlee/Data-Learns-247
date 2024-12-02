import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:html/parser.dart';
import 'package:go_router/go_router.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/core/tools/html_parser.dart';
import 'package:data_learns_247/core/tools/pdf_extractor.dart';
import 'package:data_learns_247/core/tools/youtube_extractor.dart';
import 'package:data_learns_247/features/lesson/cubit/finish_lesson_cubit.dart';
import 'package:data_learns_247/features/lesson/cubit/lesson_cubit.dart';
import 'package:data_learns_247/features/lesson/data/models/lesson_model.dart';
import 'package:data_learns_247/features/lesson/ui/widgets/finish_lesson_button_widget.dart';
import 'package:data_learns_247/features/lesson/ui/widgets/item/section_item.dart';
import 'package:data_learns_247/features/lesson/ui/widgets/item/section_item_drawer.dart';
import 'package:data_learns_247/features/course/cubit/course_sections_cubit.dart';
import 'package:data_learns_247/features/course/data/models/detail_course_model.dart';
import 'package:data_learns_247/shared_ui/widgets/error_dialog.dart';

class LessonScreen extends StatefulWidget {
  final String id;
  final String courseId;

  const LessonScreen({super.key, required this.id, required this.courseId});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  List<Sections>? sections;
  bool isComplete = false;
  YoutubePlayerController? ytController;
  bool isFullScreen = false;
  bool isSeeking = false;
  bool wasPlayingBeforeTransition = false;
  double? lastPlaybackPosition;

  @override
  void initState() {
    super.initState();
    context.read<LessonCubit>().fetchLesson(widget.id);
  }

  @override
  void dispose() {
    ytController?.removeListener(youtubeControllerListener);
    ytController?.dispose();
    super.dispose();
  }

  void showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        message: message,
        onClose: () {
          Navigator.of(context).pop();
        },
      ),
      barrierDismissible: false,
    );
  }

  void initializeYoutubeController(String content) {
    final ytId = YoutubeExtractor.extract(content: content, attribute: 'src');
    if (ytId.isEmpty) {
      showErrorDialog("Invalid YouTube video ID");
      return;
    }

    if (ytController != null && ytController!.initialVideoId != ytId) {
      ytController!.load(ytId);
    }

    ytController ??= YoutubePlayerController(
      initialVideoId: ytId.toString(),
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        enableCaption: true,
        controlsVisibleAtStart: true,
      ),
    );
    ytController!.addListener(youtubeControllerListener);
  }

  void youtubeControllerListener() {
    if (!mounted || ytController == null) return;
    if (!isSeeking && ytController!.value.isReady && lastPlaybackPosition != null) {
      isSeeking = true;
      ytController!.seekTo(Duration(seconds: lastPlaybackPosition!.toInt()));
      if (wasPlayingBeforeTransition) {
        ytController!.play();
      }
      lastPlaybackPosition = null;
      isSeeking = false;
    }
  }

  void onEnterFullScreen() {
    if (ytController != null) {
      wasPlayingBeforeTransition = ytController!.value.isPlaying;
      lastPlaybackPosition = ytController!.value.position.inSeconds.toDouble();
    }
    setState(() {
      isFullScreen = true;
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (wasPlayingBeforeTransition && ytController != null) {
        ytController!.play();
      }
    });
  }

  void onExitFullScreen() {
    if (ytController != null) {
      wasPlayingBeforeTransition = ytController!.value.isPlaying;
      lastPlaybackPosition = ytController!.value.position.inSeconds.toDouble();
    }
    setState(() {
      isFullScreen = false;
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (wasPlayingBeforeTransition && ytController != null) {
        ytController!.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonCubit, LessonState>(
      builder: (context, state) {
        if (state is LessonLoading) {
          return Container(
            color: kWhiteColor,
            child: const Center(
              child: CircularProgressIndicator(
                color: kGreenColor,
                backgroundColor: kWhiteColor,
              )
            ),
          );
        } else if (state is LessonCompleted) {
          final titleDoc = parse(state.lesson.title!);
          var title = titleDoc.querySelector('a')?.text;
          isComplete = state.lesson.isComplete ?? false;
          return PopScope(
            canPop: true,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) {
                context.pushNamed(
                  RouteConstants.listLessons,
                  pathParameters: {
                    'id': widget.courseId.toString(),
                  },
                );
              }
            },
            child: Scaffold(
              backgroundColor: isFullScreen ? kBlackColor : kWhiteColor,
              appBar: isFullScreen ? null : AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.keyboard_backspace, size: 32),
                  onPressed: () {
                    context.pushNamed(
                      RouteConstants.listLessons,
                      pathParameters: {
                        'id': widget.courseId.toString(),
                      },
                    );
                  }
                ),
              ),
              endDrawer: Drawer(
                child: BlocBuilder<CourseSectionsCubit, CourseSectionsState>(
                  builder: (context, state) {
                    if (state is CourseSectionsCompleted) {
                      return Container(
                        color: kWhiteColor,
                        child: SingleChildScrollView(
                          child: courseSectionDrawer(state.sections, state.progress),
                        ),
                      );
                    }
                    return const Text('No sections available');
                  },
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: buildLessonContent(
                      state.lesson.body!,
                      state.lesson.lessonType!,
                      title!,
                      isComplete
                    )
                  ),
                  if (!isFullScreen) lessonBottomNavBar(state.lesson)
                ],
              )
            ),
          );
        } else if (state is LessonError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showErrorDialog(state.message);
          });
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget buildLessonContent(String content, String type, String title, bool isComplete) {
    switch (type.toLowerCase()) {
      case 'youtube':
        return buildYoutubeLesson(content, title, isComplete);
      case 'pdf':
        return buildPdfLesson(content, title, isComplete);
      case 'article':
        return SingleChildScrollView(child: buildArticleLesson(content, title, isComplete));
      default:
        return const Center(child: Text('Unsupported lesson type'));
    }
  }

  Widget buildYoutubeLesson(String content, String title, bool isComplete) {
    if (ytController == null) {
      initializeYoutubeController(content);
    }

    return SafeArea(
      child: isFullScreen ? Center(
        child: FittedBox(
          fit: BoxFit.fill,
          child: youtubePlayer(ytController!, isComplete),
        ),
      ) : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          youtubePlayer(ytController!, isComplete),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                finishLessonButton(isComplete, 'youtube'),
              ],
            ),
          ),
          BlocBuilder<CourseSectionsCubit, CourseSectionsState>(
            builder: (context, state) {
              if (state is CourseSectionsCompleted) {
                return courseSection(state.sections);
              }
              return const Text('No sections available');
            },
          )
        ],
      ),
    );
  }

  Widget buildPdfLesson(String content, String title, bool isComplete) {
    final pdfUrl = PDFExtractor.extract(content: content);

    return SafeArea(
      child: isFullScreen ? PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            onExitFullScreen();
          }
        },
        child: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: const PDF(
                  swipeHorizontal: true,
                  enableSwipe: true
                ).cachedFromUrl(
                  pdfUrl,
                  errorWidget: (error) => Center(child: Text(error.toString())),
                )
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: SafeArea(
                child: GestureDetector(
                  onTap: onExitFullScreen,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.fullscreen_exit,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                )
              )
            ),
          ]
        ),
      ): Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: const PDF(
                  swipeHorizontal: true,
                  enableSwipe: true,
                ).cachedFromUrl(
                  pdfUrl,
                  placeholder: (progress) => Center(child: Text('$progress %')),
                  errorWidget: (error) => Center(child: Text(error.toString())),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: SafeArea(
                  child: GestureDetector(
                    onTap: onEnterFullScreen,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.fullscreen,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  )
                )
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                finishLessonButton(isComplete, 'pdf'),
              ],
            ),
          ),
          BlocBuilder<CourseSectionsCubit, CourseSectionsState>(
            builder: (context, state) {
              if (state is CourseSectionsCompleted) {
                return courseSection(state.sections);
              }
              return const Text('No sections available');
            },
          )
        ],
      ),
    );
  }

  Widget buildArticleLesson(String content, String title, bool isComplete) {
    final document = parse(content);
    var elements = document.querySelectorAll('h1,h2,h3,p,ul,ol,figure,figcaption,code');

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: elements.map((e) {
                return HtmlContentParser.parseHtml(element: e, context: context);
              }).whereType<Widget>().toList(),
            ),
          ),
          finishLessonButton(isComplete, 'article')
        ],
      ),
    );
  }

  Widget youtubePlayer(YoutubePlayerController controller, bool isComplete) {
    return SafeArea(
      child: YoutubePlayerBuilder(
          onEnterFullScreen: onEnterFullScreen,
          onExitFullScreen: onExitFullScreen,
          player:  YoutubePlayer(
            controller: ytController!,
            showVideoProgressIndicator: true,
            onEnded: (_) {
              if (!isComplete) {
                context.read<FinishLessonCubit>().finishLesson(widget.id);
              }
            },
            progressColors: const ProgressBarColors(
              playedColor: kGreenColor,
              handleColor: kGreenColor,
            ),
          ),
          builder: (context, player) => player
      ),
    );
  }

  Widget courseSection(List<Sections> sections) {
    int getLessonIndex(int sectionIndex, int lessonIndex) {
      int totalPreviousLessons = 0;
      for (int i = 0; i < sectionIndex; i++) {
        totalPreviousLessons += sections[i].lessons?.length ?? 0;
      }
      return totalPreviousLessons + lessonIndex + 1;
    }

    return Expanded(
      child: Container(
        color: kWhiteColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sections.asMap().entries.map((sectionEntry) {
                final section = sectionEntry.value;
                final sectionIndex = sectionEntry.key + 1;
                bool isExpanded = section.lessons?.any(
                  (lesson) => lesson.lessonID.toString() == widget.id,
                ) ?? false;

                return SectionItem(
                  section: section,
                  courseId: widget.courseId,
                  sectionIndex: sectionIndex,
                  isExpanded: isExpanded,
                  getLessonIndex: getLessonIndex,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget courseSectionDrawer(List<Sections> sections, String progress) {
    return Container(
      color: kWhiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24
            ),
            child: Text(
              "Daftar Modul",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: kBlackColor,
              ),
            ),
          ),
          // Progress Bar
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 8
            ),
            color: Colors.grey.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearPercentIndicator(
                  percent: double.tryParse(progress)! / 100,
                  progressColor: kGreenColor,
                  barRadius: const Radius.circular(8),
                  backgroundColor: Colors.grey[300],
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 8, 0, 0),
                  child: Text(
                    '$progress% Selesai',
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...sections.map((section) {
            bool isExpanded = section.lessons?.any(
              (lesson) => lesson.lessonID.toString() == widget.id
            ) ?? false;
            return SectionItemDrawer(
              section: section,
              courseId: widget.courseId,
              isExpanded: isExpanded
            );
          }),
        ],
      ),
    );
  }

  Widget lessonBottomNavBar(Lesson lesson) {
    final titleDoc = parse(lesson.title!);
    var title = titleDoc.querySelector('a')?.text;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 32.0,
      ),
      color: kWhiteColor,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (lesson.previousLesson != 0) {
                context.pushNamed(
                  RouteConstants.lessonScreen,
                  pathParameters: {
                    'id': widget.courseId.toString(),
                    'lessonId': lesson.previousLesson.toString(),
                  }
                );
              }
            },
            child: Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: lesson.previousLesson != 0 ? kGreenColor : kDarkGreyColor
                )
              ),
              child: Icon(
                Icons.chevron_left,
                color: lesson.previousLesson != 0 ? kGreenColor : kDarkGreyColor
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title!,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (lesson.nextLesson != 0)
            GestureDetector(
              onTap: () {
                if (!lesson.isComplete!) {
                  context.read<FinishLessonCubit>().finishLesson(widget.id);
                }
                context.pushNamed(
                  RouteConstants.lessonScreen,
                  pathParameters: {
                    'id': widget.courseId.toString(),
                    'lessonId': lesson.nextLesson.toString(),
                  }
                );
              },
              child: Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: kGreenColor
                  )
                ),
                child: const Icon(
                  Icons.chevron_right,
                  color: kGreenColor,
                ),
              ),
            ),
          if (lesson.nextLesson == 0)
            const Text('finish')
        ],
      ),
    );
  }

  Widget finishLessonButton(bool isComplete, String type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: BlocConsumer<FinishLessonCubit, FinishLessonState>(
        listener: (context, state) {
          if (state is FinishLessonCompleted) {
            context.read<LessonCubit>().updateCompleteStatus(true);
          }
        },
        builder: (context, state) {
          if (state is FinishLessonLoading) {
            return Container(
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: kBlueColor,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: kWhiteColor,
                ),
              ),
            );
          }
          return BlocBuilder<LessonCubit, LessonState>(
            builder: (context, state) {
              if (state is LessonCompleted) {
                return FinishLessonButtonWidget(
                  isComplete: state.isComplete,
                  id: widget.id,
                  type: type,
                );
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }
}