import 'package:data_learns_247/core/repository/lesson_repository.dart';
import 'package:data_learns_247/features/lesson/data/models/lesson_model.dart';

class GetLesson {
  final String _id;
  final LessonRepository _lessonRepository;

  GetLesson(this._id, this._lessonRepository);

  Future<Lesson?> call() async {
    return await _lessonRepository.getLesson(_id);
  }
}