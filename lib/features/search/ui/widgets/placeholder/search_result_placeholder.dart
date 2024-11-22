import 'package:flutter/material.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';

class SearchResultPlaceHolder extends StatelessWidget {
  const SearchResultPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          resultItemPlaceholder(),
          resultItemPlaceholder(),
          resultItemPlaceholder(),
          resultItemPlaceholder(),
          resultItemPlaceholder(),
          resultItemPlaceholder(),
          resultItemPlaceholder(),
          resultItemPlaceholder(),
          resultItemPlaceholder(),
          resultItemPlaceholder()
        ],
      ),
    );
  }

  Widget resultItemPlaceholder() {
    return Container(
      margin: const EdgeInsets.all(8),
      child: IntrinsicHeight(
        child: Row(
          children: [
            const RectangleShimmerSizedBox(
              height: 74,
              width: 94
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const RectangleShimmerSizedBox(
                    height: 36,
                    width: double.infinity
                  ),
                  Expanded(child: Container()),
                  const RectangleShimmerSizedBox(
                    height: 24,
                    width: 120
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}