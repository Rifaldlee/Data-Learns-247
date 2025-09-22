import 'package:data_learns_247/core/provider/api.dart';
import 'package:data_learns_247/core/provider/network_helper.dart';
import 'package:data_learns_247/core/provider/network_service.dart';
import 'package:data_learns_247/core/repository/greeting_repository.dart';
import 'package:data_learns_247/features/greeting/greeting_model.dart';

class GreetingRepositoryImpl extends GreetingRepository {

  @override
  Future<Greeting?> getGreeting() async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        baseUrl: API.publicBaseAPI,
        endpoint: API.greetingImage,
        useBearer: true
      );
      return NetworkHelper.filterResponse(
          callBack: (json) => Greeting.fromJson(json as Map<String, dynamic>),
          response: response
      );
    } catch (e) {
      rethrow;
    }
  }
}