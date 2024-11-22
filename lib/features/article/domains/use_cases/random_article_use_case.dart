import 'dart:math';
import 'package:data_learns_247/core/repository/article_repository.dart';
import 'package:data_learns_247/features/article/data/models/list_articles_model.dart';
import 'package:data_learns_247/features/article/data/models/random_article_model.dart';

class GetRandomArticle {
  final ArticleRepository _articleRepository;

  GetRandomArticle(this._articleRepository);

  Future<RandomArticle?> call() async {
    try {
      // Ambil daftar artikel
      List<ListArticles>? articles = await _articleRepository.getListArticles();

      if (articles != null && articles.isNotEmpty) {
        // Pilih artikel secara acak
        Random random = Random();
        int randomIndex = random.nextInt(articles.length);
        ListArticles selectedArticle = articles[randomIndex];

        // Mapping artikel yang dipilih ke dalam RandomArticle
        return RandomArticle(
          blockGroup: selectedArticle.blockGroup.toString(),
          title: selectedArticle.title.toString(),
          image: selectedArticle.image.toString(),
          tag: selectedArticle.tag.toString(),
          author: selectedArticle.author.toString(),
          authorPhoto: selectedArticle.authorPhoto.toString(),
          dateCreated: selectedArticle.dateCreated.toString(),
          id: selectedArticle.id.toString(),
          hasVideo: selectedArticle.hasVideo,
        );
      } else {
        throw Exception('No articles available');
      }
    } catch (e) {
      rethrow;
    }
  }
}