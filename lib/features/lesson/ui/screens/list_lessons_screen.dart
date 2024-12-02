import 'package:data_learns_247/core/route/page_cubit.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:html/parser.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/course/cubit/detail_course_cubit.dart';
import 'package:data_learns_247/features/course/cubit/course_sections_cubit.dart';
import 'package:data_learns_247/features/course/data/models/detail_course_model.dart';
import 'package:data_learns_247/features/course/ui/widgets/placeholder/enrolled_detail_course_placeholder.dart';
import 'package:data_learns_247/features/lesson/ui/widgets/item/lesson_item.dart';
import 'package:data_learns_247/shared_ui/widgets/error_dialog.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';

class ListLessonsScreen extends StatefulWidget {
  final String id;

  const ListLessonsScreen({super.key, required this.id});

  @override
  State<ListLessonsScreen> createState() {
    return _ListLessonsScreenState();
  }
}

class _ListLessonsScreenState extends State<ListLessonsScreen> {

  @override
  void initState() {
    super.initState();
    if (widget.id.isNotEmpty) {
      context.read<DetailCourseCubit>().fetchDetailCourse(widget.id);
      context.read<CourseSectionsCubit>().clearSections();
    }
  }

  void showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        message: message,
        onClose: () {
          Navigator.of(context).pop();
          context.read<DetailCourseCubit>().fetchDetailCourse(widget.id);
        },
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailCourseCubit, DetailCourseState>(
      builder: (context, state) {
        if (state is DetailCourseLoading) {
          return const EnrolledDetailCoursePlaceholder();
        }
        if (state is DetailCourseCompleted) {
          return PopScope(
            canPop: true,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) {
                context.read<PageCubit>().setPage(2);
                context.pushNamed(
                  RouteConstants.mainFrontPage,
                );
              }
            },
            child: Scaffold(
              backgroundColor: kWhiteColor,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.keyboard_backspace, size: 32),
                  onPressed: () {
                    context.read<PageCubit>().setPage(2);
                    context.pushNamed(
                      RouteConstants.mainFrontPage,
                    );
                  }
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 32.0,
                        ),
                        child: Column(
                          children: [
                            detailCourseHeading(state.detailCourse),
                            const SizedBox(height: 16),
                            if (state.detailCourse.sections != null)
                              courseSection(
                                state.detailCourse.sections!,
                                state.detailCourse.progress!
                              ),
                          ],
                        ),
                      )
                    ),
                  ),
                ],
              )
            ),
          );
        }
        if (state is DetailCourseError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showErrorDialog(state.message);
          });
        }
        return const Center(child: Text('Unknown state'));
      }
    );
  }

  Widget detailCourseHeading(Course course) {
    final titleDoc = parse(course.title!);
    var title = titleDoc.querySelector('a')?.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        courseImage(course.fieldImage!),
        const SizedBox(height: 12),
        courseTitle(title ?? 'No Title'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            Expanded(
              child: courseAuthorInfo(
                course.fieldDisplayName ?? 'Unknown',
                course.created ?? '',
                course.userPicture!
              ),
            ),
            CircularPercentIndicator(
              radius: 36,
              lineWidth: 8,
              percent: course.progress!.toDouble() / 100,
              progressColor: kGreenColor,
              center: Text(
                '${course.progress}%',
                style: Theme.of(context).textTheme.bodyLarge
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget courseImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: FastCachedImage(
        url: imageUrl,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, progress) {
          return const RectangleShimmerSizedBox(
            height: 200,
            width: double.infinity
          );
        }
      ),
    );
  }

  Widget courseTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget courseAuthorInfo(String authorName, String date, String photoUrl) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(photoUrl),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              authorName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              date,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget courseSection(List<Sections> sections, String progress) {
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
              if (section.lessons != null && section.lessons!.isNotEmpty)
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: section.lessons!.map((lesson) {
                    return LessonsItem(
                      lessons: lesson,
                      onTap: () {
                        context.read<CourseSectionsCubit>().setSections(
                          sections: sections,
                          progress: progress,
                        );
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
}