import 'package:data_learns_247/core/utils/tab_bar_delegate.dart';
import 'package:data_learns_247/features/chatbot/ui/screens/chatbot_screen.dart';
import 'package:data_learns_247/shared_ui/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:html/parser.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/core/route/page_cubit.dart';
import 'package:data_learns_247/core/utils/error_dialog.dart';
import 'package:data_learns_247/features/course/cubit/detail_course_cubit.dart';
import 'package:data_learns_247/features/course/cubit/course_sections_cubit.dart';
import 'package:data_learns_247/features/course/data/models/detail_course_model.dart';
import 'package:data_learns_247/features/course/ui/widgets/placeholder/enrolled_detail_course_placeholder.dart';
import 'package:data_learns_247/features/lesson/ui/widgets/item/lesson_item.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';

class ListLessonsScreen extends StatefulWidget {
  final String courseId;

  const ListLessonsScreen({super.key, required this.courseId});

  @override
  State<ListLessonsScreen> createState() {
    return _ListLessonsScreenState();
  }
}

class _ListLessonsScreenState extends State<ListLessonsScreen> {

  @override
  void initState() {
    super.initState();
    if (widget.courseId.isNotEmpty) {
      context.read<DetailCourseCubit>().fetchDetailCourse(widget.courseId);
      context.read<CourseSectionsCubit>().clearSections();
    }
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
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) {
                context.read<PageCubit>().setPage(2);
                context.pushNamed(
                  RouteConstants.mainFrontPage,
                );
              }
            },
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: kWhiteColor,
                appBar: CustomAppBar(
                  showBackButton: true,
                  backAction: () {
                    context.read<PageCubit>().setPage(2);
                    context.pushNamed(
                      RouteConstants.mainFrontPage,
                    );
                  },
                ),
                body: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32
                        ),
                        child: detailCourseHeading(state.detailCourse),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: TabBarDelegate(
                        const TabBar(
                          indicatorColor: kGreenColor,
                          labelColor: kBlackColor,
                          tabs: [
                            Tab(text: "Lessons"),
                            Tab(text: "Chatbot"),
                          ],
                        ),
                      ),
                    ),
                  ],
                  body: TabBarView(
                    children: [
                      // Tab 1: Lessons
                      SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 32.0,
                        ),
                        child: Column(
                          children: [
                            if (state.detailCourse.sections != null)
                              courseSection(
                                state.detailCourse.sections!,
                                state.detailCourse.progress!,
                                state.detailCourse.chatbotId,
                              ),
                          ],
                        ),
                      ),
                      // Tab 2: Chatbot
                      state.detailCourse.chatbotId != null
                          ? ChatbotScreen(
                        chatbotId: state.detailCourse.chatbotId.toString(),
                        courseId: state.detailCourse.id.toString(),
                      ) : const Center(child: Text("Chatbot tidak tersedia")),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        if (state is DetailCourseError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ErrorDialog.showErrorDialog(context, state.message, () {
              Navigator.of(context).pop();
              context.read<DetailCourseCubit>().fetchDetailCourse(widget.courseId);
            });
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

  Widget courseSection(List<Sections> sections, String progress, String? chatbotId) {
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
                          queryParameters: {
                            'lessonId': lesson.lessonID.toString(),
                            'courseId': widget.courseId.toString(),
                            'chatbotId': chatbotId
                          }
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