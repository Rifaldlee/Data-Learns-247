import 'package:data_learns_247/core/repository/course_repository.dart';
import 'package:data_learns_247/features/course/data/models/detail_course_model.dart';

class GetDetailCourse {
  final String _id;
  final CourseRepository _curseRepository;

  GetDetailCourse(this._id, this._curseRepository);

  Future<Course?> call() async {
    return await _curseRepository.getDetailCourse(_id);
  }
}