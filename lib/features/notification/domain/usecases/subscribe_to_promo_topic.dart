import '../repositories/notification_repository.dart';

class SubscribeToPromoTopic {
  final NotificationRepository repository;

  SubscribeToPromoTopic(this.repository);

  Future<void> call() async {
    return await repository.subscribeToPromoTopic();
  }
}
