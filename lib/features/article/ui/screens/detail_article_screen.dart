import 'package:data_learns_247/core/route/page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:html/parser.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/core/tools/youtube_extractor.dart';
import 'package:data_learns_247/core/utils/error_dialog.dart';
import 'package:data_learns_247/features/article/cubit/article_detail_navigation_cubit.dart';
import 'package:data_learns_247/features/article/cubit/detail_article_cubit.dart';
import 'package:data_learns_247/features/article/data/models/detail_article_model.dart';
import 'package:data_learns_247/features/article/data/models/list_link_model.dart';
import 'package:data_learns_247/features/article/ui/widgets/item/link_article_item.dart';
import 'package:data_learns_247/features/article/ui/widgets/placeholder/detail_article_placeholder.dart';
import 'package:data_learns_247/shared_ui/widgets/custom_app_bar.dart';
import 'package:data_learns_247/shared_ui/widgets/error_dialog_widget.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';
import 'package:data_learns_247/shared_ui/widgets/youtube_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:data_learns_247/core/tools/html_parser.dart';

class DetailArticleScreen extends StatefulWidget {
  final String id;
  final bool hasVideo;

  const DetailArticleScreen({super.key, required this.id, required this.hasVideo});

  @override
  State<DetailArticleScreen> createState() => _DetailArticleScreenState();
}

class _DetailArticleScreenState extends State<DetailArticleScreen> {
  YoutubePlayerController? ytController;
  bool isFullScreen = false;
  bool isControllerInitialized = false;
  bool isSeeking = false;
  bool wasPlayingBeforeTransition = false;
  double? lastPlaybackPosition;

  @override
  void initState() {
    super.initState();
    context.read<ArticleDetailNavigationCubit>().addToHistory(widget.id, widget.hasVideo);
    fetchArticleData();
  }

