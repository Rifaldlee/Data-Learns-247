import 'package:data_learns_247/features/course/cubit/my_courses_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:data_learns_247/core/route/router.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 15));
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
        BlocProvider(create: (context) => CourseSectionsCubit())
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Data Learn 247',
        routerConfig: AppRouter(navigatorKey).router,
      ),
    );
  }
}