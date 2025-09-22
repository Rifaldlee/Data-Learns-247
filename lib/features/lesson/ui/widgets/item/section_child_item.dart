import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/features/course/data/models/detail_course_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SectionChildItem extends StatelessWidget {
  final int lessonIndex;
  final Lessons lessons;
  final String courseId;
  final String? chatbotId;

  const SectionChildItem({
    super.key,
    required this.lessonIndex,
    required this.lessons,
    required this.courseId,
    this.chatbotId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        visualDensity: const VisualDensity(vertical: -4),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Text(
          '$lessonIndex',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lessons.lessonTitle!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (lessons.lessonType != null)
              Text(
                lessons.lessonType!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
        trailing: Icon(
          Icons.check_circle_outline,
          color: lessons.isComplete! ? Colors.green : Colors.grey,
        ),
        onTap: () {
          context.pushNamed(
            RouteConstants.lessonScreen,
            queryParameters: {
              'courseId': courseId,
              'lessonId': lessons.lessonID.toString(),
              'chatbotId': chatbotId
            },
          );
        },
      ),
    );
  }
}