  @override
  void didUpdateWidget(DetailArticleScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.id != oldWidget.id || widget.hasVideo != oldWidget.hasVideo) {
      context.read<ArticleDetailNavigationCubit>().addToHistory(widget.id, widget.hasVideo);
      fetchArticleData();
    }
    if (widget.hasVideo != oldWidget.hasVideo && ytController != null) {
      updateYoutubeController();
    }
  }

  @override
  void dispose() {
    ytController?.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  void fetchArticleData() {
    if (widget.id.isNotEmpty) {
      context.read<DetailArticleCubit>().fetchDetailArticle(widget.id);
    }
  }

  void handleBackNavigation() {
    final navigationCubit = context.read<ArticleDetailNavigationCubit>();
    final previousArticle = navigationCubit.getPreviousArticle();

    if (previousArticle != null) {
      navigationCubit.removeLastFromHistory();
      context.pushNamed(
        RouteConstants.detailArticle,
        pathParameters: {
          'id': previousArticle.id,
          'has_video': previousArticle.hasVideo.toString(),
        },
      );
    } else {
      navigationCubit.clearHistory();
      context.read<PageCubit>().setPage(0);
      context.pushNamed(
        RouteConstants.mainFrontPage,
      );
    }
  }

  void updateYoutubeController() {
    if (ytController != null) {
      ytController!.dispose();
      setState(() {
        ytController = null;
        isControllerInitialized = false;
      });
    }
  }

  void initializeYoutubeController(String content) {
    final ytId = YoutubeExtractor.extract(content: content, attribute: 'src');
    if (ytId.isEmpty) {
      showErrorDialog("Invalid YouTube video ID");
      return;
    }

    if (ytController != null && ytController!.initialVideoId != ytId) {
      ytController!.load(ytId);
    }

    ytController ??= YoutubePlayerController(
      initialVideoId: ytId.toString(),
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        enableCaption: false,
        controlsVisibleAtStart: true,
      ),
    );
    ytController!.addListener(youtubeControllerListener);
  }

  void youtubeControllerListener() {
    if (!mounted || ytController == null) return;
    if (!isSeeking && ytController!.value.isReady && lastPlaybackPosition != null) {
      isSeeking = true;
      ytController!.seekTo(Duration(seconds: lastPlaybackPosition!.toInt()));
      if (wasPlayingBeforeTransition) {
        ytController!.play();
      }
      lastPlaybackPosition = null;
      isSeeking = false;
    }
  }

  void onEnterFullScreen() {
    wasPlayingBeforeTransition = ytController!.value.isPlaying;
    lastPlaybackPosition = ytController!.value.position.inSeconds.toDouble();
    setState(() {
      isFullScreen = true;
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (wasPlayingBeforeTransition && ytController != null) {
        ytController!.play();
      }
    });
  }

  void onExitFullScreen() {
    wasPlayingBeforeTransition = ytController!.value.isPlaying;
    lastPlaybackPosition = ytController!.value.position.inSeconds.toDouble();

    setState(() {
      isFullScreen = false;
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (wasPlayingBeforeTransition && ytController != null) {
        ytController!.play();
      }
    });
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialogWidget(
        message: message,
        onClose: () {
          Navigator.of(context).pop();
          fetchArticleData();
        },
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailArticleCubit, DetailArticleState>(
      builder: (context, state) {
        if (state is DetailArticleLoading) {
          return const DetailArticlePlaceholder();
        } else if (state is DetailArticleCompleted) {
          if (widget.hasVideo) {
            initializeYoutubeController(state.detailArticle.body!);
          }
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) {
                handleBackNavigation();
              }
            },
            child: SafeArea(
              child: isFullScreen ? Center(
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: YoutubePlayerWidget(
                    controller: ytController!,
                    onEnterFullScreen: onEnterFullScreen,
                    onExitFullScreen: onExitFullScreen
                  )
                ),
              ) : Scaffold(
                backgroundColor: isFullScreen ? kBlackColor : kWhiteColor,
                appBar: isFullScreen ? null : CustomAppBar(
                  showBackButton: true,
                  backAction: handleBackNavigation,
                ),
                body : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 32.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        detailArticleHeading(state.detailArticle),
                        const SizedBox(height: 18),
                        if (ytController != null)
                          YoutubePlayerWidget(
                            controller: ytController!,
                            onEnterFullScreen: onEnterFullScreen,
                            onExitFullScreen: onExitFullScreen
                          ),
                        articleContent(state.detailArticle.body ?? 'No Content Available'),
                        const SizedBox(height: 16),
                        if (state.detailArticle.listLink != null && state.detailArticle.listLink!.isNotEmpty)
                          articleListLink(state.detailArticle),
                      ],
                    ),
                  ),
                ),
              )
            ),
          );
        } else if (state is DetailArticleError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ErrorDialog.showErrorDialog( context, state.message, () {
                Navigator.of(context).pop();
                fetchArticleData();
              },
            );
          });
        }
        return const Center(child: Text('Unknown state'));
      },
    );
  }

  Widget detailArticleHeading(Article article) {
    final titleDoc = parse(article.title!);
    var title = titleDoc.querySelector('a')?.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        articleImage(article.fieldImage!),
        const SizedBox(height: 16),
        articleTitle(title ?? 'No Title'),
        const SizedBox(height: 12),
        articleAuthorInfo(article.fieldDisplayName ?? 'Unknown', article.created ?? '', article.userPicture!),
      ],
    );
  }

  Widget articleImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: FastCachedImage(
        url: imageUrl,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, progress) {
          return const RectangleShimmerSizedBox(
            height: 200,
            width: double.infinity
          );
        }
      ),
    );
  }

  Widget articleTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget articleAuthorInfo(String authorName, String date, String photoUrl) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(photoUrl),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              authorName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              date,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget articleContent(String content) {
    final document = parse(content);

    var descriptionElement = document.getElementById('--description');
    if (descriptionElement == null) {
      return const SizedBox();
    }

    return Column(
      children: descriptionElement.children.map((child) {
        return HtmlContentParser.parseHtml(element: child, context: context);
      }).whereType<Widget>().toList(),
    );
  }

  Widget articleListLink(Article detailArticle) {
    return Column(
      children: detailArticle.listLink!.map((ListLink listLink) {
        return SizedBox(
          width: double.infinity,
          child: LinkArticleItem(
            listLink: listLink,
            onTap: () {
              final id = listLink.id?.toString() ?? '0';
              final hasVideo = listLink.hasVideo ?? false;
              context.read<ArticleDetailNavigationCubit>().addToHistory(id, hasVideo);
              context.pushNamed(
                RouteConstants.detailArticle,
                pathParameters: {
                  'id': id,
                  'has_video': hasVideo.toString(),
                },
              );
            },
          ),
        );
      }).toList(),
    );
  }
}