import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/core/utils/shared_pref_util.dart';
import 'package:data_learns_247/core/utils/error_dialog.dart';
import 'package:data_learns_247/features/authentication/cubit/user_cubit.dart';
import 'package:data_learns_247/features/authentication/ui/widgets/item/personal_info_item.dart';
import 'package:data_learns_247/features/authentication/ui/widgets/placeholder/profile_screen_placeholder.dart';
import 'package:data_learns_247/shared_ui/widgets/affirmation_dialog.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';
import 'package:data_learns_247/shared_ui/widgets/text_with_shader.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().getUserData();
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
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
          child: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return const ProfileScreenPlaceholder();
              } else if (state is UserCompleted) {
                return profileScreenWidget(
                  state.userData.avatarUrls!.s96 ?? "",
                  state.userData.meta!.fullName ?? "",
                  state.userData.meta!.email ?? "",
                  state.userData.meta!.userOrganization ?? "",
                  state.userData.meta!.userCity ?? "",
                  state.userData.meta!.userYearOfBirth ?? "",
                  );
              } else if (state is UserError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ErrorDialog.showErrorDialog(context, state.message, () {
                    Navigator.of(context).pop();
                    context.read<UserCubit>().getUserData();
                  });
                });
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget profileScreenWidget(
    String avatarLink,
    String name,
    String email,
    String organization,
    String city,
    String birth
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWithShader(
          text: 'Profile',
          textStyle: Theme.of(context).textTheme.headlineMedium!,
        ),
        const SizedBox(height: 16),
        profileHeader(avatarLink, name, email),
        const SizedBox(height: 12),
        personalInfo(organization, city, birth),
        const SizedBox(height: 12),
        appVersion(),
        const Spacer(),
        logoutButton(),
      ],
    );
  }

  Widget profileHeader(String avatarLink, String name, String email) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: const DecorationImage(image:  AssetImage("assets/img/img_default_bg_profile.png"),fit: BoxFit.fill),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: kWhiteColor,
                shape: BoxShape.circle
              ),
              child: ClipOval(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(36),
                  child: FastCachedImage(
                    url: avatarLink,
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
            ),
            const SizedBox(width: 12),
            emailName(name, email)
          ],
        ),
      ),
    );
  }

  Widget emailName(String name, String email) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 20.0,
              color: kWhiteColor,
              fontWeight: FontWeight.bold
            )
          ),
          Text(
            email,
              style: const TextStyle(
                fontSize: 14.0,
                color: kWhiteColor,
              )
          )
        ],
      )
    );
  }

  Widget personalInfo(String organization, String city, String birth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informasi Personal',
          style: Theme.of(context).textTheme.titleLarge
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8)
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                PersonalInfoItem(
                  icon: Icons.location_on_outlined,
                  title: 'City',
                  content: city,
                ),
                const SizedBox(height: 12),
                PersonalInfoItem(
                  icon: Icons.location_city_outlined,
                  title: 'Organization',
                  content: organization,
                ),
                const SizedBox(height: 12),
                PersonalInfoItem(
                  icon: Icons.calendar_month_outlined,
                  title: 'Year of Birth',
                  content: birth,
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      RouteConstants.certificate
                    );
                  },
                  child: const Row(
                    children:[
                      Expanded(
                        child: PersonalInfoItem(
                          icon: Icons.article_outlined,
                          title: 'Certificate',
                          content: 'Sertifikat anda',
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: kBlueColor,
                        size: 42,
                      )
                    ]
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget appVersion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informasi Aplikasi',
          style: Theme.of(context).textTheme.titleLarge
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8)
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0
            ),
            child: PersonalInfoItem(
              icon: Icons.phone_android,
              title: 'Versi Aplikasi',
              content: "1.08.18"
            ),
          ),
        ),
      ],
    );
  }

  Widget logoutButton() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AffirmationDialog(
            message: 'Apakah anda yakin ingin keluar dari akun saat ini?',
            proceedText: 'Keluar',
            onProceed: () {
              Navigator.pop(context);
              SharedPrefUtil.storeEmail("");
              SharedPrefUtil.storeJwtToken("");
              SharedPrefUtil.storeUserId("");
              SharedPrefUtil.storeCookie("");
              context.goNamed(RouteConstants.login);
            },
          ),
          barrierDismissible: false
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: kWhiteColor.withOpacity(0.5),
                child: const Icon(
                  Icons.logout,
                  color: kRedColor
                ),
              ),
              const SizedBox(width: 24),
              const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 18.0,
                  color: kBlackColor,
                  fontWeight: FontWeight.w500
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}