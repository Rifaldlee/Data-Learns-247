import 'package:data_learns_247/core/provider/api.dart';
import 'package:data_learns_247/core/provider/network_helper.dart';
import 'package:data_learns_247/core/provider/network_service.dart';
import 'package:data_learns_247/core/provider/query_parameter.dart';
import 'package:data_learns_247/core/repository/search_repository.dart';
import 'package:data_learns_247/features/search/data/models/search_model.dart';

class SearchRepositoryImpl extends SearchRepository{

  @override
  Future<SearchResult?> searchData(String query) async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        baseUrl: API.publicBaseAPI,
        endpoint: API.search,
        queryParam: QP.searchQP(query: query),
        useBearer: true,
      );
      print('HASIL = ${response.body}');
      return NetworkHelper.filterResponse(
          callBack: (json) => SearchResult.fromJson(json as Map<String, dynamic>),
          response: response
      );
    } catch (e) {
      rethrow;
    }
  }
}