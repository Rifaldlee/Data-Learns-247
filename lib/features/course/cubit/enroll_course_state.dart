part of 'enroll_course_cubit.dart';

abstract class EnrollCourseState extends Equatable {
  const EnrollCourseState();

  @override
  List<Object> get props => [];
}

class EnrollCourseInitial extends EnrollCourseState {}

class EnrollCourseLoading extends EnrollCourseState {}

class EnrollCourseCompleted extends EnrollCourseState {
  final CourseResponse courseResponse;

  const EnrollCourseCompleted(this.courseResponse);

  @override
  List<Object> get props => [courseResponse];
}

class EnrollCourseError extends EnrollCourseState {
  final String message;

  const EnrollCourseError(this.message);

  @override
  List<Object> get props => [message];
}
