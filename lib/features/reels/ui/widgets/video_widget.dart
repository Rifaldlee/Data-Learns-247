import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/core/theme/theme.dart';
import 'package:data_learns_247/features/reels/data/models/detail_reels_model.dart';
import 'package:data_learns_247/features/reels/data/models/related_contents_model.dart';
import 'package:data_learns_247/features/reels/data/models/related_course_model.dart';
import 'package:data_learns_247/features/reels/ui/widgets/item/related_content_item.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';

class VideoWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final DetailReels detailReels;

  const VideoWidget({
    super.key,
    required this.controller,
    required this.detailReels,
  });

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  bool showIcon = false;
  bool isTitleExpanded = false;
  bool isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller.value.isInitialized) {
      widget.controller.play();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (widget.controller.value.isPlaying) {
            widget.controller.pause();
            showIcon = true;
          } else {
            widget.controller.play();
            showIcon = false;
          }
        });
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.controller.value.isInitialized ? FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: widget.controller.value.size.width,
              height: widget.controller.value.size.height,
              child: VideoPlayer(widget.controller),
            ),
          )
          : const Center(child: CircularProgressIndicator(color: kGreenColor)),
          if (showIcon)
            Center(
              child: Icon(
                Icons.play_arrow,
                size: 64,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((widget.detailReels.relatedContents != null) ||
                    (widget.detailReels.relatedCourse != null))
                  relatedContentsBottomSheet(widget.detailReels),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    if (isDescriptionExpanded || isTitleExpanded) {
                      setState(() {
                        isDescriptionExpanded = !isDescriptionExpanded;
                        isTitleExpanded = !isTitleExpanded;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDescriptionExpanded ? kBlackColor.withOpacity(0.3) : null,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        topLeft: Radius.circular(8),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(widget.detailReels.authorPhoto.toString()),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              widget.detailReels.author.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: kWhiteColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        videoTitle(widget.detailReels.title!),
                        videoDescription(widget.detailReels.videoDescription!)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget videoTitle(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTitleExpanded = !isTitleExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          widget.detailReels.title.toString(),
          maxLines: isTitleExpanded ? null : 1,
          overflow: isTitleExpanded ? null : TextOverflow.ellipsis,
          style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: kWhiteColor),
        ),
      ),
    );
  }

  Widget videoDescription(String description) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isDescriptionExpanded = !isDescriptionExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        constraints: BoxConstraints(
          maxHeight: isDescriptionExpanded
            ? MediaQuery.of(context).size.height * 0.5
            : double.infinity,
        ),
        child: SingleChildScrollView(
          physics: isDescriptionExpanded
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
          child: Text(
            widget.detailReels.videoDescription.toString(),
            maxLines: isDescriptionExpanded ? null : 2,
            overflow: isDescriptionExpanded ? null : TextOverflow.ellipsis,
            style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: kWhiteColor),
          ),
        ),
      ),
    );
  }

  Widget relatedContentsBottomSheet(DetailReels detailReels) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: kWhiteColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          builder: (context) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.7,
              maxChildSize: 0.7,
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      relatedCourse(detailReels.relatedCourse),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: listRelatedContents(detailReels),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }
        );
      },
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.6
        ),
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: kBlackColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.article,
              color: kGreenColor,
            ),
            const SizedBox(width: 8),
            Text(
              'Konten terkait',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: bold,
                color: kWhiteColor
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget listRelatedContents(DetailReels detailReels) {
    return Column(
      children: detailReels.relatedContents!.map((RelatedContents relatedContents) {
        return SizedBox(
          width: double.infinity,
          child: RelatedContentItem(
            relatedContents: relatedContents,
            onTap: () {
              context.pushNamed(
                RouteConstants.detailArticle,
                pathParameters: {
                  'id': relatedContents.id?.toString() ?? '0',
                  'has_video': (false).toString(),
                }
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget relatedCourse(RelatedCourse? relatedCourse) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          RouteConstants.detailCourse,
          queryParameters: {
            'courseId': relatedCourse?.id?.toString() ?? '0'
          }
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FastCachedImage(
              url: relatedCourse?.image ?? '',
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, progress) {
                return const RectangleShimmerSizedBox(
                  height: 200,
                  width: double.infinity
                );
              }
            ),
            Text(
              relatedCourse?.title ?? "",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: bold,
                color: kBlackColor
              ),
            ),
          ],
        ),
      ),
    );
  }
}