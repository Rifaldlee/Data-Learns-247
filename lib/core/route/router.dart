import 'dart:convert';
import 'package:data_learns_247/features/article/ui/screens/detail_content_screen.dart';
import 'package:data_learns_247/features/request_training/ui/screens/detail_request_training_screen.dart';
import 'package:data_learns_247/features/request_training/ui/screens/list_request_training_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/features/article/ui/screens/detail_article_screen.dart';
import 'package:data_learns_247/features/authentication/ui/screens/login_screen.dart';
import 'package:data_learns_247/features/authentication/ui/screens/register_screen.dart';
import 'package:data_learns_247/features/chatbot/ui/screens/chatbot_screen.dart';
import 'package:data_learns_247/features/course/ui/screens/detail_course_screen.dart';
import 'package:data_learns_247/features/lesson/ui/screens/list_lessons_screen.dart';
import 'package:data_learns_247/features/lesson/ui/screens/lesson_screen.dart';
import 'package:data_learns_247/features/reels/ui/screens/detail_reels_screen.dart';
import 'package:data_learns_247/features/search/ui/screens/search_screen.dart';
import 'package:data_learns_247/features/search/ui/screens/search_result_screen.dart';
import 'package:data_learns_247/features/quiz/ui/screens/attempt_detail_screen.dart';
import 'package:data_learns_247/features/quiz/ui/screens/quiz_information_screen.dart';
import 'package:data_learns_247/features/quiz/ui/screens/quiz_screen.dart';
import 'package:data_learns_247/features/quiz/data/models/quiz_result_model.dart';
import 'package:data_learns_247/features/quiz/ui/screens/quiz_result_screen.dart';
import 'package:data_learns_247/features/certificate/ui/screens/certificate_screen.dart';
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
              name: RouteConstants.certificate,
              path: 'certificate',
              pageBuilder: (context, state) {
                return const MaterialPage(child: CertificateScreen());
              }
            ),
            GoRoute(
              name: RouteConstants.listTrainingRequest,
              path: 'listRequestTraining',
              pageBuilder: (context, state) {
                return const MaterialPage(child: RequestTrainingListScreen());
              },
              routes: [
                GoRoute(
                  name: RouteConstants.detailTrainingRequest,
                  path: 'detailRequestTraining',
                  pageBuilder: (context, state) {
                    final requestTrainingId = state.uri.queryParameters['requestTrainingId']!;
                    return MaterialPage(child: RequestTrainingDetailScreen(id: requestTrainingId));
                  }
                )
              ]
            ),
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
              name: RouteConstants.detailContent,
              path: 'detailContent/:id',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id']!;
                return MaterialPage(child: DetailContentScreen(id: id));
              },
            ),
            GoRoute(
              name: RouteConstants.detailCourse,
              path: 'detailCourse',
              pageBuilder: (context, state) {
                final courseId = state.uri.queryParameters['courseId']!;
                return MaterialPage(child: DetailCourseScreen(courseId: courseId));
              },
              routes: [
                GoRoute(
                  name: RouteConstants.listLessons,
                  path: 'listLessons',
                  pageBuilder: (context, state) {
                    final courseId = state.uri.queryParameters['courseId']!;
                    return MaterialPage(child: ListLessonsScreen(courseId: courseId));
                  },
                  routes: [
                    GoRoute(
                      name: RouteConstants.lessonScreen,
                      path: 'lessonScreen',
                      pageBuilder: (context, state) {
                        final lessonId = state.uri.queryParameters['lessonId']!;
                        final courseId = state.uri.queryParameters['courseId']!;
                        final chatbotId = state.uri.queryParameters['chatbotId']!;
                        return MaterialPage(
                          child: LessonScreen(
                            lessonId: lessonId,
                            courseId: courseId,
                            chatbotId: chatbotId,
                          ),
                        );
                      },
                      routes: [
                        GoRoute(
                          name: RouteConstants.quizInformation,
                          path: 'quizInformation',
                          pageBuilder: (context, state) {
                            final quizId = state.uri.queryParameters['quizId']!;
                            final lessonId = state.uri.queryParameters['lessonId']!;
                            final courseId = state.uri.queryParameters['courseId']!;
                            final chatbotId = state.uri.queryParameters['chatbotId']!;
                            return MaterialPage(
                              child: QuizInformationScreen(
                                quizId: quizId,
                                lessonId: lessonId,
                                courseId: courseId,
                                chatbotId: chatbotId,
                              )
                            );
                          },
                          routes: [
                            GoRoute(
                              name: RouteConstants.quizScreen,
                              path: 'quizScreen',
                              pageBuilder: (context, state) {
                                final lessonId = state.uri.queryParameters['lessonId']!;
                                final courseId = state.uri.queryParameters['courseId']!;
                                final chatbotId = state.uri.queryParameters['chatbotId']!;
                                return MaterialPage(
                                  child: QuizScreen(
                                    lessonId: lessonId,
                                    courseId: courseId,
                                    chatbotId: chatbotId,
                                  )
                                );
                              },
                              routes: [
                                GoRoute(
                                  name: RouteConstants.quizResult,
                                  path: 'quizResult',
                                  pageBuilder: (context, state) {
                                    final quizResultJson = state.uri.queryParameters['quizResult']!;
                                    final quizResultMap = jsonDecode(quizResultJson) as Map<String, dynamic>;
                                    final quizResult = QuizResult.fromJson(quizResultMap);
                                    return MaterialPage(child: QuizResultScreen(quizResult: quizResult));
                                  }
                                )
                              ]
                            ),
                            GoRoute(
                              name: RouteConstants.attemptDetail,
                              path: 'attemptDetail',
                              pageBuilder: (context, state) {
                                final attemptId = state.uri.queryParameters['attemptId']!;
                                final lessonId = state.uri.queryParameters['lessonId']!;
                                final courseId = state.uri.queryParameters['courseId']!;
                                final chatbotId = state.uri.queryParameters['chatbotId']!;
                                return MaterialPage(
                                  child: AttemptDetailScreen(
                                    attemptId: attemptId,
                                    lessonId: lessonId,
                                    courseId: courseId,
                                    chatbotId: chatbotId,
                                  )
                                );
                              }
                            ),
                          ]
                        )
                      ]
                    ),
                    GoRoute(
                      name: RouteConstants.chatScreen,
                      path: 'chatScreen',
                      pageBuilder: (context, state) {
                        final chatbotId = state.uri.queryParameters['chatbotId']!;
                        final courseId = state.uri.queryParameters['courseId']!;
                        return MaterialPage(
                          child: ChatbotScreen(
                            chatbotId: chatbotId,
                            courseId: courseId
                          ),
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