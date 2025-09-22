import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/course/data/models/detail_course_model.dart';
import 'package:data_learns_247/features/lesson/ui/widgets/item/section_item.dart';
import 'package:flutter/material.dart';

class CourseSectionWidget extends StatelessWidget {
  final List<Sections> sections;
  final String id;
  final String courseId;
  final String? chatbotId;

  const CourseSectionWidget({
    super.key,
    required this.sections,
    required this.id,
    required this.courseId,
    this.chatbotId,
  });

  int getLessonIndex(int sectionIndex, int lessonIndex) {
    int totalPreviousLessons = 0;
    for (int i = 0; i < sectionIndex; i++) {
      totalPreviousLessons += sections[i].lessons?.length ?? 0;
    }
    return totalPreviousLessons + lessonIndex + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kWhiteColor,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: sections.asMap().entries.map((sectionEntry) {
              final section = sectionEntry.value;
              final sectionIndex = sectionEntry.key + 1;
              bool isExpanded = section.lessons?.any(
                    (lesson) => lesson.lessonID.toString() == id,
              ) ?? false;

              return SectionItem(
                section: section,
                courseId: courseId,
                sectionIndex: sectionIndex,
                isExpanded: isExpanded,
                getLessonIndex: getLessonIndex,
                chatbotId: chatbotId,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}