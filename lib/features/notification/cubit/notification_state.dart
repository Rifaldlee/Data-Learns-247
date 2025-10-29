part of 'notification_cubit.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationCompleted extends NotificationState {
  final Notification notification;

  const NotificationCompleted(this.notification);

  @override
  List<Object> get props => [notification];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object> get props => [message];
}

class NotificationEmpty extends NotificationState {
  const NotificationEmpty();
}