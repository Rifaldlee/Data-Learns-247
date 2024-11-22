part of 'lesson_cubit.dart';

abstract class LessonState {
  const LessonState();

  List<Object> get props => [];
}

class LessonInitial extends LessonState {}

class LessonLoading extends LessonState {}

class LessonCompleted extends LessonState {
  final Lesson lesson;

  const LessonCompleted(this.lesson);

  @override
  List<Object> get props => [];
}

class LessonError extends LessonState {
  final String message;

  const LessonError(this.message);

  @override
  List<Object> get props => [];
}