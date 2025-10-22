class API {
  API._();

  static const publicBaseAPI = 'https://learn.solusi247.com:9991/wp-json/wp/v2/';
  static const chatbotBaseUrl = 'http://82.112.234.17:3000/api/v1/prediction/';

  static const search = 'search';

  static const featuredContents = 'featured-contents';
  static const recommendedContents = 'recommended-contents';
  static const trendingContents = 'trending-contents';
  static const listContents = 'list-contents';
  static const detailContent = 'content';

  static const listCourses = 'list-courses';
  static const detailCourse = 'course';
  static const enrollCourse = 'courses/enroll';
  static const myCourses = 'my-courses';

  static const lesson = 'lesson';
  static const finishLesson = 'lessons/finish';

  static const listReels = 'list-reels';
  static const detailReels = 'reels';
  static const analyticReels = 'reels-analytics';

  static const quizInformation = 'quiz-information';
  static const startQuiz = 'start-quiz';
  static const endQuiz = 'end-quiz';
  static const quizAttempt = 'attempt-detail';

  static const certificate = 'certificate';

  static const greetingImage = 'greeting';

  static const requestTrainingList = 'requests';
  static const requestTrainingDetail = 'request';

  static const login = '?rest_route=/api-login/v1/auth';
  static const register = 'users/register';
  static String user(String id) => 'users/$id';
}