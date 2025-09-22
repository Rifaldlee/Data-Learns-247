part of 'attempt_detail_cubit.dart';

abstract class AttemptDetailState extends Equatable {
  const AttemptDetailState();

  @override
  List<Object> get props => [];
}

class AttemptDetailInitial extends AttemptDetailState {}

class AttemptDetailLoading extends AttemptDetailState {}

class AttemptDetailCompleted extends AttemptDetailState {
  final Attempt attempt;

  const AttemptDetailCompleted(this.attempt);

  @override
  List<Object> get props => [attempt];
}

class AttemptDetailError extends AttemptDetailState {
  final String message;

  const AttemptDetailError(this.message);

  @override
  List<Object> get props => [message];
}