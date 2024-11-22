import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/article/cubit/featured_articles_cubit.dart';
import 'package:data_learns_247/features/article/cubit/list_articles_cubit.dart';
import 'package:data_learns_247/features/article/cubit/random_article_cubit.dart';
import 'package:data_learns_247/features/article/cubit/recommended_articles_cubit.dart';
import 'package:data_learns_247/features/article/cubit/trending_articles_cubit.dart';
import 'package:data_learns_247/features/article/data/models/list_articles_model.dart';
import 'package:data_learns_247/features/article/ui/widgets/item/card_article_item.dart';
import 'package:data_learns_247/features/article/ui/widgets/item/clip_article_item.dart';
import 'package:data_learns_247/features/article/ui/widgets/item/simple_article_item.dart';
import 'package:data_learns_247/features/article/ui/widgets/placeholder/card_article_item_placeholder.dart';
import 'package:data_learns_247/features/article/ui/widgets/placeholder/leading_article_placeholder.dart';
import 'package:data_learns_247/features/article/ui/widgets/placeholder/simple_article_item_placeholder.dart';
import 'package:data_learns_247/shared_ui/widgets/error_dialog.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';

class ListArticlesScreen extends StatefulWidget {
  const ListArticlesScreen({super.key});

  @override
  State<ListArticlesScreen> createState() => _ListArticlesScreenState();
}

class _ListArticlesScreenState extends State<ListArticlesScreen> {
  bool listArticleError = false;

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  void fetchArticles() {
    context.read<ListArticlesCubit>().fetchListArticles();
    context.read<FeaturedArticlesCubit>().fetchFeaturedArticles();
    context.read<RecommendedArticlesCubit>().fetchRecommendedArticles();
    context.read<TrendingArticlesCubit>().fetchTrendingArticles();
    context.read<RandomArticleCubit>().fetchRandomArticle();
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        message: message,
        onClose: () {
          setState(() {
            listArticleError = false;
          });
          Navigator.of(context).pop();
          fetchArticles();
        },
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kWhiteColor,
        statusBarIconBrightness: Brightness.dark
      ),
      child: Scaffold(
        backgroundColor: kWhiteColor,
        body: ListView(
          children: [
            leadingArticle(),
            featured(),
            const SizedBox(height: 16),
            clipArticle(),
            trending(),
            const SizedBox(height: 16),
            listArticleCard(),
            recommended(),
          ],
        ),
      ),
    );
  }

  Widget leadingArticle() {
    final unescape = HtmlUnescape();

    return BlocBuilder<RandomArticleCubit, RandomArticleState>(
      builder: (context, state) {
        if (state is RandomArticleLoading) {
          return const LeadingArticlePlaceHolder();
        } else if (state is RandomArticleCompleted) {
          return GestureDetector(
            onTap: () {
              context.pushNamed(
                RouteConstants.detailArticle,
                pathParameters: {
                  'id': state.randomArticle.id.toString(),
                  'has_video': (state.randomArticle.hasVideo ?? false).toString(),
                }
              );
            },
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              padding: const EdgeInsets.only(bottom: 8),
              decoration: DottedDecoration(
                linePosition: LinePosition.bottom,
                strokeWidth: 2
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FastCachedImage(
                    url: state.randomArticle.image,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(seconds: 0),
                    loadingBuilder: (context, progress) {
                      return const RectangleShimmerSizedBox(
                        height: 200,
                        width: double.infinity
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.randomArticle.blockGroup,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          unescape.convert(state.randomArticle.title),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.dmSerifText(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            )
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.randomArticle.dateCreated,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
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
      }
    );
  }

  Widget clipArticle() {
    return BlocBuilder<RandomArticleCubit, RandomArticleState>(
      builder: (context, state) {
        if (state is RandomArticleLoading) {
          return Container(
            margin: const EdgeInsets.all(16),
            child: const CardArticleItemPlaceholder()
          );
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
          return const Padding(
            padding: EdgeInsets.only(left: 16),
            child:  CardArticleItemPlaceholder(),
          );
        } else if (state is ListArticlesCompleted) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16),
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
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: DottedDecoration(
                          linePosition: LinePosition.bottom,
                          strokeWidth: 2,
                        ),
                      )
                  ],
                );
              }
            ).toList()
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
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: DottedDecoration(
                          linePosition: LinePosition.bottom,
                          strokeWidth: 2,
                        ),
                      )
                  ],
                );
              }
            ).toList()
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
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: DottedDecoration(
                          linePosition: LinePosition.bottom,
                          strokeWidth: 2,
                        ),
                      )
                  ],
                );
              }
            ).toList()
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
}