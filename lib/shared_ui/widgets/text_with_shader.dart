import 'package:flutter/material.dart';
import 'package:data_learns_247/core/theme/color.dart';

class TextWithShader extends StatelessWidget {
  final String text;
  final TextStyle textStyle;

  const TextWithShader({super.key, required this.text, required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) => const LinearGradient(
          colors: [kBlueColor, kGreenColor],
          stops: [0.35, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)
          .createShader(bounds),
      child: Text(text, style: textStyle),
    );
  }
}