import 'package:bloc/bloc.dart';
import 'package:data_learns_247/core/repository/course_repository.dart';
import 'package:data_learns_247/core/repository/implementation/course_repository_impl.dart';
import 'package:data_learns_247/features/course/data/models/detail_course_model.dart';
import 'package:data_learns_247/features/course/domains/use_cases/detail_course_use_case.dart';

part 'detail_course_state.dart';

class DetailCourseCubit extends Cubit<DetailCourseState> {
  final CourseRepository _courseRepository = CourseRepositoryImpl();

  DetailCourseCubit() : super(DetailCourseInitial());

  Future<void> fetchDetailCourse(String id) async {
    try {
      emit(DetailCourseLoading());

      Course? detailCourse = await GetDetailCourse(id, _courseRepository).call();

      if (detailCourse != null) {
        emit(DetailCourseCompleted(detailCourse, detailCourse.isEnrolled ?? false));
      } else {
        emit(const DetailCourseError('No data available'));
      }
    } catch(e) {
      emit(DetailCourseError(e.toString()));
    }
  }

  void updateEnrollment(bool isEnrolled) {
    final currentState = state;
    if (currentState is DetailCourseCompleted) {
      emit(currentState.copyWith(isEnrolled: isEnrolled));
    }
  }
}
