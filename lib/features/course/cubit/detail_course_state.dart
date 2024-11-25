part of 'detail_course_cubit.dart';

abstract class DetailCourseState {
  const DetailCourseState();

  List<Object> get props => [];
}

class DetailCourseInitial extends DetailCourseState {}

class DetailCourseLoading extends DetailCourseState {}

class DetailCourseCompleted extends DetailCourseState {
  final Course detailCourse;

  const DetailCourseCompleted(this.detailCourse);

  @override
  List<Object> get props => [detailCourse];
}

class DetailCourseError extends DetailCourseState {
  final String message;

  const DetailCourseError(this.message);

  @override
  List<Object> get props => [];
}
