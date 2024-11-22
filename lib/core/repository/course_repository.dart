import 'package:data_learns_247/features/course/data/models/detail_course_model.dart';
import 'package:data_learns_247/features/course/data/response/course_response.dart';
import 'package:data_learns_247/features/course/data/models/list_courses_model.dart';

abstract class CourseRepository {
  Future<List<ListCourses>?> getListCourses();
  Future<Course?> getDetailCourse(String id);
  Future<CourseResponse> enrollCourse(int id);

}