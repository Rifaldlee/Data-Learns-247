import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/features/course/data/models/detail_course_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SectionChildItemDrawer extends StatelessWidget {
  final Lessons lessons;
  final String courseId;

  const SectionChildItemDrawer({
    super.key,
    required this.lessons,
    required this.courseId
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: -4),
      title: Row(
        children: [
          const SizedBox(width: 36),
          Icon(
            Icons.check_circle_outline,
            color: lessons.isComplete! ? Colors.green : Colors.grey,
            size: 18
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              lessons.lessonTitle!,
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
            'id': courseId,
            'lessonId': lessons.lessonID.toString(),
          },
        );
      },
    );
  }
}