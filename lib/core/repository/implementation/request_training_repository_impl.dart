import 'package:data_learns_247/core/provider/api.dart';
import 'package:data_learns_247/core/provider/network_helper.dart';
import 'package:data_learns_247/core/provider/network_service.dart';
import 'package:data_learns_247/core/provider/query_parameter.dart';
import 'package:data_learns_247/core/repository/request_training_repository.dart';
import 'package:data_learns_247/features/request_training/data/models/request_training_detail_model.dart';
import 'package:data_learns_247/features/request_training/data/models/request_training_list.dart';

class RequestTrainingImpl extends RequestTrainingRepository {

  @override
  Future<List<RequestTrainingList>?> getRequestTrainingList() async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        baseUrl: API.publicBaseAPI,
        endpoint: API.requestTrainingList,
        useBearer: true
      );
      return NetworkHelper.filterResponse(
        callBack: (json) => (json as List)
          .map((e) => RequestTrainingList.fromJson(e as Map<String, dynamic>))
          .toList(),
        response: response
      );
    } catch (e) {
      rethrow;
    }
  }
  @override
  Future<RequestTrainingDetail?> getRequestTrainingDetail(String id) async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        baseUrl: API.publicBaseAPI,
        endpoint: API.requestTrainingDetail,
        queryParam: QP.detailRequestTrainingQP(id: id),
        useBearer: true
      );
      return NetworkHelper.filterResponse(
        callBack: (json) => RequestTrainingDetail.fromJson(json as Map<String, dynamic>),
        response: response
      );
    } catch (e) {
      rethrow;
    }
  }
}