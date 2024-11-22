import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:data_learns_247/core/theme/color.dart';

class RectangleShimmerSizedBox extends StatelessWidget {
  final double height;
  final double width;

  const RectangleShimmerSizedBox({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Shimmer.fromColors(
        baseColor: kShimmerBaseColor,
        highlightColor: kShimmerHighligtColor,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class CircularShimmerSizedBox extends StatelessWidget {
  final double height;
  final double width;

  const CircularShimmerSizedBox({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Shimmer.fromColors(
        baseColor: kShimmerBaseColor,
        highlightColor: kShimmerHighligtColor,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}