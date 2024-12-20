import 'package:data_learns_247/core/provider/api.dart';
import 'package:data_learns_247/core/provider/network_helper.dart';
import 'package:data_learns_247/core/provider/network_service.dart';
import 'package:data_learns_247/core/provider/query_parameter.dart';
import 'package:data_learns_247/core/repository/reels_repository.dart';
import 'package:data_learns_247/features/reels/data/models/detail_reels_model.dart';
import 'package:data_learns_247/features/reels/data/models/list_reels_model.dart';

class ReelsRepositoryImpl extends ReelsRepository {

  @override
  Future<List<ListReels>?> getListReels() async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        baseUrl: API.publicBaseAPI,
        endpoint: API.listReels
      );
      return NetworkHelper.filterResponse(
        callBack: (json) => (json as List)
          .map((e) => ListReels.fromJson (e as Map<String, dynamic>))
          .toList(),
        response: response
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DetailReels?> getDetailReels(String id) async {
    try {
      final response = await NetworkService.sendRequest(
          requestType: RequestType.get,
          baseUrl: API.publicBaseAPI,
          endpoint: API.detailReels,
          queryParam: QP.detailReelsQP(id: id),
      );
      return NetworkHelper.filterResponse(
          callBack: (json) => DetailReels.fromJson(json as Map<String, dynamic>),
          response: response
      );
    } catch (e) {
      rethrow;
    }
  }
}