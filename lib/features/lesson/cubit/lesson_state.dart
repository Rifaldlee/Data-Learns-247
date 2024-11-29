part of 'lesson_cubit.dart';

abstract class LessonState {
  const LessonState();

  List<Object> get props => [];
}

class LessonInitial extends LessonState {}

class LessonLoading extends LessonState {}

class LessonCompleted extends LessonState {
  final Lesson lesson;
  final bool isComplete;

  const LessonCompleted(this.lesson, this.isComplete);

  @override
  List<Object> get props => [lesson];

  LessonCompleted copyWith({
    Lesson? lesson,
    bool? isComplete
  }) {
    return LessonCompleted(
      lesson ?? this.lesson,
      isComplete ?? this.isComplete
    );
  }
}

class LessonError extends LessonState {
  final String message;

  const LessonError(this.message);

  @override
  List<Object> get props => [];
}