import 'package:flutter/material.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';

class ProfileScreenPlaceholder extends StatelessWidget {
  const ProfileScreenPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Column(
        children: [
          const RectangleShimmerSizedBox(height: 50, width: double.infinity),
          const SizedBox(height: 16),
          profileHeaderPlaceholder(),
          const SizedBox(height: 18),
          personalInfoPlaceholder(),
          const SizedBox(height: 18),
          appInfoPlaceholder(),
          const Spacer(),
          logoutButtonPlaceholder(),
        ],
      ),
    );
  }

  Widget profileHeaderPlaceholder() {
    return SizedBox(
      width: double.infinity,
        child: Row(
          children: [
            const CircularShimmerSizedBox(height: 72, width: 72),
            const SizedBox(width: 12),
            twoRowPlaceholder()
          ],
        ),
    );
  }

  Widget personalInfoPlaceholder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RectangleShimmerSizedBox(height: 40, width: double.infinity),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              profileItemPlaceholder(),
              const SizedBox(height: 12),
              profileItemPlaceholder(),
              const SizedBox(height: 12),
              profileItemPlaceholder()
            ],
          ),
        )
      ],
    );
  }

  Widget appInfoPlaceholder() {
    return Column(
      children: [
        const RectangleShimmerSizedBox(height: 40, width: double.infinity),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: profileItemPlaceholder(),
        ),
      ],
    );
  }

  Widget logoutButtonPlaceholder() {
    return const Row(
      children: [
        CircularShimmerSizedBox(height: 48, width: 48),
        SizedBox(width: 24),
        Expanded(
          child: RectangleShimmerSizedBox(height: 48, width: double.infinity)
        )
      ],
    );
  }

  Widget profileItemPlaceholder() {
    return Row(
      children: [
        const CircularShimmerSizedBox(height: 48, width: 48),
        const SizedBox(width: 24),
        twoRowPlaceholder()
      ],
    );
  }

  Widget twoRowPlaceholder() {
    return const Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RectangleShimmerSizedBox(height: 30, width: double.infinity),
          SizedBox(height: 4),
          RectangleShimmerSizedBox(height: 25, width: double.infinity)
        ],
      )
    );
  }
}