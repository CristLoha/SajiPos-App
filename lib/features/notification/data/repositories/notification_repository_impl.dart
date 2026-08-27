import '../../domain/entities/notification_payload.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> subscribeToPromoTopic() async {
    return await remoteDataSource.subscribeToPromo();
  }

  @override
  Future<NotificationPayload?> getInitialNotification() async {
    final model = await remoteDataSource.getInitialMessage();
    return model?.toEntity();
  }

  @override
  Stream<NotificationPayload> onNotificationOpenedApp() {
    return remoteDataSource.onMessageOpenedApp().map(
      (model) => model.toEntity(),
    );
  }
}
