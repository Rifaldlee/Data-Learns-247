import 'package:flutter/material.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:html/parser.dart';
import 'package:toastification/toastification.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/route/page_cubit.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/core/theme/theme.dart';
import 'package:data_learns_247/core/tools/html_parser.dart';
import 'package:data_learns_247/core/utils/error_dialog.dart';
import 'package:data_learns_247/features/course/cubit/detail_course_cubit.dart';
import 'package:data_learns_247/features/course/cubit/enroll_course_cubit.dart';
import 'package:data_learns_247/features/course/data/models/detail_course_model.dart';
import 'package:data_learns_247/features/course/ui/widgets/course_button_widget.dart';
import 'package:data_learns_247/features/course/ui/widgets/placeholder/detail_course_placeholder.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';
import 'package:data_learns_247/shared_ui/widgets/custom_app_bar.dart';

class DetailCourseScreen extends StatefulWidget {
  final String courseId;
  const DetailCourseScreen({super.key, required this.courseId});

  @override
  State<DetailCourseScreen> createState() {
    return _DetailCourseScreen();
  }
}

class _DetailCourseScreen extends State<DetailCourseScreen> {
  bool isEnrolled = false;
  bool hasShownEnrollToast = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCourseData();
    });
  }

  void fetchCourseData() {
    if (widget.courseId.isNotEmpty) {
      context.read<DetailCourseCubit>().fetchDetailCourse(widget.courseId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailCourseCubit, DetailCourseState>(
      builder: (context, state) {
        if (state is DetailCourseLoading) {
          return const DetailCoursePlaceholder();
        }
        if (state is DetailCourseCompleted) {
          isEnrolled = state.detailCourse.isEnrolled ?? false;
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) {
                context.read<PageCubit>().setPage(1);
                context.pushNamed(
                  RouteConstants.mainFrontPage,
                );
              }
            },
            child: Scaffold(
              backgroundColor: kWhiteColor,
              appBar: CustomAppBar(
                showBackButton: true,
                backAction: () {
                  context.read<PageCubit>().setPage(1);
                  context.pushNamed(
                    RouteConstants.mainFrontPage,
                  );
                },
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ),
                        child: Column(
                          children: [
                            detailCourseHeading(state.detailCourse),
                            courseInformation(state.detailCourse),
                            courseContent(state.detailCourse.body!),
                            const SizedBox(height: 16),
                          ],
                        ),
                      )
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                    child: courseButton(isEnrolled)
                  )
                ],
              )
            ),
          );
        }
        if (state is DetailCourseError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ErrorDialog.showErrorDialog(context, state.message, () {
              Navigator.of(context).pop();
              fetchCourseData();
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
        const SizedBox(height: 12),
        courseAuthorInfo(
          course.fieldDisplayName ?? 'Unknown',
          course.created ?? '',
          course.userPicture!
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

  Widget courseInformation(Course course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Course Information',
            style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: kBlackColor, fontSize: 18)
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8)
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                course.courseCode?.isEmpty ?? true
                    ? const SizedBox.shrink()
                    : courseInformationItem(
                    'Course Code',
                    ' : ${course.courseCode.toString()}'
                ),
                const SizedBox(height: 8),
                course.courseType?.isEmpty ?? true
                    ? const SizedBox.shrink()
                    : courseInformationItem(
                  'Course Type',
                  ' : ${course.courseType.toString()}'
                ),
                const SizedBox(height: 8),
                course.duration?.isEmpty ?? true
                    ? const SizedBox.shrink()
                    : courseInformationItem(
                  'Duration',
                  ' : ${course.duration.toString()}'
                ),
                const SizedBox(height: 8),
                course.difficulty?.isEmpty ?? true
                    ? const SizedBox.shrink()
                    : courseInformationItem(
                  'Skill Level',
                  ' : ${course.difficulty.toString()}'
                ),
                const SizedBox(height: 8),
                course.courseFormat?.isEmpty ?? true
                    ? const SizedBox.shrink()
                    : courseInformationItem(
                  'Course Format',
                  ' : ${course.courseFormat.toString()}'
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget courseInformationItem(String title, String content) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: bold
            )
          )
        ),
        Expanded(
          flex: 2,
          child: Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge
          )
        )
      ],
    );
  }

  Widget courseContent(String content) {
    final document = parse(content);
    var elements = document.querySelectorAll('h1,h2,h3,p,ul,ol,figure,figcaption,code');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: elements.where((e) => e.text.trim().isNotEmpty)
        .map((e) => HtmlContentParser.parseHtml(
        element: e,
        context: context
      )).whereType<Widget>().toList(),
    );
  }

  Widget courseButton(bool isEnrolled) {
    return BlocConsumer<EnrollCourseCubit, EnrollCourseState>(
      listener: (context, state) {
        if (state is EnrollCourseCompleted && !hasShownEnrollToast) {
          hasShownEnrollToast = true;
          context.read<DetailCourseCubit>().updateEnrollment(true);

          toastification.show(
            context: context,
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored,
            direction: TextDirection.ltr,
            alignment: Alignment.topCenter,
            closeButtonShowType: CloseButtonShowType.always,
            showIcon: true,
            dragToClose: true,
            autoCloseDuration: const Duration(seconds: 3),
            title: const Text('Enroll berhasil'),
            icon: const Icon(Icons.check_circle_outline),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16
            ),
            borderRadius: BorderRadius.circular(12),
          );
        } else if (state is EnrollCourseError && !hasShownEnrollToast) {
          hasShownEnrollToast = true;

          toastification.show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored,
            direction: TextDirection.ltr,
            alignment: Alignment.topCenter,
            closeButtonShowType: CloseButtonShowType.always,
            showIcon: true,
            dragToClose: true,
            autoCloseDuration: const Duration(seconds: 5),
            title: const Text('Enroll gagal'),
            description: RichText(text: TextSpan(text: state.message)),
            icon: const Icon(Icons.cancel_outlined),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16
            ),
            borderRadius: BorderRadius.circular(12),
          );
        }
      },
      builder: (context, state) {
        if (state is EnrollCourseInitial) {
          hasShownEnrollToast = false;
        }
        if (state is EnrollCourseLoading) {
          return Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: const LinearGradient(
                  colors: [kBlueColor, kGreenColor]
              ),
            ),
            child: const Center(
              heightFactor: 42,
              widthFactor: 42,
              child:  CircularProgressIndicator(
                color: kWhiteColor,
                backgroundColor: kWhiteColor,
              ),
            ),
          );
        }
        return BlocBuilder<DetailCourseCubit, DetailCourseState>(
          builder: (context, state) {
            if (state is DetailCourseCompleted) {
              return CourseButtonWidget(
                isEnrolled: state.isEnrolled,
                id: widget.courseId,
              );
            }
            return const SizedBox();
          },
        );
      }
    );
  }
}