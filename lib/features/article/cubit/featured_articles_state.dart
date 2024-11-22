part of 'featured_articles_cubit.dart';

abstract class FeaturedArticlesState extends Equatable {
  const FeaturedArticlesState();

  @override
  List<Object> get props => [];
}

class FeaturedArticlesInitial extends FeaturedArticlesState {}

class FeaturedArticlesLoading extends FeaturedArticlesState {}

class FeaturedArticlesCompleted extends FeaturedArticlesState {
  final List<ListArticles> listArticles;

  const FeaturedArticlesCompleted(this.listArticles);

  @override
  List<Object> get props => [listArticles];
}

class FeaturedArticlesError extends FeaturedArticlesState {
  final String message;

  const FeaturedArticlesError(this.message);

  @override
  List<Object> get props => [message];
}