import 'package:data_learns_247/core/provider/api.dart';
import 'package:data_learns_247/core/provider/network_helper.dart';
import 'package:data_learns_247/core/provider/network_service.dart';
import 'package:data_learns_247/core/repository/notification_repository.dart';
import 'package:data_learns_247/features/notification/data/models/notification_model.dart';

class NotificationRepositoryImpl extends NotificationRepository{

  @override
  Future<Notification?> getNotification() async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        baseUrl: API.publicBaseAPI,
        endpoint: API.notification,
        useBearer: true
      );
      return NetworkHelper.filterResponse(
        callBack: (json) => Notification.fromJson(json as Map<String, dynamic>),
        response: response
      );
    } catch (e) {
      rethrow;
    }
  }
}