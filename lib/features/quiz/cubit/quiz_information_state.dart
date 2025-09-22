part of 'quiz_information_cubit.dart';

abstract class QuizInformationState extends Equatable {
  const QuizInformationState();

  @override
  List<Object> get props => [];
}

class QuizInformationInitial extends QuizInformationState {}

class QuizInformationLoading extends QuizInformationState {}

class QuizInformationCompleted extends QuizInformationState {
  final QuizInformation quizInformation;

  const QuizInformationCompleted(this.quizInformation);

  @override
  List<Object> get props => [quizInformation];
}

class QuizInformationError extends QuizInformationState {
  final String message;

  const QuizInformationError(this.message);

  @override
  List<Object> get props => [message];
}