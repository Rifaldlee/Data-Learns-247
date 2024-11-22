import 'package:data_learns_247/core/repository/article_repository.dart';
import 'package:data_learns_247/features/article/data/models/detail_article_model.dart';

class GetDetailArticle {
  final String _id;
  final ArticleRepository _articleRepository;

  GetDetailArticle(this._id, this._articleRepository);

  Future<Article?> call() async {
    return await _articleRepository.getDetailArticle(_id);
  }
}