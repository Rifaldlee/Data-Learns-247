import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/lesson/cubit/finish_lesson_cubit.dart';
import 'package:data_learns_247/features/lesson/data/models/lesson_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:html/parser.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final Lesson lesson;
  final String type;
  final String lessonId;
  final String courseId;
  final String? chatbotId;

  const BottomNavigationBarWidget({
    super.key,
    required this.lesson,
    required this.type,
    required this.lessonId,
    required this.courseId,
    this.chatbotId
  });

  @override
  Widget build(BuildContext context) {
    final titleDoc = parse(lesson.title!);
    var title = titleDoc.querySelector('a')?.text;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
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
                    queryParameters: {
                      'courseId': courseId.toString(),
                      'lessonId': lesson.previousLesson.toString(),
                      'chatbotId': chatbotId
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
                if (!lesson.isComplete! && lesson.lessonType != 'youtube') {
                  context.read<FinishLessonCubit>().finishLesson(lessonId);
                }
                context.pushNamed(
                  RouteConstants.lessonScreen,
                    queryParameters: {
                      'courseId': courseId.toString(),
                      'lessonId': lesson.nextLesson.toString(),
                      'chatbotId': chatbotId
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
            GestureDetector(
              onTap: () {
                if (!lesson.isComplete!  && lesson.lessonType != 'youtube') {
                  context.read<FinishLessonCubit>().finishLesson(lessonId);
                  context.pushNamed(
                    RouteConstants.listLessons,
                    queryParameters: {
                      'courseId': courseId.toString(),
                    },
                  );
                }
                context.pushNamed(
                  RouteConstants.listLessons,
                  queryParameters: {
                    'courseId': courseId.toString(),
                  },
                );
              },
              child: const Text('finish')
            )
        ],
      ),
    );
  }
}