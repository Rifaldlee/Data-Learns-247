part of 'end_quiz_cubit.dart';

abstract class EndQuizState extends Equatable {
  const EndQuizState();

  @override
  List<Object> get props => [];
}

class EndQuizInitial extends EndQuizState {}

class EndQuizLoading extends EndQuizState {}

class EndQuizCompleted extends EndQuizState {
  final EndQuizResponse endQuizResponse;

  const EndQuizCompleted(this.endQuizResponse);

  @override
  List<Object> get props => [endQuizResponse];
}

class EndQuizError extends EndQuizState {
  final String message;

  const EndQuizError(this.message);

  @override
  List<Object> get props => [message];
}