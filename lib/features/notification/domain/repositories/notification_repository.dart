import '../entities/notification_payload.dart';

abstract class NotificationRepository {
  Future<void> subscribeToPromoTopic();
  Future<NotificationPayload?> getInitialNotification();
  Stream<NotificationPayload> onNotificationOpenedApp();
}
