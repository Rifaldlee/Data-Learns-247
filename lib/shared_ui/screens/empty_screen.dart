import 'package:flutter/material.dart';
import 'package:data_learns_247/core/theme/color.dart';

class EmptyScreen extends StatelessWidget {
  final String title;
  final String description;

  const EmptyScreen({
    super.key,
    required this.title,
    required this.description
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Image(
            image: AssetImage("assets/img/img_ill_2.png")
          ),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(color: kBlackColor)
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16
          ),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: kBlackColor)
          ),
        )
      ],
    );
  }
}