part of 'search_cubit.dart';

abstract class SearchState extends Equatable{
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchCompleted extends SearchState {
  final SearchResult? searchResult;

  const SearchCompleted(this.searchResult);

  @override
  List<Object?> get props => [searchResult];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchEmpty extends SearchState {}
