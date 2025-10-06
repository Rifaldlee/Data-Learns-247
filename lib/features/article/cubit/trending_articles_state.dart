part of 'trending_articles_cubit.dart';

abstract class TrendingArticlesState extends Equatable {
  const TrendingArticlesState();

  @override
  List<Object> get props => [];
}

class TrendingArticlesInitial extends TrendingArticlesState {}

class TrendingArticlesLoading extends TrendingArticlesState {}

class TrendingArticlesCompleted extends TrendingArticlesState {
  final List<ListArticles> listArticles;

  const TrendingArticlesCompleted(this.listArticles);

  @override
  List<Object> get props => [listArticles];
}

class TrendingArticlesError extends TrendingArticlesState {
  final String message;

  const TrendingArticlesError(this.message);

  @override
  List<Object> get props => [message];
}

class TrendingArticlesEmpty extends TrendingArticlesState {
  const TrendingArticlesEmpty();
}