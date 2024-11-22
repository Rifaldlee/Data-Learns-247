import 'package:bloc/bloc.dart';
import 'package:data_learns_247/core/repository/course_repository.dart';
import 'package:data_learns_247/core/repository/implementation/course_repository_impl.dart';
import 'package:data_learns_247/features/course/data/models/list_courses_model.dart';
import 'package:data_learns_247/features/course/domains/use_cases/list_courses_use_case.dart';

part 'list_courses_state.dart';

class ListCoursesCubit extends Cubit<ListCoursesState> {
  final CourseRepository _courseRepository = CourseRepositoryImpl();

  ListCoursesCubit() : super(ListCoursesInitial());

  Future<void> fetchListCourses() async {
    try {
      emit(ListCoursesLoading());

      List<ListCourses>? listCourse = await GetListCourses(_courseRepository).call();

      if (listCourse!.isEmpty) {
        emit(const ListCoursesError('No data available'));
      } else {
        emit(ListCoursesCompleted(listCourse));
      }
    } catch (e) {
      emit(ListCoursesError(e.toString()));
    }
  }
}
