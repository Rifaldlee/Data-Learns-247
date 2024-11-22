import 'package:data_learns_247/core/repository/course_repository.dart';
import 'package:data_learns_247/features/course/data/models/list_courses_model.dart';

class GetListCourses {
  final CourseRepository _courseRepository;

  GetListCourses(this._courseRepository);

  Future<List<ListCourses>?> call() async {
    return await _courseRepository.getListCourses();
  }
}