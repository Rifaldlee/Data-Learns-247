import 'package:data_learns_247/features/chatbot/ui/screens/chatbot_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:html/parser.dart';
import 'package:go_router/go_router.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/core/tools/html_parser.dart';
import 'package:data_learns_247/core/tools/pdf_extractor.dart';
import 'package:data_learns_247/core/tools/youtube_extractor.dart';
import 'package:data_learns_247/core/utils/error_dialog.dart';
import 'package:data_learns_247/features/lesson/cubit/finish_lesson_cubit.dart';
import 'package:data_learns_247/features/lesson/cubit/lesson_cubit.dart';
import 'package:data_learns_247/features/lesson/ui/widgets/finish_lesson_button_widget.dart';
import 'package:data_learns_247/features/lesson/ui/widgets/course_section_drawer_widget.dart';
import 'package:data_learns_247/features/lesson/ui/widgets/course_section_widget.dart';
import 'package:data_learns_247/features/lesson/ui/widgets/bottom_navigation_bar_widget.dart';
import 'package:data_learns_247/features/course/cubit/course_sections_cubit.dart';
import 'package:data_learns_247/features/course/data/models/detail_course_model.dart';
import 'package:data_learns_247/features/quiz/ui/screens/quiz_information_screen.dart';
import 'package:data_learns_247/shared_ui/widgets/custom_app_bar.dart';
import 'package:data_learns_247/shared_ui/widgets/youtube_player.dart';

class LessonScreen extends StatefulWidget {
  final String lessonId;
  final String courseId;
  final String? chatbotId;

  const LessonScreen({
    super.key,
    required this.lessonId,
    required this.courseId,
    this.chatbotId
  });

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
    context.read<LessonCubit>().fetchLesson(widget.lessonId);
  }

  @override
  void dispose() {
    ytController?.removeListener(youtubeControllerListener);
    ytController?.dispose();
    super.dispose();
  }

  void showErrorDialog(String message) {
    if (!mounted) return;
    ErrorDialog.showErrorDialog(context, message, () {
      Navigator.of(context).pop();
    });
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
        enableCaption: false,
        controlsVisibleAtStart: true,
      ),
    );
    ytController!.addListener(youtubeControllerListener);
  }

  void youtubeControllerListener() {
    if (!mounted || ytController == null) {
      ytController?.setVolume(0);
      return;
    }
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

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
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) {
                ytController?.setVolume(0);
                context.goNamed(
                  RouteConstants.listLessons,
                  queryParameters: {
                    'courseId': widget.courseId.toString(),
                  },
                );
              }
            },
            child: Scaffold(
              backgroundColor: isFullScreen ? kBlackColor : kWhiteColor,
              appBar: isFullScreen ? null : CustomAppBar(
                showBackButton: true,
                backAction: () {
                  ytController?.setVolume(0);
                  context.goNamed(
                    RouteConstants.listLessons,
                    queryParameters: {
                      'courseId': widget.courseId.toString(),
                    },
                  );
                },
                trailing: Builder(
                  builder: (context) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          child: const Icon(Icons.menu),
                        ),
                      ],
                    );
                  },
                ),
              ),
              endDrawer: Drawer(
                child: BlocBuilder<CourseSectionsCubit, CourseSectionsState>(
                  builder: (context, state) {
                    if (state is CourseSectionsCompleted) {
                      return Container(
                        color: kWhiteColor,
                        child: SingleChildScrollView(
                          child: CourseSectionDrawer(
                            sections: state.sections,
                            progress: state.progress,
                            courseId: widget.courseId,
                            id: widget.lessonId,
                            chatbotId: widget.chatbotId,
                          ),
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
                  if (!isFullScreen)
                    BottomNavigationBarWidget(
                      lesson: state.lesson,
                      type: state.lesson.lessonType.toString(),
                      lessonId: widget.lessonId,
                      courseId: widget.courseId,
                      chatbotId: widget.chatbotId,
                    )
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
        return buildArticleLesson(content, title, isComplete);
      case 'quiz':
        return QuizInformationScreen(
          quizId: content,
          courseId: widget.courseId,
          lessonId: widget.lessonId,
          chatbotId: widget.chatbotId,
        );
      default:
        return const Center(child: Text('Unsupported lesson type'));
    }
  }

  Widget buildYoutubeLesson(String content, String title, bool isComplete) {
    if (ytController == null) {
      initializeYoutubeController(content);
    }

    return SafeArea(
      child: isFullScreen ? PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            onExitFullScreen();
          }
        },
        child: Center(
          child: FittedBox(
            fit: BoxFit.fill,
            child: youtubePlayer(ytController!, isComplete),
          ),
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
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    indicatorColor: kGreenColor,
                    labelColor: kBlackColor,
                    tabs: [
                      Tab(text: "Lessons"),
                      Tab(text: "Chatbot"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        BlocBuilder<CourseSectionsCubit, CourseSectionsState>(
                          builder: (context, state) {
                            if (state is CourseSectionsCompleted) {
                              return CourseSectionWidget(
                                sections: state.sections,
                                id: widget.lessonId,
                                courseId: widget.courseId,
                                chatbotId: widget.chatbotId,
                              );
                            }
                            return const Text('No sections available');
                          },
                        ),
                        widget.chatbotId != null ? ChatbotScreen(
                          chatbotId: widget.chatbotId.toString(),
                          courseId: widget.courseId.toString(),
                        ) : const Center(child: Text("Chatbot tidak tersedia")),
                      ]
                    ),
                  ),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPdfLesson(String content, String title, bool isComplete) {
    final pdfUrl = PDFExtractor.extract(content: content);

    return SafeArea(
      child: isFullScreen ? PopScope(
        canPop: false,
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
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    indicatorColor: kGreenColor,
                    labelColor: kBlackColor,
                    tabs: [
                      Tab(text: "Lessons"),
                      Tab(text: "Chatbot"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        BlocBuilder<CourseSectionsCubit, CourseSectionsState>(
                          builder: (context, state) {
                            if (state is CourseSectionsCompleted) {
                              return CourseSectionWidget(
                                sections: state.sections,
                                id: widget.lessonId,
                                courseId: widget.courseId,
                                chatbotId: widget.chatbotId,
                              );
                            }
                            return const Text('No sections available');
                          },
                        ),
                        widget.chatbotId != null ? ChatbotScreen(
                          chatbotId: widget.chatbotId.toString(),
                          courseId: widget.courseId.toString(),
                        ) : const Center(child: Text("Chatbot tidak tersedia")),
                      ]
                    ),
                  ),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget buildArticleLesson(String content, String title, bool isComplete) {
    final document = parse(content);
    var elements = document.body?.children ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
      ),
      child: SingleChildScrollView(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: elements.map((e) {
                return HtmlContentParser.parseHtml(element: e, context: context);
              }).whereType<Widget>().toList(),
            ),
            finishLessonButton(isComplete, 'article')
          ],
        ),
      ),
    );
  }

  Widget youtubePlayer(YoutubePlayerController controller, bool isComplete) {
    return YoutubePlayerWidget(
      controller: controller,
      onEnterFullScreen: onEnterFullScreen,
      onExitFullScreen: onExitFullScreen,
      onEnded: () {
        if (!isComplete) {
          context.read<FinishLessonCubit>().finishLesson(widget.lessonId);
        }
      },
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
                  id: widget.lessonId,
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