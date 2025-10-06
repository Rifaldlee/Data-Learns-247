import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:data_learns_247/core/repository/article_repository.dart';
import 'package:data_learns_247/core/repository/implementation/article_repository_impl.dart';
import 'package:data_learns_247/features/article/data/models/list_articles_model.dart';
import 'package:data_learns_247/features/article/domains/use_cases/trending_article_use_case.dart';

part 'featured_articles_state.dart';

class FeaturedArticlesCubit extends Cubit<FeaturedArticlesState> {
  final ArticleRepository _articleRepository = ArticleRepositoryImpl();

  FeaturedArticlesCubit() : super(FeaturedArticlesInitial());

  Future<void> fetchFeaturedArticles() async {
    try {
      emit(FeaturedArticlesLoading());

      List<ListArticles>? featuredArticle = await GetFeaturedArticles(_articleRepository).call();

      if (featuredArticle == null || featuredArticle.isEmpty) {
        emit(const FeaturedArticlesEmpty());
      } else {
        emit(FeaturedArticlesCompleted(featuredArticle));
      }
    } catch (e) {
      emit(FeaturedArticlesError(e.toString()));
    }
  }
}