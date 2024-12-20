import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/reels/cubit/list_reels_cubit.dart';
import 'package:data_learns_247/features/reels/ui/widgets/item/video_grid_item.dart';
import 'package:data_learns_247/shared_ui/widgets/error_dialog.dart';

class ListReelsScreen extends StatefulWidget {
  const ListReelsScreen({super.key});

  @override
  State<ListReelsScreen> createState() {
    return _ListReelsScreenState();
  }
}

class _ListReelsScreenState extends State<ListReelsScreen> {
  VideoPlayerController? controller;

  @override
  void initState() {
    super.initState();
    context.read<ListReelsCubit>().fetchListReels();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        message: message,
        onClose: () {
          Navigator.of(context).pop();
          context.read<ListReelsCubit>().fetchListReels();
        },
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ListReelsCubit, ListReelsState>(
        builder: (context, state) {
          if (state is ListReelsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: kGreenColor,
              ),
            );
          } else if (state is ListReelsCompleted) {
            final randomReels = state.listReels.toList()..shuffle();
            final limitedRandomReels = randomReels.take(4).toList();

            return Container(
              margin: const EdgeInsets.all(16),
              child: GridView.builder(
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
                      child: VideoGridItem(videoUrl: listReels.videoUrl!),
                    );
                  }
              ),
            );
          } else if (state is ListReelsError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showErrorDialog(state.message);
            });
          }
          return const SizedBox.shrink();
        }
      ),
    );
  }
}