import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/article/ui/screens/list_article_screen.dart';
import 'package:data_learns_247/features/authentication/ui/screens/profile_screen.dart';
import 'package:data_learns_247/features/course/ui/screens/list_courses_screen.dart';
import 'package:data_learns_247/features/search/ui/screens/search_screen.dart';

class MainFrontPage extends StatefulWidget {
  const MainFrontPage({super.key});

  @override
  State<MainFrontPage> createState() {
    return _MainFrontPageState();
  }
}

class _MainFrontPageState extends State<MainFrontPage> {
  int _selectedTabIndex = 0;

  void _selectTab(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {

    Widget activeTab = const ListArticlesScreen();
    if (_selectedTabIndex == 1) {
      activeTab = const ListCoursesScreen();
    }
    if (_selectedTabIndex == 2) {
      activeTab = const SearchScreen();
    }
    if (_selectedTabIndex == 3) {
      activeTab = const ProfileScreen();
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kWhiteColor,
        statusBarIconBrightness: Brightness.dark
      ),
      child: Scaffold(
        backgroundColor: kWhiteColor,
        body: activeTab,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: kWhiteColor,
          onTap: _selectTab,
          currentIndex: _selectedTabIndex,
          selectedItemColor: kGreenColor,
          items: [
            BottomNavigationBarItem(
              icon: _selectedTabIndex == 0
                  ? const Icon(Icons.article)
                  : const Icon(Icons.article_outlined),
              label: 'Article',
            ),
            BottomNavigationBarItem(
              icon: _selectedTabIndex == 1
                  ? const Icon(Icons.play_lesson)
                  : const Icon(Icons.play_lesson_outlined),
              label: 'Course',
            ),
            BottomNavigationBarItem(
              icon: _selectedTabIndex == 2
                ? Container (
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: kGreenColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search,
                  color: kWhiteColor,
                  size: 20,
                )
              )
                : const Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: _selectedTabIndex == 3
                  ? const Icon(Icons.person)
                  : const Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ]
        ),
      ),
    );
  }
}