import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:data_learns_247/core/route/router.dart';
import 'package:data_learns_247/core/route/page_cubit.dart';
import 'package:data_learns_247/core/utils/shared_pref_util.dart';
import 'package:data_learns_247/features/article/cubit/article_detail_navigation_cubit.dart';
import 'package:data_learns_247/features/article/cubit/detail_article_cubit.dart';
import 'package:data_learns_247/features/article/cubit/featured_articles_cubit.dart';
import 'package:data_learns_247/features/article/cubit/list_articles_cubit.dart';
import 'package:data_learns_247/features/article/cubit/random_article_cubit.dart';
import 'package:data_learns_247/features/article/cubit/recommended_articles_cubit.dart';
import 'package:data_learns_247/features/course/cubit/enroll_course_cubit.dart';
import 'package:data_learns_247/features/lesson/cubit/finish_lesson_cubit.dart';
import 'package:data_learns_247/features/lesson/cubit/lesson_cubit.dart';
import 'package:data_learns_247/features/search/cubit/search_cubit.dart';
import 'package:data_learns_247/features/article/cubit/trending_articles_cubit.dart';
import 'package:data_learns_247/features/authentication/cubit/login_cubit.dart';
import 'package:data_learns_247/features/authentication/cubit/register_cubit.dart';
import 'package:data_learns_247/features/authentication/cubit/user_cubit.dart';
import 'package:data_learns_247/features/course/cubit/detail_course_cubit.dart';
import 'package:data_learns_247/features/course/cubit/list_courses_cubit.dart';
import 'package:data_learns_247/features/course/cubit/course_sections_cubit.dart';
import 'package:data_learns_247/features/course/cubit/my_courses_list_cubit.dart';
import 'package:data_learns_247/features/reels/cubit/detail_reels_cubit.dart';
import 'package:data_learns_247/features/reels/cubit/list_reels_cubit.dart';
import 'package:data_learns_247/features/reels/cubit/analytic_reels_cubit.dart';
import 'package:data_learns_247/features/quiz/cubit/attempt_detail_cubit.dart';
import 'package:data_learns_247/features/quiz/cubit/end_quiz_cubit.dart';
import 'package:data_learns_247/features/quiz/cubit/quiz_information_cubit.dart';
import 'package:data_learns_247/features/quiz/cubit/start_quiz_cubit.dart';
import 'package:data_learns_247/features/quiz/cubit/quiz_logic_cubit.dart';
import 'package:data_learns_247/features/certificate/cubit/certificate_cubit.dart';
import 'package:data_learns_247/features/greeting/cubit/greeting_cubit.dart';
import 'package:data_learns_247/features/request_training/cubit/request_training_detail_cubit.dart';
import 'package:data_learns_247/features/request_training/cubit/request_training_list_cubit.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 15));
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("b77e9ec6-1908-4933-bd5c-b11243f99aa3");
  OneSignal.Notifications.requestPermission(true);

  OneSignal.Notifications.addClickListener((event) {
    final additionalData = event.notification.additionalData;
    if (additionalData != null) {
      SharedPrefUtil.storeNotificationData(additionalData);
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PageCubit()),
        BlocProvider(create: (context) => SearchCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => UserCubit()),
        BlocProvider(create: (context) => ListArticlesCubit()),
        BlocProvider(create: (context) => FeaturedArticlesCubit()),
        BlocProvider(create: (context) => RecommendedArticlesCubit()),
        BlocProvider(create: (context) => TrendingArticlesCubit()),
        BlocProvider(create: (context) => RandomArticleCubit()),
        BlocProvider(create: (context) => DetailArticleCubit()),
        BlocProvider(create: (context) => ArticleDetailNavigationCubit()),
        BlocProvider(create: (context) => ListCoursesCubit()),
        BlocProvider(create: (context) => MyCoursesListCubit()),
        BlocProvider(create: (context) => DetailCourseCubit()),
        BlocProvider(create: (context) => EnrollCourseCubit()),
        BlocProvider(create: (context) => LessonCubit()),
        BlocProvider(create: (context) => FinishLessonCubit()),
        BlocProvider(create: (context) => CourseSectionsCubit()),
        BlocProvider(create: (context) => ListReelsCubit()),
        BlocProvider(create: (context) => DetailReelsCubit()),
        BlocProvider(create: (context) => AnalyticReelsCubit()),
        BlocProvider(create: (context) => QuizInformationCubit()),
        BlocProvider(create: (context) => StartQuizCubit()),
        BlocProvider(create: (context) => EndQuizCubit()),
        BlocProvider(create: (context) => AttemptDetailCubit()),
        BlocProvider(create: (context) => QuizLogicCubit()),
        BlocProvider(create: (context) => CertificateCubit()),
        BlocProvider(create: (context) => GreetingCubit()),
        // BlocProvider(create: (context) => RequestTrainingListCubit()),
        // BlocProvider(create: (context) => RequestTrainingDetailCubit())
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Data Learn 247',
        routerConfig: AppRouter(navigatorKey).router,
      )
    );
  }
}