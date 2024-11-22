import 'package:data_learns_247/features/course/data/response/course_response.dart';
import 'package:data_learns_247/features/lesson/data/models/lesson_model.dart';

abstract class LessonRepository {
  Future<Lesson?> getLesson(String id);
  Future<CourseResponse> finishLesson(int id);
}