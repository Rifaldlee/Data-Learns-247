import 'package:data_learns_247/core/provider/api.dart';
import 'package:data_learns_247/core/provider/network_helper.dart';
import 'package:data_learns_247/core/provider/network_service.dart';
import 'package:data_learns_247/core/provider/query_parameter.dart';
import 'package:data_learns_247/core/repository/reels_repository.dart';
import 'package:data_learns_247/features/reels/data/dto/analytic_reels_payload.dart';
import 'package:data_learns_247/features/reels/data/models/detail_reels_model.dart';
import 'package:data_learns_247/features/reels/data/models/list_reels_model.dart';
import 'package:data_learns_247/features/reels/data/response/analytic_response.dart';

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
  Future<List<DetailReels>> getDetailReels(String id) async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        baseUrl: API.publicBaseAPI,
        endpoint: API.detailReels,
        queryParam: QP.detailReelsQP(id: id),
      );
      return NetworkHelper.filterResponse(
        callBack: (json) {
          final list = json as List<dynamic>;
          return list.map((e) => DetailReels.fromJson(e as Map<String, dynamic>)).toList();
        },
        response: response,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AnalyticResponse?> postAnalyticReels(AnalyticReelsPayload data) async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.post,
        baseUrl: API.publicBaseAPI,
        endpoint: API.analyticReels,
        useBearer: true,
        body: data.toJson()
      );
      return NetworkHelper.filterResponse(
          callBack: (json) => AnalyticResponse.fromJson(json),
          response: response
      );
    } catch (e) {
      rethrow;
    }
  }
}