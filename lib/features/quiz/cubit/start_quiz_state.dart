part of 'start_quiz_cubit.dart';

abstract class StartQuizState extends Equatable {
  const StartQuizState();

  @override
  List<Object> get props => [];
}

class StartQuizInitial extends StartQuizState {}

class StartQuizLoading extends StartQuizState {}

class StartQuizCompleted extends StartQuizState {
  final StartQuizResponse startQuizResponse;

  const StartQuizCompleted(this.startQuizResponse);

  @override
  List<Object> get props => [startQuizResponse];
}

class StartQuizError extends StartQuizState {
  final String message;

  const StartQuizError(this.message);
  
  @override
  List<Object> get props => [message];
}