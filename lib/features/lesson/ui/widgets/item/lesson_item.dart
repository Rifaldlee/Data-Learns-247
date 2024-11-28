import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/course/data/models/detail_course_model.dart';
import 'package:flutter/material.dart';

class LessonsItem extends StatelessWidget {
  final Lessons lessons;
  final Function() onTap;

  const LessonsItem({super.key, required this.lessons, required this.onTap});

  static const Map<String, IconData> lessonIcons = {
    'youtube': Icons.play_arrow,
    'pdf': Icons.picture_as_pdf,
    'article': Icons.article,
    'quiz': Icons.quiz,
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(
                lessonIcons[lessons.lessonType] ?? Icons.error,
                size: 20,
                color: kBlueColor
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                lessons.lessonTitle ?? '',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.check_circle,
              size: 20,
              color: lessons.isComplete == true
                  ? kGreenColor
                  : kLightGreyColor,
            ),
          ],
        ),
      ),
    );
  }
}
