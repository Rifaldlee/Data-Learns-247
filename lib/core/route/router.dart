import 'package:data_learns_247/features/reels/ui/screens/detail_reels_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/features/article/ui/screens/detail_article_screen.dart';
import 'package:data_learns_247/features/authentication/ui/screens/login_screen.dart';
import 'package:data_learns_247/features/authentication/ui/screens/register_screen.dart';
import 'package:data_learns_247/features/course/ui/screens/detail_course_screen.dart';
import 'package:data_learns_247/features/lesson/ui/screens/list_lessons_screen.dart';
import 'package:data_learns_247/features/lesson/ui/screens/lesson_screen.dart';
import 'package:data_learns_247/features/search/ui/screens/search_screen.dart';
import 'package:data_learns_247/features/search/ui/screens/search_result_screen.dart';
import 'package:data_learns_247/shared_ui/screens/main_front_page.dart';
import 'package:data_learns_247/shared_ui/screens/splash_screen.dart';

class AppRouter {
  final GlobalKey<NavigatorState> globalNavigatorKey;
  late final GoRouter router;

  AppRouter(this.globalNavigatorKey) {
    router = GoRouter(
      navigatorKey: globalNavigatorKey,
      routes: [
        GoRoute(
          name: RouteConstants.splash,
          path: '/',
          pageBuilder: (context, state) {
            return const MaterialPage(child: SplashScreen());
          }
        ),
        GoRoute(
          name: RouteConstants.login,
          path: '/login',
          pageBuilder: (context, state) {
            return const MaterialPage(child: LoginScreen());
          }
        ),
        GoRoute(
          name: RouteConstants.register,
          path: '/register',
          pageBuilder: (context, state) {
            return const MaterialPage(child: RegisterScreen());
          }
        ),
        GoRoute(
          name: RouteConstants.mainFrontPage,
          path: '/mainFrontPage',
          pageBuilder: (context, state) {
            return const MaterialPage(child: MainFrontPage());
          },
          routes: [
            GoRoute(
              name:  RouteConstants.searchScreen,
              path: 'searchScreen/:previous_tab_index',
              pageBuilder: (context, state) {
                final previousTabIndex = state.pathParameters['previous_tab_index'];
                return MaterialPage(child: SearchScreen(previousTabIndex: previousTabIndex.toInt()));
              },
              routes: [
                GoRoute(
                  name: RouteConstants.searchResult,
                  path: 'searchResult/:query/:initial_tab_index',
                  pageBuilder: (context, state) {
                    final query = state.pathParameters['query']!;
                    final initialTabIndex = state.pathParameters['initial_tab_index'];
                    return MaterialPage(child: SearchResultScreen(
                      query: query,
                      initialTabIndex: initialTabIndex.toInt(),
                    ));
                  },
                ),
              ],
            ),
            GoRoute(
              name: RouteConstants.detailArticle,
              path: 'detailArticle/:id/:has_video',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id']!;
                final hasVideo = state.pathParameters['has_video'].toBool();
                return MaterialPage(child: DetailArticleScreen(id: id, hasVideo: hasVideo));
              },
            ),
            GoRoute(
              name: RouteConstants.detailCourse,
              path: '/detailCourse/:id',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id']!;
                return MaterialPage(child: DetailCourseScreen(id: id));
              },
              routes: [
                GoRoute(
                  name: RouteConstants.listLessons,
                  path: 'listLessons',
                  pageBuilder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return MaterialPage(child: ListLessonsScreen(id: id));
                  },
                  routes: [
                    GoRoute(
                      name: RouteConstants.lessonScreen,
                      path: 'lessonScreen/:lessonId',
                      pageBuilder: (context, state) {
                        final lessonId = state.pathParameters['lessonId']!;
                        final courseId = state.pathParameters['id']!;
                        return MaterialPage(
                          child: LessonScreen(id: lessonId, courseId: courseId),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              name: RouteConstants.detailReels,
              path: '/detailReels/:id',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id']!;
                return MaterialPage(child: DetailReelsScreen(id: id));
              }
            )
          ],
        ),
      ],
    );
  }
}