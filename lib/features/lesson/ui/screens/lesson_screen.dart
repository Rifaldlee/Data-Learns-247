import 'package:data_learns_247/features/course/cubit/course_sections_cubit.dart';
import 'package:data_learns_247/features/course/data/models/detail_course_model.dart';
import 'package:data_learns_247/features/course/ui/widgets/item/lesson_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:go_router/go_router.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/core/tools/html_parser.dart';
import 'package:data_learns_247/core/tools/pdf_extractor.dart';
import 'package:data_learns_247/core/tools/youtube_extractor.dart';
import 'package:data_learns_247/features/lesson/cubit/finish_lesson_cubit.dart';
import 'package:data_learns_247/features/lesson/cubit/lesson_cubit.dart';
import 'package:data_learns_247/features/lesson/data/models/lesson_model.dart';
import 'package:data_learns_247/shared_ui/widgets/error_dialog.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:html/parser.dart';

class LessonScreen extends StatefulWidget {
  final String id;
  final String courseId;

  const LessonScreen({super.key, required this.id, required this.courseId});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  YoutubePlayerController? _ytController;
  List<Sections>? sections;

  @override
  void initState() {
    super.initState();
    context.read<LessonCubit>().fetchLesson(widget.id);
  }

  @override
  void dispose() {
    _ytController?.dispose();
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonCubit, LessonState>(
      builder: (context, state) {
        if (state is LessonLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LessonCompleted) {
          return Scaffold(
            appBar: AppBar(
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
                    return SingleChildScrollView(
                      child: courseSection(state.sections),
                    );
                  }
                  return const Text('No sections available');
                },
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: buildLessonContent(state.lesson.body!, state.lesson.lessonType!)
                ),
                lessonBottomNavBar(state.lesson)
              ],
            )
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

  Widget buildLessonContent(String content, String type) {
    switch (type.toLowerCase()) {
      case 'youtube':
        return Column(
          children: [
            buildYoutubeLesson(content),
            Expanded(
              child: SingleChildScrollView(
                child: BlocBuilder<CourseSectionsCubit, CourseSectionsState>(
                  builder: (context, state) {
                    if (state is CourseSectionsCompleted) {
                      return courseSection(state.sections);
                    }
                    return const Text('No sections available');
                  },
                ),
              ),
            )
          ],
        );
      case 'pdf':
        return Column(
          children: [
            buildPdfLesson(content),
            Expanded(
              child: SingleChildScrollView(
                child: BlocBuilder<CourseSectionsCubit, CourseSectionsState>(
                  builder: (context, state) {
                    if (state is CourseSectionsCompleted) {
                      return courseSection(state.sections);
                    }
                    return const Text('No sections available');
                  },
                ),
              ),
            )
          ],
        );
      case 'article':
        return SingleChildScrollView(child: buildArticleLesson(content));
      default:
        return const Center(child: Text('Unsupported lesson type'));
    }
  }

  Widget buildYoutubeLesson(String content) {
    final ytId = YoutubeExtractor.extract(content: content, attribute: 'src');
    _ytController = YoutubePlayerController(initialVideoId: ytId);

    return YoutubePlayer(
      controller: _ytController!,
    );
  }

  Widget buildPdfLesson(String content) {
    final pdfUrl = PDFExtractor.extract(content: content);

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: const PDF(
        swipeHorizontal: true,
        enableSwipe: true,
      ).cachedFromUrl(
        pdfUrl,
        placeholder: (progress) => Center(child: Text('$progress %')),
        errorWidget: (error) => Center(child: Text(error.toString())),
      ),
    );

  }


  Widget buildArticleLesson(String content) {
    final document = parse(content);
    var elements = document.querySelectorAll('h1,h2,h3,p,ul,ol,figure,figcaption,code');
    return SingleChildScrollView(
      child: Column(
        children: elements.map((e) {
          return HtmlContentParser.parseHtml(element: e, context: context);
        }).whereType<Widget>().toList(),
      ),
    );
  }

  Widget courseSection(List<Sections> sections) {
    return Column(
      children: sections.map((section) {
        return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section.sectionTitle ?? '',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: section.lessons!.map((lesson) {
                  return LessonsItem(
                    lessons: lesson,
                    onTap: () {
                      context.pushNamed(
                        RouteConstants.lessonScreen,
                        pathParameters: {
                          'id': widget.id.toString(),
                          'lessonId': lesson.lessonID.toString(),
                        },
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }).toList(),
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
            child: Text(
              title!,
              textAlign: TextAlign.center,
            ),
          ),
          if (lesson.nextLesson != 0)
            GestureDetector(
            onTap: () {
              context.read<FinishLessonCubit>().finishLesson(widget.id);
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
}