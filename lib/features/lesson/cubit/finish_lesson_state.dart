part of 'finish_lesson_cubit.dart';

abstract class FinishLessonState extends Equatable {
  const FinishLessonState();

  @override
  List<Object> get props => [];
}

class FinishLessonInitial extends FinishLessonState {}

class FinishLessonLoading extends FinishLessonState {}

class FinishLessonCompleted extends FinishLessonState {
  final CourseResponse courseResponse;

  const FinishLessonCompleted(this.courseResponse);

  @override
  List<Object> get props => [courseResponse];
}

class FinishLessonError extends FinishLessonState {
  final String message;

  const FinishLessonError(this.message);

  @override
  List<Object> get props => [message];
}
