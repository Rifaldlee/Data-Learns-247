import 'package:data_learns_247/core/repository/lesson_repository.dart';
import 'package:data_learns_247/features/course/data/response/course_response.dart';

class FinishLesson {
  final int _id;
  final LessonRepository _lessonRepository;

  FinishLesson(this._lessonRepository, this._id);

  Future<CourseResponse?> call() async {
    return await _lessonRepository.finishLesson(_id);
  }
}