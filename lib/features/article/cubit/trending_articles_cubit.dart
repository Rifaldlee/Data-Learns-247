import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:data_learns_247/core/repository/article_repository.dart';
import 'package:data_learns_247/core/repository/implementation/article_repository_impl.dart';
import 'package:data_learns_247/features/article/data/models/list_articles_model.dart';
import 'package:data_learns_247/features/article/domains/use_cases/featured_article_use_case.dart';

part 'trending_articles_state.dart';

class TrendingArticlesCubit extends Cubit<TrendingArticlesState> {
  final ArticleRepository _articleRepository = ArticleRepositoryImpl();

  TrendingArticlesCubit() : super(TrendingArticlesInitial());

  Future<void> fetchTrendingArticles() async {
    try {
      emit(TrendingArticlesLoading());

      List<ListArticles>? trendingArticle = await GetTrendingArticles(_articleRepository).call();

      if (trendingArticle == null || trendingArticle.isEmpty) {
        emit(const TrendingArticlesEmpty());
      } else {
        emit(TrendingArticlesCompleted(trendingArticle));
      }
    } catch (e) {
      emit(TrendingArticlesError(e.toString()));
    }
  }
}
