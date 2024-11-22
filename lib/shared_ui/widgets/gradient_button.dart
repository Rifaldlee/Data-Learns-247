import 'package:flutter/material.dart';
import 'package:data_learns_247/core/theme/color.dart';

class GradientButton extends StatelessWidget {
  final String buttonTitle;
  final void Function() onPressed;
  final double width;
  final double height;
  final bool outlinedStyle;

  const GradientButton({
    super.key,
    required this.buttonTitle,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 55,
    this.outlinedStyle = false
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonContent() {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
          ),
          fixedSize: const Size(
            double.infinity,
            double.infinity
          )
        ),
        child: Text(
          buttonTitle,
          style: Theme.of(context).textTheme.labelLarge
            ?.copyWith(color: outlinedStyle ? kBlackColor: kWhiteColor)
        ),
      );
    }

    if (outlinedStyle) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kBlueColor, kGreenColor]
          ),
          borderRadius: BorderRadius.circular(5)
        ),
        child: Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: kWhiteColor
          ),
          child: buttonContent()
        )
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: const LinearGradient(
            colors: [kBlueColor, kGreenColor]
        ),
      ),
      child: buttonContent()
    );
  }
}
