import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:html/parser.dart';
import 'package:go_router/go_router.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/core/theme/theme.dart';
import 'package:data_learns_247/core/tools/html_parser.dart';
import 'package:data_learns_247/core/tools/pdf_extractor.dart';
import 'package:data_learns_247/core/tools/youtube_extractor.dart';
import 'package:data_learns_247/features/lesson/cubit/finish_lesson_cubit.dart';
import 'package:data_learns_247/features/lesson/cubit/lesson_cubit.dart';
import 'package:data_learns_247/features/lesson/data/models/lesson_model.dart';
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
          final titleDoc = parse(state.lesson.title!);
          var title = titleDoc.querySelector('a')?.text;
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
                    title!
                  )
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

  Widget buildLessonContent(String content, String type, String title) {
    switch (type.toLowerCase()) {
      case 'youtube':
        return buildYoutubeLesson(content, title);
      case 'pdf':
        return buildPdfLesson(content, title);
      case 'article':
        return SingleChildScrollView(child: buildArticleLesson(content, title));
      default:
        return const Center(child: Text('Unsupported lesson type'));
    }
  }

  Widget buildYoutubeLesson(String content, String title) {
    final ytId = YoutubeExtractor.extract(content: content, attribute: 'src');
    _ytController = YoutubePlayerController(initialVideoId: ytId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        YoutubePlayer(
          controller: _ytController!,
          onEnded: (_) {
            context.read<FinishLessonCubit>().finishLesson(widget.id);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
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
    );
  }

  Widget buildPdfLesson(String content, String title) {
    final pdfUrl = PDFExtractor.extract(content: content);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
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
    );
  }

  Widget buildArticleLesson(String content, String title) {
    final document = parse(content);
    var elements = document.querySelectorAll('h1,h2,h3,p,ul,ol,figure,figcaption,code');

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 32.0,
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
        ],
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

                return Theme(
                  data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent
                  ),
                  child: ExpansionTile(
                    backgroundColor: kWhiteColor,
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Section $sectionIndex - ${section.sectionTitle ?? ''}',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 14,
                          fontWeight: bold,
                        ),
                      ),
                    ),
                    children: section.lessons?.asMap().entries.map((lessonEntry) {
                      final lesson = lessonEntry.value;
                      final lessonIndex = getLessonIndex(sectionEntry.key, lessonEntry.key);

                      return ListTile(
                        visualDensity: const VisualDensity(vertical: -4),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        leading: Text(
                          '$lessonIndex',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 14,
                            fontWeight: bold,
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lesson.lessonTitle!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontSize: 14,
                                fontWeight: bold,
                              ),
                            ),
                            if (lesson.lessonType != null)
                              Text(
                                lesson.lessonType!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.check_circle_outline,
                          color: lesson.isComplete! ? Colors.green : Colors.grey,
                        ),
                        onTap: () {
                          context.pushNamed(
                            RouteConstants.lessonScreen,
                            pathParameters: {
                              'id': widget.courseId.toString(),
                              'lessonId': lesson.lessonID.toString(),
                            },
                          );
                        },
                      );
                    }).toList() ?? [],
                  ),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
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
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
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
            return Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent
              ),
              child: ExpansionTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        section.sectionTitle ?? '',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 16,
                          fontWeight: bold
                        ),
                      ),
                    ),
                    if (section.lessons?.every((lesson) => lesson.isComplete == true) ?? false)
                      const Icon(
                        Icons.check_circle,
                        color: kGreenColor
                      ),
                  ],
                ),
                backgroundColor: kWhiteColor,
                collapsedBackgroundColor: kWhiteColor,
                iconColor: kBlackColor,
                collapsedIconColor: kBlackColor,
                children: section.lessons?.map((lesson) {
                  return ListTile(
                    visualDensity: const VisualDensity(vertical: -4),
                    title: Row(
                      children: [
                        const SizedBox(width: 36),
                        Icon(
                          Icons.check_circle_outline,
                          color: lesson.isComplete! ? Colors.green : Colors.grey,
                          size: 18
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            lesson.lessonTitle!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      context.pushNamed(
                        RouteConstants.lessonScreen,
                        pathParameters: {
                          'id': widget.courseId.toString(),
                          'lessonId': lesson.lessonID.toString(),
                        },
                      );
                    },
                  );
                }).toList() ?? [],
              ),
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
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
}