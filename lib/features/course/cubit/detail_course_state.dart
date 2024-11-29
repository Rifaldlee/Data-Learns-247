part of 'detail_course_cubit.dart';

abstract class DetailCourseState {
  const DetailCourseState();

  List<Object> get props => [];
}

class DetailCourseInitial extends DetailCourseState {}

class DetailCourseLoading extends DetailCourseState {}

class DetailCourseCompleted extends DetailCourseState {
  final Course detailCourse;
  final bool isEnrolled;

  const DetailCourseCompleted(this.detailCourse, this.isEnrolled);

  @override
  List<Object> get props => [detailCourse];

  DetailCourseCompleted copyWith({
    Course? detailCourse,
    bool? isEnrolled,
  }) {
    return DetailCourseCompleted(
      detailCourse ?? this.detailCourse,
      isEnrolled ?? this.isEnrolled,
    );
  }
}

class DetailCourseError extends DetailCourseState {
  final String message;

  const DetailCourseError(this.message);

  @override
  List<Object> get props => [];
}
