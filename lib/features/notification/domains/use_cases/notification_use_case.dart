import 'package:data_learns_247/core/repository/notification_repository.dart';
import 'package:data_learns_247/features/notification/data/models/notification_model.dart';

class GetNotification {
  final NotificationRepository _notificationRepository;

  GetNotification(this._notificationRepository);

  Future<Notification?> call() async {
    return await _notificationRepository.getNotification();
  }
}