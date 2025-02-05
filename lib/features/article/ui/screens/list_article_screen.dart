import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/core/theme/theme.dart';
import 'package:data_learns_247/core/utils/error_dialog.dart';
import 'package:data_learns_247/features/article/cubit/featured_articles_cubit.dart';
import 'package:data_learns_247/features/article/cubit/list_articles_cubit.dart';
import 'package:data_learns_247/features/article/cubit/random_article_cubit.dart';
import 'package:data_learns_247/features/article/cubit/recommended_articles_cubit.dart';
import 'package:data_learns_247/features/article/cubit/trending_articles_cubit.dart';
import 'package:data_learns_247/features/article/data/models/list_articles_model.dart';
import 'package:data_learns_247/features/article/ui/widgets/item/card_article_item.dart';
import 'package:data_learns_247/features/article/ui/widgets/item/clip_article_item.dart';
import 'package:data_learns_247/features/article/ui/widgets/item/simple_article_item.dart';
import 'package:data_learns_247/features/article/ui/widgets/placeholder/clip_article_item_placeholder.dart';
import 'package:data_learns_247/features/article/ui/widgets/placeholder/card_article_item_placeholder.dart';
import 'package:data_learns_247/features/article/ui/widgets/placeholder/simple_article_item_placeholder.dart';
import 'package:data_learns_247/features/reels/cubit/list_reels_cubit.dart';
import 'package:data_learns_247/features/reels/data/models/list_reels_model.dart';
import 'package:data_learns_247/features/reels/ui/widgets/item/video_grid_item.dart';
import 'package:data_learns_247/shared_ui/widgets/search_button.dart';

class ListArticlesScreen extends StatefulWidget {
  const ListArticlesScreen({super.key});

  @override
  State<ListArticlesScreen> createState() => _ListArticlesScreenState();
}

class _ListArticlesScreenState extends State<ListArticlesScreen> {
  VideoPlayerController? controller;
  bool listArticleError = false;
  bool isScrolled = true;
  List<ListReels>? shuffledReels;

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void fetchArticles() {
    context.read<ListArticlesCubit>().fetchListArticles();
    context.read<FeaturedArticlesCubit>().fetchFeaturedArticles();
    context.read<RecommendedArticlesCubit>().fetchRecommendedArticles();
    context.read<TrendingArticlesCubit>().fetchTrendingArticles();
    context.read<RandomArticleCubit>().fetchRandomArticle();
    context.read<ListReelsCubit>().fetchListReels();
  }

