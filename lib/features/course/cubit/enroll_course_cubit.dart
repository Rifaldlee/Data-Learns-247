import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:data_learns_247/core/repository/course_repository.dart';
import 'package:data_learns_247/core/repository/implementation/course_repository_impl.dart';
import 'package:data_learns_247/features/course/data/response/course_response.dart';
import 'package:data_learns_247/features/course/domains/use_cases/enroll_course_use_case.dart';

part 'enroll_course_state.dart';

class EnrollCourseCubit extends Cubit<EnrollCourseState> {
  final CourseRepository _courseRepository = CourseRepositoryImpl();

  EnrollCourseCubit() : super(EnrollCourseInitial());

  void enrollCourse(String id) async {
    try {
      emit(EnrollCourseLoading());

      CourseResponse? enrollCourseResponse = await EnrollCourse(_courseRepository, id.toInt()).call();

      if (!(enrollCourseResponse == null)) {
        emit(EnrollCourseCompleted(enrollCourseResponse));
      } else {
        emit(const EnrollCourseError('Enroll failed'));
      }
    } catch (message) {
      emit(EnrollCourseError(message.toString()));
    }
  }
}
