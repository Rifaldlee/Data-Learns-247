part of 'detail_article_cubit.dart';

abstract class DetailArticleState extends Equatable {
  const DetailArticleState();

  @override
  List<Object> get props => [];
}

class DetailArticleInitial extends DetailArticleState {}

class DetailArticleLoading extends DetailArticleState {}

class DetailArticleCompleted extends DetailArticleState {
  final Article detailArticle;

  const DetailArticleCompleted(this.detailArticle);

  @override
  List<Object> get props => [detailArticle];
}

class DetailArticleError extends DetailArticleState {
  final String message;

  const DetailArticleError(this.message);

  @override
  List<Object> get props => [message];
}