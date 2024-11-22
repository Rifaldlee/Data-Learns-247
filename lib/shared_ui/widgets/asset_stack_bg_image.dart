import 'package:flutter/material.dart';

class AssetStackBgImage extends StatelessWidget {
  final String assetImgDir;
  final double height;
  final double width;
  final BoxFit fit;

  const AssetStackBgImage({
    super.key,
    required this.assetImgDir,
    required this.height,
    this.width = double.infinity,
    this.fit = BoxFit.cover
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(assetImgDir), fit: fit)),
    );
  }
}
