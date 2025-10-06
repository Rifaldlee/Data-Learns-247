part of 'list_reels_cubit.dart';

abstract class ListReelsState extends Equatable {
  const ListReelsState();

  @override
  List<Object> get props => [];
}

class ListReelsInitial extends ListReelsState {}

class ListReelsLoading extends ListReelsState {}

class ListReelsCompleted extends ListReelsState {
  final List<ListReels> listReels;

  const ListReelsCompleted(this.listReels);

  @override
  List<Object> get props => [listReels];
}

class ListReelsError extends ListReelsState {
  final String message;

  const ListReelsError(this.message);

  @override
  List<Object> get props => [message];
}

class ListReelsEmpty extends ListReelsState {
  const ListReelsEmpty();
}