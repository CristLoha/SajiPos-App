part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

final class InitializeNotificationEvent extends NotificationEvent {}

final class NotificationReceivedEvent extends NotificationEvent {
  final NotificationPayload payload;

  const NotificationReceivedEvent(this.payload);

  @override
  List<Object?> get props => [payload];
}
