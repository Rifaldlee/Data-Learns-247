import 'package:data_learns_247/features/notification/data/models/notification_model.dart';
import 'package:data_learns_247/features/notification/ui/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/core/route/page_cubit.dart';
import 'package:data_learns_247/features/article/ui/screens/list_article_screen.dart';
import 'package:data_learns_247/features/authentication/ui/screens/profile_screen.dart';
import 'package:data_learns_247/features/course/ui/screens/list_courses_screen.dart';
import 'package:data_learns_247/features/course/ui/screens/my_courses_list_screen.dart';

class MainFrontPage extends StatefulWidget {
  const MainFrontPage({super.key});

  @override
  State<MainFrontPage> createState() {
    return _MainFrontPageState();
  }
}

class _MainFrontPageState extends State<MainFrontPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if(!didPop) {
          SystemNavigator.pop();
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: kWhiteColor,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: kWhiteColor,
          body: BlocBuilder<PageCubit, int>(
            builder: (context, selectedTabIndex) {
              Widget activeTab = const ListArticlesScreen();
              if (selectedTabIndex == 1) activeTab = const ListCoursesScreen();
              if (selectedTabIndex == 2) activeTab = const MyCoursesListScreen();
              if (selectedTabIndex == 3) activeTab = const ProfileScreen();
              if (selectedTabIndex == 4) activeTab = const NotificationScreen();

              return activeTab;
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: kWhiteColor,
            onTap: (index) {
              context.read<PageCubit>().setPage(index);
            },
            currentIndex: context.watch<PageCubit>().state,
            selectedItemColor: kGreenColor,
            selectedLabelStyle: const TextStyle(fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            items: [
              BottomNavigationBarItem(
                icon: context.read<PageCubit>().state == 0
                  ? const Icon(Icons.home_filled)
                  : const Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: context.read<PageCubit>().state == 1
                  ? const Icon(Icons.play_lesson)
                  : const Icon(Icons.play_lesson_outlined),
                label: 'Course',
              ),
              BottomNavigationBarItem(
                icon: context.read<PageCubit>().state == 2
                  ? const Icon(Icons.play_circle_fill)
                  : const Icon(Icons.play_circle_outline),
                label: 'My Learning',
              ),
              BottomNavigationBarItem(
                icon: context.read<PageCubit>().state == 3
                  ? const Icon(Icons.person)
                  : const Icon(Icons.person_outline),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: context.read<PageCubit>().state == 4
                  ? const Icon(Icons.notifications_active)
                  : const Icon(Icons.notifications_active_outlined),
                label: 'Notification',
              ),
            ],
          ),
        ),
      ),
    );
  }
}