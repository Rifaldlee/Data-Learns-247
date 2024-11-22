import 'package:flutter/material.dart';
import 'package:data_learns_247/core/theme/color.dart';

class PersonalInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const PersonalInfoItem({
    super.key,
    required this.icon,
    required this.title,
    required this.content
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: kWhiteColor.withOpacity(0.5),
            child: Icon(
              icon,
              color: kBlueColor
            )
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: kBlackColor,
                    fontWeight: FontWeight.w500
                  )
                ),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: kBlackColor,
                    fontWeight: FontWeight.w400
                  )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}