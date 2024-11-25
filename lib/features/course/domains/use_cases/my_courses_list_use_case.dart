import 'package:data_learns_247/core/repository/course_repository.dart';
import 'package:data_learns_247/features/course/data/models/my_courses_list_model.dart';

class GetMyCoursesList {
  final CourseRepository _courseRepository;

  GetMyCoursesList(this._courseRepository);

  Future<List<MyCoursesList>?> call() async {
    return await _courseRepository.getMyCoursesList();
  }
}