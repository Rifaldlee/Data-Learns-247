import 'package:data_learns_247/features/article/data/models/detail_article_model.dart';
import 'package:data_learns_247/features/article/data/models/list_articles_model.dart';

abstract class ArticleRepository {
  Future<List<ListArticles>?> getListArticles();
  Future<List<ListArticles>?> getFeaturedArticles();
  Future<List<ListArticles>?> getRecommendedArticles();
  Future<List<ListArticles>?> getTrendingArticles();
  Future<Article?> getDetailArticle(String id);
}