  void showErrorDialog(String message) {
    ErrorDialog.showErrorDialog(context, message, () {
      setState(() {
        listArticleError = false;
      });
      Navigator.of(context).pop();
      fetchArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: isScrolled ? Colors.transparent : kWhiteColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: kWhiteColor,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 180 + MediaQuery.of(context).viewPadding.top,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/img/hero-img.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            NotificationListener<ScrollUpdateNotification>(
              onNotification: (notif) {
                if (scrollController.position.pixels > 180.0) {
                  setState(() {
                    isScrolled = false;
                  });
                } else if (scrollController.position.pixels < 135.0) {
                  setState(() {
                    isScrolled = true;
                  });
                }
                return true;
              },
              child: LayoutBuilder(
                builder: (context, constraint) {
                  return ListView(
                    controller: scrollController,
                    padding: EdgeInsets.only(
                      top: 160 + MediaQuery.of(context).viewPadding.top,
                    ),
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: const BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                titleGroup('For you'),
                                const Spacer(),
                                const Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: SearchButton(tabIndex: 0),
                                  )
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            listArticleCard(),
                            featured(),
                            const SizedBox(height: 16),
                            clipArticle(),
                            trending(),
                            titleGroup('Shorts'),
                            reels(),
                            const SizedBox(height: 16),
                            recommended(),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget clipArticle() {
    return BlocBuilder<RandomArticleCubit, RandomArticleState>(
      builder: (context, state) {
        if (state is RandomArticleLoading) {
          return const ClipArticleItemPlaceholder();
        } else if (state is RandomArticleCompleted) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return ClipArticleItem(
                randomArticle: state.randomArticle,
                onTap: () {
                  context.pushNamed(
                    RouteConstants.detailArticle,
                    pathParameters: {
                      'id': state.randomArticle.id.toString(),
                      'has_video': (state.randomArticle.hasVideo ?? false).toString(),
                    }
                  );
                },
              );
            },
          );
        } else if (state is RandomArticleError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!listArticleError) {
              setState(() {
                listArticleError = true;
              });
              showErrorDialog(state.message);
            }
          });
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget listArticleCard() {
    return BlocBuilder<ListArticlesCubit, ListArticlesState>(
      builder: (context, state) {
        if (state is ListArticlesLoading) {
          return const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(16, 0, 0, 16),
            child: Row(
              children: [
                CardArticleItemPlaceholder(),
                CardArticleItemPlaceholder(),
              ],
            ),
          );
        } else if (state is ListArticlesCompleted) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: state.listArticles.map(
                (ListArticles listArticles) => CardArticleItem(
                  listArticles: listArticles,
                  onTap: () {
                    context.pushNamed(
                      RouteConstants.detailArticle,
                      pathParameters: {
                        'id': listArticles.id?.toString() ?? '0',
                        'has_video': (listArticles.hasVideo ?? false).toString(),
                      }
                    );
                  }
                ),
              ).toList(),
            )
          );
        } else if (state is ListArticlesError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!listArticleError) {
              setState(() {
                listArticleError = true;
              });
              showErrorDialog(state.message);
            }
          });
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget featured() {
    return BlocBuilder<FeaturedArticlesCubit, FeaturedArticlesState>(
      builder: (context, state) {
        if (state is FeaturedArticlesLoading) {
          return const SimpleArticleItemPlaceholder();
        } else if (state is FeaturedArticlesCompleted) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleGroup(state.listArticles[0].blockGroup.toString()),
              Column(
                children: state.listArticles.asMap().entries.map(
                  (entry) {
                    final listArticles = entry.value;
                    return Column(
                      children: [
                        SimpleArticleItem(
                          listArticles: listArticles,
                          onTap: () {
                            context.pushNamed(
                              RouteConstants.detailArticle,
                              pathParameters: {
                                'id': listArticles.id?.toString() ?? '0',
                                'has_video': (listArticles.hasVideo ?? false).toString(),
                              }
                            );
                          },
                        ),
                        if (entry.key != state.listArticles.length - 1)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: DottedDecoration(
                              linePosition: LinePosition.bottom,
                              strokeWidth: 2,
                            ),
                          )
                      ],
                    );
                  }
                ).toList()
              ),
            ],
          );
        } else if (state is FeaturedArticlesError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!listArticleError) {
              setState(() {
                listArticleError = true;
              });
              showErrorDialog(state.message);
            }
          });
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget recommended() {
    return BlocBuilder<RecommendedArticlesCubit, RecommendedArticlesState>(
      builder: (context, state) {
        if (state is RecommendedArticlesLoading) {
          return const SimpleArticleItemPlaceholder();
        } else if (state is RecommendedArticlesCompleted) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleGroup(state.listArticles[0].blockGroup.toString()),
              Column(
                children: state.listArticles.asMap().entries.map(
                  (entry) {
                    final listArticles = entry.value;
                    return Column(
                      children: [
                        SimpleArticleItem(
                          listArticles: listArticles,
                          onTap: () {
                            context.pushNamed(
                              RouteConstants.detailArticle,
                              pathParameters: {
                                'id': listArticles.id?.toString() ?? '0',
                                'has_video': (listArticles.hasVideo ?? false).toString(),
                              }
                            );
                          },
                        ),
                        if (entry.key != state.listArticles.length - 1)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: DottedDecoration(
                              linePosition: LinePosition.bottom,
                              strokeWidth: 2,
                            ),
                          )
                      ],
                    );
                  }
                ).toList()
              ),
            ],
          );
        } else if (state is RecommendedArticlesError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!listArticleError) {
              setState(() {
                listArticleError = true;
              });
              showErrorDialog(state.message);
            }
          });
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget trending() {
    return BlocBuilder<TrendingArticlesCubit, TrendingArticlesState>(
      builder: (context, state) {
        if (state is TrendingArticlesLoading) {
          return const SimpleArticleItemPlaceholder();
        } else if (state is TrendingArticlesCompleted) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleGroup(state.listArticles[0].blockGroup.toString()),
              Column(
                children: state.listArticles.asMap().entries.map(
                  (entry) {
                    final listArticles = entry.value;
                    return Column(
                      children: [
                        SimpleArticleItem(
                          listArticles: listArticles,
                          onTap: () {
                            context.pushNamed(
                              RouteConstants.detailArticle,
                              pathParameters: {
                                'id': listArticles.id?.toString() ?? '0',
                                'has_video': (listArticles.hasVideo ?? false).toString(),
                              }
                            );
                          },
                        ),
                        if (entry.key != state.listArticles.length - 1)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: DottedDecoration(
                              linePosition: LinePosition.bottom,
                              strokeWidth: 2,
                            ),
                          )
                      ],
                    );
                  }
                ).toList()
              ),
            ],
          );
        } else if (state is TrendingArticlesError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!listArticleError) {
              setState(() {
                listArticleError = true;
              });
              showErrorDialog(state.message);
            }
          });
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget reels() {
    return BlocBuilder<ListReelsCubit, ListReelsState>(
      builder: (context, state) {
        if (state is ListReelsLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: kGreenColor,
            ),
          );
        } else if (state is ListReelsCompleted) {
          shuffledReels ??= state.listReels.toList()..shuffle();
          final limitedRandomReels = shuffledReels!.take(4).toList();

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: limitedRandomReels.length,
              itemBuilder: (context, index) {
                final listReels = limitedRandomReels[index];
                return GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      RouteConstants.detailReels,
                      pathParameters: {'id': listReels.id?.toString() ?? '0'},
                    );
                  },
                  child: VideoGridItem(
                    videoUrl: listReels.videoUrl!,
                    title: listReels.title!,
                  ),
                );
              },
            ),
          );
        } else if (state is ListReelsError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showErrorDialog(state.message);
          });
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget titleGroup(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Container(
        decoration: DottedDecoration(
          shape: Shape.line,
          linePosition: LinePosition.bottom,
          color: kBlackColor
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontSize: 22,
            fontWeight: bold,
          ),
        ),
      ),
    );
  }
}