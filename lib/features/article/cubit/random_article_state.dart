part of 'random_article_cubit.dart';

abstract class RandomArticleState extends Equatable {
  const RandomArticleState();

  @override
  List<Object> get props => [];
}

class RandomArticleInitial extends RandomArticleState {}

class RandomArticleLoading extends RandomArticleState {}

class RandomArticleCompleted extends RandomArticleState {
  final RandomArticle randomArticle;

  const RandomArticleCompleted(this.randomArticle);

  @override
  List<Object> get props => [randomArticle];
}

class RandomArticleError extends RandomArticleState {
  final String message;

  const RandomArticleError(this.message);

  @override
  List<Object> get props => [message];
}
