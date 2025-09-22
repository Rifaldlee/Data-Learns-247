import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/route/page_cubit.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/shared_ui/widgets/custom_search_bar.dart';

class SearchScreen extends StatefulWidget {
  final int previousTabIndex;
  const SearchScreen({super.key, required this.previousTabIndex});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kWhiteColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if(!didPop) {
            context.read<PageCubit>().setPage(widget.previousTabIndex);
            context.pushNamed(
              RouteConstants.mainFrontPage,
            );
          }
        },
        child: Scaffold(
          backgroundColor: kWhiteColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 32
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<PageCubit>().setPage(widget.previousTabIndex);
                    context.pushNamed(
                      RouteConstants.mainFrontPage,
                    );
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomSearchBar(
                    controller: controller,
                    clear: () {controller.clear();},
                    onSubmitted: (query) {
                      controller.clear();
                      if (query.isNotEmpty) {
                        GoRouter.of(context).goNamed(
                          RouteConstants.searchResult,
                          pathParameters: {
                            'query': query,
                            'initial_tab_index' : widget.previousTabIndex.toString(),
                            'previous_tab_index': widget.previousTabIndex.toString(),
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}