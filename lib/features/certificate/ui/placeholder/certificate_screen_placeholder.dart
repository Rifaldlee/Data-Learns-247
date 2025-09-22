import 'package:flutter/material.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';

class CertificateScreenPlaceholder extends StatelessWidget {
  const CertificateScreenPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 32,
        horizontal: 16
      ),
      child: Column(
        children: [
          certificateItemPlaceholder(),
          certificateItemPlaceholder(),
          certificateItemPlaceholder()
        ],
      ),
    );
  }

  Widget certificateItemPlaceholder() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      width: double.infinity,
      child: const Column(
        children: [
          RectangleShimmerSizedBox(
            height: 48,
            width: double.infinity
          ),
          RectangleShimmerSizedBox(
            height: 172,
            width: double.infinity
          )
        ],
      ),
    );
  }
}