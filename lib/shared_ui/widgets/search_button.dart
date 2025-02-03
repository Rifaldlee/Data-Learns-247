import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchButton extends StatelessWidget {
  final int tabIndex;
  const SearchButton({super.key, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          RouteConstants.searchScreen,
          pathParameters: {'previous_tab_index': tabIndex.toString()}
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: kLightGreyColor,
            width: 1
          )
        ),
        child: const Row(
          children: [
            Icon(
              Icons.search,
              color: kLightGreyColor,
            ),
            Text(
              'search',
              style: TextStyle(
                color: kLightGreyColor
              ),
            ),
          ],
        ),
      ),
    );
  }
}