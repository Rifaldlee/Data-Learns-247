import 'package:data_learns_247/core/repository/article_repository.dart';
import 'package:data_learns_247/features/article/data/models/list_articles_model.dart';

class GetListArticles {
  final ArticleRepository _articleRepository;

  GetListArticles(this._articleRepository);

  Future<List<ListArticles>?> call() async {
    return await _articleRepository.getListArticles();
  }
}