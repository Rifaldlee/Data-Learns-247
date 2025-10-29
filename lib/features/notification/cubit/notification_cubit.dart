import 'package:bloc/bloc.dart';
import 'package:data_learns_247/core/repository/implementation/notification_repository_impl.dart';
import 'package:data_learns_247/core/repository/notification_repository.dart';
import 'package:data_learns_247/features/notification/data/models/notification_model.dart';
import 'package:data_learns_247/features/notification/domains/use_cases/notification_use_case.dart';
import 'package:equatable/equatable.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _notificationRepository = NotificationRepositoryImpl();

  NotificationCubit() : super(NotificationInitial());

  Future<void> fetchNotification() async {
    try {
      emit(NotificationLoading());

      Notification? notification = await GetNotification(_notificationRepository).call();

      if (notification != null) {
        emit(NotificationCompleted(notification));
      } else {
        emit(const NotificationEmpty());
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}
