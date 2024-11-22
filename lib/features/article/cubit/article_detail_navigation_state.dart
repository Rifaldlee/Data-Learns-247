part of 'article_detail_navigation_cubit.dart';

sealed class ArticleDetailNavigationState {
  final List<ArticleHistoryItem> history;

  ArticleDetailNavigationState({required this.history});
}

final class ArticleDetailNavigationInitial extends ArticleDetailNavigationState {
  ArticleDetailNavigationInitial({required super.history});
}

final class ArticleDetailNavigationUpdated extends ArticleDetailNavigationState {
  ArticleDetailNavigationUpdated({required super.history});
}