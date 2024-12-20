part of 'detail_reels_cubit.dart';

abstract class DetailReelsState extends Equatable {
  const DetailReelsState();

  @override
  List<Object> get props => [];
}

class DetailReelsInitial extends DetailReelsState {}

class DetailReelsLoading extends DetailReelsState {}

class DetailReelsCompleted extends DetailReelsState {
  final DetailReels detailReels;

  const DetailReelsCompleted(this.detailReels);

  @override
  List<Object> get props => [detailReels];
}

class DetailReelsError extends DetailReelsState {
  final String message;

  const DetailReelsError(this.message);

  @override
  List<Object> get props => [message];
}
