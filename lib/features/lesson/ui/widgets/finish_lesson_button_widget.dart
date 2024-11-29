import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/lesson/cubit/finish_lesson_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinishLessonButtonWidget extends StatefulWidget {
  final bool isComplete;
  final String id;
  final String type;

  const FinishLessonButtonWidget({
    super.key,
    required this.isComplete,
    required this.id,
    required this.type
  });

  @override
  State<FinishLessonButtonWidget> createState() {
    return _FinishLessonButtonWidgetState();
  }
}

class _FinishLessonButtonWidgetState extends State<FinishLessonButtonWidget> {
  late bool isComplete;

  @override
  void initState() {
    super.initState();
    isComplete = widget.isComplete;
  }

  @override
  void didUpdateWidget(covariant FinishLessonButtonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isComplete != widget.isComplete) {
      setState(() {
        isComplete = widget.isComplete;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type != 'youtube') {
      if (isComplete) {
        return Container(
          width: double.infinity,
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.green.shade200,
          ),
          child: const Text(
            'Completed',
            style: TextStyle(
              color: kWhiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else {
        return SizedBox(
          width: double.infinity,
          height: 45,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: kBlueColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              fixedSize: const Size(
                  double.infinity,
                  double.infinity
              ),
            ),
            onPressed: () {
              context.read<FinishLessonCubit>().finishLesson(widget.id);
            },
            child: const Text(
              'Mark as Complete',
              style: TextStyle(color: kWhiteColor),
            ),
          ),
        );
      }
    } else {
      if (isComplete) {
        return Container(
          width: double.infinity,
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.green.shade200,
          ),
          child: const Text(
            'Completed',
            style: TextStyle(
              color: kWhiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else {
        return Container(
          width: double.infinity,
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue.shade200,
          ),
          child: const Text(
            'Mark as Complete',
            style: TextStyle(
              color: kWhiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }
    }
  }
}