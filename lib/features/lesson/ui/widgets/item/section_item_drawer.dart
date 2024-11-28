import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/core/theme/theme.dart';
import 'package:data_learns_247/features/course/data/models/detail_course_model.dart';
import 'package:data_learns_247/features/lesson/ui/widgets/item/section_child_item_drawer.dart';
import 'package:flutter/material.dart';

class SectionItemDrawer extends StatelessWidget {
  final Sections section;
  final String courseId;
  final bool isExpanded;

  const SectionItemDrawer({
    super.key,
    required this.section,
    required this.courseId,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent
      ),
      child: ExpansionTile(
        initiallyExpanded: isExpanded,
        controlAffinity: ListTileControlAffinity.leading,
        backgroundColor: kWhiteColor,
        collapsedBackgroundColor: kWhiteColor,
        iconColor: kBlackColor,
        collapsedIconColor: kBlackColor,
        title: Row(
          children: [
            Expanded(
              child: Text(
                section.sectionTitle ?? '',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: bold
                ),
              ),
            ),
            if (section.lessons?.every((lesson) => lesson.isComplete == true) ?? false)
              const Icon(
                Icons.check_circle,
                color: kGreenColor
              ),
          ],
        ),
        children: section.lessons?.map((lesson) {
          return SectionChildItemDrawer(
            lessons: lesson,
            courseId: courseId
          );
        }).toList() ?? [],
      ),
    );
  }
}