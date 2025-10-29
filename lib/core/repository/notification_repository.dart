import 'package:data_learns_247/features/notification/data/models/notification_model.dart';

abstract class NotificationRepository {
  Future<Notification?> getNotification();
}