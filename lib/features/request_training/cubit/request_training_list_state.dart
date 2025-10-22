part of 'request_training_list_cubit.dart';

abstract class RequestTrainingListState extends Equatable {
  const RequestTrainingListState();

  @override
  List<Object> get props => [];
}

class RequestTrainingListInitial extends RequestTrainingListState {}

class RequestTrainingListLoading extends RequestTrainingListState {}

class RequestTrainingListCompleted extends RequestTrainingListState {
  final List<RequestTrainingList> requestTrainingList;

  const RequestTrainingListCompleted(this.requestTrainingList);

  @override
  List<Object> get props => [requestTrainingList];
}

class RequestTrainingListError extends RequestTrainingListState {
  final String message;

  const RequestTrainingListError(this.message);

  @override
  List<Object> get props => [message];
}

class RequestTrainingListEmpty extends RequestTrainingListState {
  const RequestTrainingListEmpty();
}