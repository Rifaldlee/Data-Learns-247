part of 'greeting_cubit.dart';

sealed class GreetingState extends Equatable {
  const GreetingState();

  @override
  List<Object> get props => [];
}

class GreetingInitial extends GreetingState {}

class GreetingLoading extends GreetingState {}

class GreetingComplete extends GreetingState {
  final Greeting greeting;

  const GreetingComplete(this.greeting);

  @override
  List<Object> get props => [greeting];
}

class GreetingError extends GreetingState {
  final String message;

  const GreetingError(this.message);

  @override
  List<Object> get props => [message];
}
