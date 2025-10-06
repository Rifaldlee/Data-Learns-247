import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:data_learns_247/core/repository/article_repository.dart';
import 'package:data_learns_247/core/repository/implementation/article_repository_impl.dart';
import 'package:data_learns_247/features/article/data/models/list_articles_model.dart';
import 'package:data_learns_247/features/article/domains/use_cases/recommended_article_use_case.dart';

part 'recommended_articles_state.dart';

class RecommendedArticlesCubit extends Cubit<RecommendedArticlesState> {
  final ArticleRepository _articleRepository = ArticleRepositoryImpl();

  RecommendedArticlesCubit() : super(RecommendedArticlesInitial());

  Future<void> fetchRecommendedArticles() async {
    try {
      emit(RecommendedArticlesLoading());

      List<ListArticles>? recommendedArticle = await GetRecommendedArticles(_articleRepository).call();

      if (recommendedArticle == null || recommendedArticle.isEmpty) {
        emit(const RecommendedArticlesEmpty());
      } else {
        emit(RecommendedArticlesCompleted(recommendedArticle));
      }
    } catch (e) {
      emit(RecommendedArticlesError(e.toString()));
    }
  }
}
