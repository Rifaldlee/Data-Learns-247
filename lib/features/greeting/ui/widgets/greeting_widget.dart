import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/authentication/cubit/user_cubit.dart';
import 'package:data_learns_247/features/greeting/cubit/greeting_cubit.dart';
import 'package:data_learns_247/core/helper/greeting_helper.dart';
import 'package:data_learns_247/shared_ui/widgets/search_button.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  String _getTime() {
    final hour = DateTime.now().hour;

    if (hour >= 4 && hour < 11) { // pagi (04:00–10:59)
      return 'pagi';
    } else if (hour >= 11 && hour < 15) { // siang (11:00–14:59)
      return 'siang';
    } else if (hour >= 15 && hour < 18) { // sore (15:00–17:59)
      return 'sore';
    } else { // malam (18:00–04:59)
      return 'malam';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTime = _getTime();

    return BlocBuilder<GreetingCubit, GreetingState>(
      builder: (context, state) {
        if (state is GreetingLoading) {
          
        } else if (state is GreetingComplete) {
          final greeting = (state).greeting;

          final image = greeting.getImageByTime(currentTime);
          final text = greeting.getTextByTime(currentTime);
          return Container(
            width: double.infinity,
            height: 260 + MediaQuery.of(context).viewPadding.top,
            padding: const EdgeInsets.fromLTRB(24, 36, 24, 12),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(image!),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    if (state is UserLoading) {

                    } else if (state is UserCompleted) {
                      return Column(
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
                            style: const TextStyle(
                              fontSize: 20.0,
                              color: kLightGreyColor,
                              fontWeight: FontWeight.bold
                            )
                          ),
                        ],
                      );
                    } else if (state is UserError) {

                    }
                    return const SizedBox.shrink();
                  }
                ),
                Text(
                  text!,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: kLightGreyColor,
                      fontWeight: FontWeight.bold
                    )
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