import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/search/cubit/search_cubit.dart';
import 'package:data_learns_247/features/search/data/models/search_model.dart';
import 'package:data_learns_247/shared_ui/screens/empty_screen.dart';
import 'package:data_learns_247/features/search/ui/widgets/item/article_result_item.dart';
import 'package:data_learns_247/features/search/ui/widgets/item/course_result_item.dart';
import 'package:data_learns_247/features/search/ui/widgets/placeholder/search_result_placeholder.dart';
import 'package:data_learns_247/shared_ui/widgets/custom_search_bar.dart';

class SearchResultScreen extends StatefulWidget {
  final String query;
  const SearchResultScreen({super.key, required this.query});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final TextEditingController controller = TextEditingController();
  final unescape = HtmlUnescape();
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    controller.text = widget.query;
    fetchResult(widget.query);
  }

  void fetchResult(String query) {
    final searchCubit = context.read<SearchCubit>();
    searchCubit.fetchSearchResult(query);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kWhiteColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Scaffold(
          backgroundColor: kWhiteColor,
          body: Column(
            children: [
              searchAppBar(),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state is SearchLoading) {
                      return const SearchResultPlaceHolder();
                    } else if (state is SearchCompleted) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              if (selectedFilter == 'All') ...[
                                resultArticle(state.searchResult!),
                                resultCourse(state.searchResult!),
                              ] else if (selectedFilter == 'Article') ...[
                                resultArticle(state.searchResult!),
                              ] else if (selectedFilter == 'Course') ...[
                                resultCourse(state.searchResult!),
                              ],
                            ],
                          ),
                        ),
                      );
                    } else if (state is SearchEmpty) {
                      return const EmptyScreen(
                        title: 'Oops! Pencarian tidak ditemukan',
                        description: 'Sepertinya tidak ada artikel atau pembelajaran yang sesuai. Coba gunakan kata kunci yang berbeda atau perluas pencarian Anda',
                      );
                    } else if (state is SearchError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget resultArticle(SearchResult searchResult) {
    return Column(
      children: searchResult.contents!.map((Contents contents) {
        return ArticleResultItem(
          contents: contents,
          onTap: () {
            context.pushNamed(
              RouteConstants.detailArticle,
              pathParameters: {
                'id': contents.id?.toString() ?? '0',
                'has_video': (contents.hasVideo ?? false).toString(),
              }
            );
          }
        );
      }).toList(),
    );
  }

  Widget resultCourse(SearchResult searchResult) {
    return Column(
      children: searchResult.courses!.map((Courses courses) {
        return CourseResultItem(
          courses: courses,
          onTap: () {
            context.pushNamed(
              RouteConstants.detailCourse,
              pathParameters: {
                'id': courses.id?.toString() ?? '0'
              }
            );
          }
        );
      }).toList(),
    );
  }

  Widget searchAppBar() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: 8,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_backspace, size: 32),
            onPressed: () {
              context.pop();
            },
          ),
          Expanded(
            child: CustomSearchBar(
              controller: controller,
              clear: () {
                controller.clear();
              },
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  fetchResult(query);
                }
              },
            ),
          ),
          popupMenu()
        ],
      ),
    );
  }

  Widget popupMenu() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: PopupMenuButton<String>(
        color: kWhiteColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedFilter,
                  style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: kBlackColor)
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, size: 20),
            ],
          ),
        ),
        onSelected: (String value) {
          setState(() {
            selectedFilter = value;
          });
          if (controller.text.isNotEmpty) {
            fetchResult(controller.text);
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'All',
            child: Text('All'),
          ),
          const PopupMenuItem<String>(
            value: 'Article',
            child: Text('Article'),
          ),
          const PopupMenuItem<String>(
            value: 'Course',
            child: Text('Course'),
          ),
        ],
      ),
    );
  }
}