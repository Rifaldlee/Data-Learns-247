part of 'request_training_detail_cubit.dart';

abstract class RequestTrainingDetailState extends Equatable {
  const RequestTrainingDetailState();

  @override
  List<Object> get props => [];
}

class RequestTrainingDetailInitial extends RequestTrainingDetailState {}

class RequestTrainingDetailLoading extends RequestTrainingDetailState {}

class RequestTrainingDetailCompleted extends RequestTrainingDetailState {
  final RequestTrainingDetail requestTrainingDetail;

  const RequestTrainingDetailCompleted(this.requestTrainingDetail);

  @override
  List<Object> get props => [requestTrainingDetail];
}

class RequestTrainingDetailError extends RequestTrainingDetailState {
  final String message;

  const RequestTrainingDetailError(this.message);

  @override
  List<Object> get props => [message];
}