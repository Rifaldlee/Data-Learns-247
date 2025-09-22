import 'package:data_learns_247/core/route/page_cubit.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/core/tools/html_parser.dart';
import 'package:data_learns_247/core/tools/youtube_extractor.dart';
import 'package:data_learns_247/core/utils/error_dialog.dart';
import 'package:data_learns_247/features/article/cubit/article_detail_navigation_cubit.dart';
import 'package:data_learns_247/features/article/cubit/detail_article_cubit.dart';
import 'package:data_learns_247/features/article/data/models/detail_article_model.dart';
import 'package:data_learns_247/features/article/ui/screens/content_article_heading.dart';
import 'package:data_learns_247/features/article/ui/widgets/placeholder/detail_article_placeholder.dart';
import 'package:data_learns_247/shared_ui/widgets/custom_app_bar.dart';
import 'package:data_learns_247/shared_ui/widgets/youtube_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:html/parser.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailContentScreen extends StatefulWidget {
  final String id;

  const DetailContentScreen({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return _DetailContentScreenState();
  }
}

class _DetailContentScreenState extends State<DetailContentScreen> {
  YoutubePlayerController? ytController;
  bool isFullScreen = false;
  bool isSeeking = false;
  bool wasPlayingBeforeTransition = false;
  double? lastPlaybackPosition;

  @override
  void initState() {
    super.initState();
    context.read<DetailArticleCubit>().fetchDetailArticle(widget.id);
  }

  @override
  void dispose() {
    ytController?.removeListener(youtubeControllerListener);
    ytController?.dispose();
    super.dispose();
  }

  void showErrorDialog(String message) {
    if (!mounted) return;
    ErrorDialog.showErrorDialog(context, message, () {
      Navigator.of(context).pop();
    });
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
    if (!mounted || ytController == null) {
      ytController?.setVolume(0);
      return;
    }
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
    if (ytController != null) {
      wasPlayingBeforeTransition = ytController!.value.isPlaying;
      lastPlaybackPosition = ytController!.value.position.inSeconds.toDouble();
    }
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
    if (ytController != null) {
      wasPlayingBeforeTransition = ytController!.value.isPlaying;
      lastPlaybackPosition = ytController!.value.position.inSeconds.toDouble();
    }
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

  void handleBackNavigation() {
    final navigationCubit = context.read<ArticleDetailNavigationCubit>();
    final previousContent = navigationCubit.getPreviousArticle();

    if (previousContent != null) {
      navigationCubit.removeLastFromHistory();
      context.goNamed(
        RouteConstants.detailArticle,
        pathParameters: {
          'id': previousContent.id,
          'has_video': previousContent.hasVideo.toString(),
        },
      );
    } else {
      navigationCubit.clearHistory();
      context.read<PageCubit>().setPage(0);
      context.goNamed(
        RouteConstants.mainFrontPage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailArticleCubit, DetailArticleState>(
      builder: (context, state) {
        if (state is DetailArticleLoading) {
          return const DetailArticlePlaceholder();
        } else if (state is DetailArticleCompleted) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) {
                handleBackNavigation();
              }
            },
            child: Scaffold(
              backgroundColor: isFullScreen ? kBlackColor : kWhiteColor,
              appBar: isFullScreen ? null : CustomAppBar(
                showBackButton: true,
                backAction: handleBackNavigation,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: buildContent(
                      state.detailArticle,
                      state.detailArticle.body!,
                      state.detailArticle.category!,
                    )
                  )
                ],
              ),
            )
          );
        } else if (state is DetailArticleError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ErrorDialog.showErrorDialog( context, state.message, () {
              Navigator.of(context).pop();
              context.read<DetailArticleCubit>().fetchDetailArticle(widget.id);
            });
          });
        }
        return const SizedBox.shrink();
      }
    );
  }

  Widget buildContent(Article article, String content, String category) {
    switch (category.toLowerCase()) {
      case 'video':
        return buildVideoContent(content);
      case 'book':
        return buildBookContent(content);
      case 'artikel':
        return buildArticleContent(article, content);
      case 'paper':
        return buildPaperContent();
      case 'presentation':
        return buildPresentationContent();
      default:
        return const Center(child: Text('Unsupported lesson type'));
    }
  }

  Widget buildVideoContent(String content) {
    if (ytController == null) {
      initializeYoutubeController(content);
    }

    return SafeArea(
      child: isFullScreen ? PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            onExitFullScreen();
          }
        },
        child: Center(
          child: FittedBox(
            fit: BoxFit.fill,
            child: youtubePlayer(ytController!),
          ),
        ),
      ) : Column(
        children: [
          youtubePlayer(ytController!),
        ],
      ),
    );
  }

  Widget buildArticleContent(Article article, String content) {
    final document = parse(content);
    var elements = document.body?.children ?? [];
    var descriptionElement = document.getElementById('--description');

    final ytId = YoutubeExtractor.extract(content: content, attribute: 'src');
    if (ytId.isNotEmpty) {
      if (ytController == null || ytController!.initialVideoId != ytId) {
        initializeYoutubeController(content);
      }
    }

    return SafeArea(
      child: isFullScreen ? PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            onExitFullScreen();
          }
        },
        child: Center(
          child: FittedBox(
            fit: BoxFit.fill,
            child: youtubePlayer(ytController!),
          ),
        ),
        ) : Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContentArticleHeading(article: article),
              if (ytController != null)
                YoutubePlayerWidget(
                  controller: ytController!,
                  onEnterFullScreen: onEnterFullScreen,
                  onExitFullScreen: onExitFullScreen
                ),
              if (descriptionElement == null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: elements.map((e) {
                    return HtmlContentParser.parseHtml(element: e, context: context);
                  }).whereType<Widget>().toList(),
                ),
              if (descriptionElement != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: descriptionElement.children.map((child) {
                    return HtmlContentParser.parseHtml(element: child, context: context);
                  }).whereType<Widget>().toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBookContent(String content) {
    final document = parse(content);
    var descriptionElement = document.getElementById('--description');

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: descriptionElement!.children.map((child) {
                return HtmlContentParser.parseHtml(element: child, context: context);
              }).whereType<Widget>().toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaperContent() {
    return const SizedBox.shrink();
  }

  Widget buildPresentationContent() {
    return const SizedBox.shrink();
  }

  Widget youtubePlayer(YoutubePlayerController controller) {
    return YoutubePlayerWidget(
      controller: controller,
      onEnterFullScreen: onEnterFullScreen,
      onExitFullScreen: onExitFullScreen,
    );
  }
}