import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/course/data/models/detail_course_model.dart';
import 'package:data_learns_247/features/lesson/ui/widgets/item/section_item_drawer.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CourseSectionDrawer extends StatelessWidget {
  final List<Sections> sections;
  final String progress;
  final String courseId;
  final String id;

  const CourseSectionDrawer({
    super.key,
    required this.sections,
    required this.progress,
    required this.courseId,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kWhiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24
            ),
            child: Text(
              "Daftar Modul",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: kBlackColor,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8
            ),
            color: Colors.grey.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearPercentIndicator(
                  percent: double.tryParse(progress)! / 100,
                  progressColor: kGreenColor,
                  barRadius: const Radius.circular(8),
                  backgroundColor: Colors.grey[300],
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 8, 0, 0),
                  child: Text(
                      '$progress% Selesai',
                      style: Theme.of(context).textTheme.bodyMedium
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...sections.map((section) {
            bool isExpanded = section.lessons?.any(
              (lesson) => lesson.lessonID.toString() == id
            ) ?? false;
            return SectionItemDrawer(
              section: section,
              courseId: courseId,
              isExpanded: isExpanded
            );
          }),
        ],
      ),
    );
  }
}