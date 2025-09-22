import 'package:data_learns_247/core/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';

class AttemptDetailPlaceholder extends StatelessWidget {
  const AttemptDetailPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Transform.translate(
          offset: const Offset(16.0, 0.0),
          child: const RectangleShimmerSizedBox(height: 32, width: 32)
        ),
      ),
      backgroundColor: kWhiteColor,
      body: const Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
        child: Column(
          children: [
            CircularShimmerSizedBox(height: 144, width: 144),
            SizedBox(height: 16),
            RectangleShimmerSizedBox(height: 180, width: double.infinity),
            SizedBox(height: 12),
            RectangleShimmerSizedBox(height: 48, width: double.infinity),
            SizedBox(height: 4),
            RectangleShimmerSizedBox(height: 84, width: double.infinity),
            SizedBox(height: 4),
            RectangleShimmerSizedBox(height: 84, width: double.infinity),
            SizedBox(height: 4),
            RectangleShimmerSizedBox(height: 84, width: double.infinity),
          ],
        ),
      )
    );
  }
}