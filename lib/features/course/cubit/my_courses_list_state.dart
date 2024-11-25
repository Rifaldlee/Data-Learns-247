part of 'my_courses_list_cubit.dart';

abstract class MyCoursesListState {
  const MyCoursesListState();

  List<Object> get props => [];
}

class MyCoursesListInitial extends MyCoursesListState {}

class MyCoursesListLoading extends MyCoursesListState {}

class MyCoursesListCompleted extends MyCoursesListState {
  final List<MyCoursesList> myCoursesList;

  const MyCoursesListCompleted(this.myCoursesList);

  @override
  List<Object> get props => [myCoursesList];
}

class MyCoursesListError extends MyCoursesListState {
  final String message;

  const MyCoursesListError(this.message);

  @override
  List<Object> get props => [];
}
