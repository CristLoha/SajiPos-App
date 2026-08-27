part of 'notification_bloc.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

final class NotificationInitial extends NotificationState {}

final class NotificationRouteToPromo extends NotificationState {
  final int campaignId;

  const NotificationRouteToPromo(this.campaignId);

  @override
  List<Object?> get props => [campaignId];
}
