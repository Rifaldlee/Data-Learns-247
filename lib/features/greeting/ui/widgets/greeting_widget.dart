import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/article/cubit/list_articles_cubit.dart';
import 'package:data_learns_247/features/article/cubit/random_article_cubit.dart';
import 'package:data_learns_247/features/article/ui/widgets/item/simple_article_item.dart';
import 'package:data_learns_247/features/article/ui/widgets/placeholder/simple_article_item_placeholder.dart';
import 'package:data_learns_247/features/authentication/cubit/user_cubit.dart';
import 'package:data_learns_247/features/greeting/cubit/greeting_cubit.dart';
import 'package:data_learns_247/core/helper/greeting_helper.dart';
import 'package:data_learns_247/shared_ui/widgets/search_button.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GreetingWidget extends StatefulWidget {
  const GreetingWidget({super.key});

  @override
  State<GreetingWidget> createState() => _GreetingWidgetState();
}

class _GreetingWidgetState extends State<GreetingWidget> {
  @override
  void initState() {
    context.read<GreetingCubit>().fetchGreeting();
    context.read<UserCubit>().getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GreetingCubit, GreetingState>(
      builder: (context, state) {
        if (state is GreetingLoading) {
          return const RectangleShimmerSizedBox(
            height: 360,
            width: double.infinity
          );
        } else if (state is GreetingComplete) {
          final greeting = (state).greeting;

          final image = greeting.getImageByTime();
          final text = greeting.getTextByTime();
          final time = greeting.getTime();

          return Container(
            width: double.infinity,
            height: 360 + MediaQuery.of(context).viewPadding.top,
            padding: const EdgeInsets.fromLTRB(24, 36, 24, 12),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(image!),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    if (state is UserLoading) {
                      return const CircularShimmerSizedBox(
                        height: 36,
                        width: 36
                      );
                    } else if (state is UserCompleted) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              ClipOval(
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(20),
                                  child: FastCachedImage(
                                    url: state.userData.avatarUrls!.s96 ?? "",
                                    fadeInDuration: const Duration(seconds: 0),
                                    loadingBuilder: (context, progress) {
                                      return const CircularShimmerSizedBox(
                                        height: 36,
                                        width: 36
                                      );
                                    }
                                  )
                                ),
                              ),
                              const SizedBox(width: 18),
                              const Expanded(
                                flex: 2,
                                child: SearchButton(tabIndex: 0),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Text(
                            "Hi ${state.userData.meta!.fullName}",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: time != 'siang' ? kWhiteColor : kBlackColor,
                              fontWeight: FontWeight.bold
                            )
                          ),
                        ],
                      );
                    } else if (state is UserError) {
                      return const CircularShimmerSizedBox(
                        height: 36,
                        width: 36
                      );
                    }
                    return const SizedBox.shrink();
                  }
                ),
                Text(
                  text!,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: time != 'siang' ? kWhiteColor : kBlackColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                BlocBuilder<RandomArticleCubit, RandomArticleState>(
                  builder: (context, state) {
                    if (state is RandomArticleLoading) {
                      return const SimpleArticleItemPlaceholder();
                    } else if (state is RandomArticleCompleted) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: kWhiteColor,
                            width: 2
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8)
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.randomArticle.category.toString().toUpperCase(),
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: kWhiteColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.randomArticle.title.toString(),
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: kWhiteColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is RandomArticleError) {
                      const SizedBox.shrink();
                    }
                    return const SizedBox.shrink();
                  },
                )
              ],
            )
          );
        }
        return const SizedBox.shrink();
      }
    );
  }
}