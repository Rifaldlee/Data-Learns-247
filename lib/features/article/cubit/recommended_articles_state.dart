part of 'recommended_articles_cubit.dart';

abstract class RecommendedArticlesState extends Equatable {
  const RecommendedArticlesState();

  @override
  List<Object> get props => [];
}

class RecommendedArticlesInitial extends RecommendedArticlesState {}

class RecommendedArticlesLoading extends RecommendedArticlesState {}

class RecommendedArticlesCompleted extends RecommendedArticlesState {
  final List<ListArticles> listArticles;

  const RecommendedArticlesCompleted(this.listArticles);

  @override
  List<Object> get props => [listArticles];
}

class RecommendedArticlesError extends RecommendedArticlesState {
  final String message;

  const RecommendedArticlesError(this.message);

  @override
  List<Object> get props => [message];
}