import 'package:data_learns_247/core/repository/article_repository.dart';
import 'package:data_learns_247/features/article/data/models/list_articles_model.dart';

class GetTrendingArticles {
  final ArticleRepository _articleRepository;

  GetTrendingArticles(this._articleRepository);

  Future<List<ListArticles>?> call() async {
    return await _articleRepository.getTrendingArticles();
  }
}