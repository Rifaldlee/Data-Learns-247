import 'package:data_learns_247/core/repository/course_repository.dart';
import 'package:data_learns_247/features/course/data/response/course_response.dart';

class EnrollCourse {
  final int _id;
  final CourseRepository _courseRepository;

  EnrollCourse(this._courseRepository, this._id);

  Future<CourseResponse?> call() async {
    return await _courseRepository.enrollCourse(_id);
  }
}