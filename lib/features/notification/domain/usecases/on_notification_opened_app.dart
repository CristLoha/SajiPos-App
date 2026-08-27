import '../entities/notification_payload.dart';
import '../repositories/notification_repository.dart';

class OnNotificationOpenedApp {
  final NotificationRepository repository;

  OnNotificationOpenedApp(this.repository);

  Stream<NotificationPayload> call() {
    return repository.onNotificationOpenedApp();
  }
}
