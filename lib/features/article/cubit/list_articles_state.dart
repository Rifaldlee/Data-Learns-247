part of 'list_articles_cubit.dart';

abstract class ListArticlesState extends Equatable {
  const ListArticlesState();

  @override
  List<Object> get props => [];
}

class ListArticlesInitial extends ListArticlesState {}

class ListArticlesLoading extends ListArticlesState {}

class ListArticlesCompleted extends ListArticlesState {
  final List<ListArticles> listArticles;

  const ListArticlesCompleted(this.listArticles);

  @override
  List<Object> get props => [listArticles];
}

class ListArticlesError extends ListArticlesState {
  final String message;

  const ListArticlesError(this.message);

  @override
  List<Object> get props => [message];
}

class ListArticlesEmpty extends ListArticlesState {
  const ListArticlesEmpty();
}