import 'package:data_learns_247/core/provider//api.dart';
import 'package:data_learns_247/core/provider/network_helper.dart';
import 'package:data_learns_247/core/provider/network_service.dart';
import 'package:data_learns_247/core/provider/query_parameter.dart';
import 'package:data_learns_247/core/repository/article_repository.dart';
import 'package:data_learns_247/features/article/data/models/detail_article_model.dart';
import 'package:data_learns_247/features/article/data/models/list_articles_model.dart';

class ArticleRepositoryImpl extends ArticleRepository{

  @override
  Future<List<ListArticles>?> getListArticles() async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        baseUrl: API.publicBaseAPI,
        endpoint: API.listContents,
        useBearer: true
      );
      return NetworkHelper.filterResponse(
        callBack: (json) => (json as List)
          .map((e) => ListArticles.fromJson(e as Map<String, dynamic>))
          .toList(),
        response: response
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ListArticles>?> getFeaturedArticles() async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        baseUrl: API.publicBaseAPI,
        endpoint: API.featuredContents,
        useBearer: true
      );
      return NetworkHelper.filterResponse(
        callBack: (json) => (json as List)
          .map((e) => ListArticles.fromJson(e as Map<String, dynamic>))
          .toList(),
        response: response
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ListArticles>?> getRecommendedArticles() async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        baseUrl: API.publicBaseAPI,
        endpoint: API.recommendedContents,
        useBearer: true
      );
      return NetworkHelper.filterResponse(
        callBack: (json) => (json as List)
          .map((e) => ListArticles.fromJson(e as Map<String, dynamic>))
          .toList(),
        response: response
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ListArticles>?> getTrendingArticles() async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        baseUrl: API.publicBaseAPI,
        endpoint: API.trendingContents,
        useBearer: true
      );
      return NetworkHelper.filterResponse(
        callBack: (json) => (json as List)
          .map((e) => ListArticles.fromJson(e as Map<String, dynamic>))
          .toList(),
        response: response
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Article?> getDetailArticle(String id) async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        baseUrl: API.publicBaseAPI,
        endpoint: API.detailContent,
        queryParam: QP.detailContentQP(id: id),
        useBearer: true
      );
      return NetworkHelper.filterResponse(
        callBack: (json) => Article.fromJson(json as Map<String, dynamic>),
        response: response
      );
    } catch (e) {
      rethrow;
    }
  }
}