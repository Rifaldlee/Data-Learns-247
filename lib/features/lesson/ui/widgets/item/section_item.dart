import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/course/data/models/detail_course_model.dart';
import 'package:data_learns_247/features/lesson/ui/widgets/item/section_child_item.dart';
import 'package:flutter/material.dart';

class SectionItem extends StatelessWidget {
  final Sections section;
  final String courseId;
  final int sectionIndex;
  final bool isExpanded;
  final int Function(int, int) getLessonIndex;

  const SectionItem({
    super.key,
    required this.section,
    required this.courseId,
    required this.sectionIndex,
    required this.isExpanded,
    required this.getLessonIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        backgroundColor: kWhiteColor,
        initiallyExpanded: isExpanded,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Section $sectionIndex - ${section.sectionTitle ?? ''}',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        children: section.lessons?.asMap().entries.map((lessonEntry) {
          final lesson = lessonEntry.value;
          final lessonIndex = getLessonIndex(sectionIndex - 1, lessonEntry.key);
          return SectionChildItem(
            lessonIndex: lessonIndex,
            lessons: lesson,
            courseId: courseId,
          );
        }).toList() ?? [],
      ),
    );
  }
}
