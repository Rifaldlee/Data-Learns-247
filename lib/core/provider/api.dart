class API {
  API._();

  static const publicBaseAPI = 'http://82.112.234.17/wp-json/wp/v2/';

  static const search = 'search';

  static const featuredArticles = 'featured-contents';
  static const recommendedArticles = 'recommended-contents';
  static const trendingArticles = 'trending-contents';
  static const listArticles = 'list-contents';
  static const detailArticle = 'content';

  static const listCourses = 'list-courses';
  static const detailCourse = 'course';
  static const enrollCourse = 'courses/enroll';
  static const myCourses = 'my-courses';

  static const lesson = 'lesson';
  static const finishLesson = 'lessons/finish';

  static const login = '?rest_route=/api-login/v1/auth';
  static const register = 'users/register';
  static String user(String id) => 'users/$id';
}