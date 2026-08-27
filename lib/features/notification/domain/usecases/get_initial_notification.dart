import '../entities/notification_payload.dart';
import '../repositories/notification_repository.dart';

class GetInitialNotification {
  final NotificationRepository repository;

  GetInitialNotification(this.repository);

  Future<NotificationPayload?> call() async {
    return await repository.getInitialNotification();
  }
}
