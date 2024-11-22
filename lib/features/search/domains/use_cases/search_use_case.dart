import 'package:data_learns_247/features/search/data/models/search_model.dart';
import 'package:data_learns_247/core/repository/search_repository.dart';

class GetSearchData {
  final String _query;
  final SearchRepository _searchRepository;

  GetSearchData(this._query, this._searchRepository);

  Future<SearchResult?> call() async {
    return await _searchRepository.searchData(_query);
  }
}