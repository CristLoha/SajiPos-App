import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/notification_payload.dart';
import '../../domain/usecases/subscribe_to_promo_topic.dart';
import '../../domain/usecases/get_initial_notification.dart';
import '../../domain/usecases/on_notification_opened_app.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final SubscribeToPromoTopic subscribeToPromoTopic;
  final GetInitialNotification getInitialNotification;
  final OnNotificationOpenedApp onNotificationOpenedApp;

  StreamSubscription<NotificationPayload>? _notificationSubscription;

  NotificationBloc({
    required this.subscribeToPromoTopic,
    required this.getInitialNotification,
    required this.onNotificationOpenedApp,
  }) : super(NotificationInitial()) {
    on<InitializeNotificationEvent>(_onInitializeNotification);
    on<NotificationReceivedEvent>(_onNotificationReceived);
  }

  Future<void> _onInitializeNotification(
    InitializeNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    await subscribeToPromoTopic();

    final initialData = await getInitialNotification();
    if (initialData != null) {
      add(NotificationReceivedEvent(initialData));
    }

    _notificationSubscription?.cancel();
    _notificationSubscription = onNotificationOpenedApp().listen(
      (payload) => add(NotificationReceivedEvent(payload)),
    );
  }

  void _onNotificationReceived(
    NotificationReceivedEvent event,
    Emitter<NotificationState> emit,
  ) {
    final action = event.payload.action;
    final campaignId = event.payload.campaignId;

    if (action == 'open_promo' && campaignId != null) {
      emit(NotificationRouteToPromo(campaignId));
      emit(NotificationInitial());
    }
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }
}
