part of 'list_courses_cubit.dart';

abstract class ListCoursesState {
  const ListCoursesState();

  List<Object> get props => [];
}

class ListCoursesInitial extends ListCoursesState {}

class ListCoursesLoading extends ListCoursesState {}

class ListCoursesCompleted extends ListCoursesState {
  final List<ListCourses> listCourses;

  const ListCoursesCompleted(this.listCourses);

  @override
  List<Object> get props => [listCourses];
}

class ListCoursesError extends ListCoursesState {
  final String message;

  const ListCoursesError(this.message);

  @override
  List<Object> get props => [];
}
