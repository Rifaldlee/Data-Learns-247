import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/features/course/cubit/enroll_course_cubit.dart';
import 'package:data_learns_247/shared_ui/widgets/affirmation_dialog.dart';
import 'package:data_learns_247/shared_ui/widgets/gradient_button.dart';

class CourseButtonWidget extends StatefulWidget {
  final bool isEnrolled;
  final String id;

  const CourseButtonWidget({
    super.key,
    required this.isEnrolled,
    required this.id,
  });

  @override
  State<CourseButtonWidget> createState() {
    return _CourseButtonWidgetState();
  }
}

class _CourseButtonWidgetState extends State<CourseButtonWidget> {
  late bool isEnrolled;

  @override
  void initState() {
    super.initState();
    isEnrolled = widget.isEnrolled;
  }

  @override
  void didUpdateWidget(covariant CourseButtonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isEnrolled != widget.isEnrolled) {
      setState(() {
        isEnrolled = widget.isEnrolled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      buttonTitle: isEnrolled ? 'Go to course' : 'Enroll',
      onPressed: () {
        if (isEnrolled) {
          context.pushNamed(
            RouteConstants.listLessons,
            queryParameters: {
              'courseId': widget.id
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AffirmationDialog(
              message: 'Apakah anda ingin mendaftar kelas ini?',
              onProceed: () {
                context.read<EnrollCourseCubit>().enrollCourse(widget.id);
                context.pop();
                setState(() {
                  isEnrolled = true;
                });
              },
            ),
          );
        }
      },
    );
  }
}