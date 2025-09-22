part of 'analytic_reels_cubit.dart';

abstract class AnalyticReelsState extends Equatable {
  const AnalyticReelsState();

  @override
  List<Object> get props => [];
}

class AnalyticReelsInitial extends AnalyticReelsState {}

class AnalyticReelsLoading extends AnalyticReelsState {}

class AnalyticReelsCompleted extends AnalyticReelsState {
  final AnalyticResponse analyticData;

  const AnalyticReelsCompleted(this.analyticData);

  @override
  List<Object> get props => [analyticData];
}

class AnalyticReelsError extends AnalyticReelsState {
  final String message;

  const AnalyticReelsError(this.message);

  @override
  List<Object> get props => [message];
}