import 'package:data_learns_247/features/search/data/models/search_model.dart';

abstract class SearchRepository {
  Future<SearchResult?> searchData(String query);
}