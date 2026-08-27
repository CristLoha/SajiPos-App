import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/notification_payload_model.dart';
import 'local_notification_helper.dart'; // Import Helper yang baru dibuat

abstract class NotificationRemoteDataSource {
  Future<void> subscribeToPromo();
  Future<NotificationPayloadModel?> getInitialMessage();
  Stream<NotificationPayloadModel> onMessageOpenedApp();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseMessaging firebaseMessaging;

  NotificationRemoteDataSourceImpl({required this.firebaseMessaging}) {
    // 1. Inisialisasi Local Notification Helper saat DataSource terbentuk
    LocalNotificationHelper.init();

    // 2. LISTEN FOREGROUND: Dengarkan pesan masuk saat aplikasi sedang dibuka!
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("========================================");
      debugPrint("ON MESSAGE TRIGGERED IN FOREGROUND!");
      debugPrint("Title: ${message.notification?.title}");
      debugPrint("Body: ${message.notification?.body}");
      debugPrint("========================================");
      
      // Jika pesannya mengandung objek notifikasi, paksa munculkan popup!
      if (message.notification != null) {
        LocalNotificationHelper.showNotification(message);
      }
    });
  }

  @override
  Future<void> subscribeToPromo() async {
    // Minta Izin dulu ke User (wajib untuk iOS dan Android 13+)
    await firebaseMessaging.requestPermission();

    // Pastikan APNS token dan pengaturan iOS dijalankan HANYA di iOS/macOS
    if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      String? apnsToken = await firebaseMessaging.getAPNSToken();
      if (apnsToken == null) {
        // Wait for APNS token to be generated, especially on iOS
        await Future.delayed(const Duration(seconds: 3));
        apnsToken = await firebaseMessaging.getAPNSToken();
      }
      
      // Aktifkan notifikasi foreground bawaan Firebase untuk iOS
      await firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // Get FCM Token and print it so the user can see it in logs
    String? token;
    try {
      token = await firebaseMessaging.getToken();
    } catch (e) {
      debugPrint("Gagal mendapatkan FCM token: $e");
    }
    
    if (token != null) {
      debugPrint("========================================");
      debugPrint("FCM DEVICE TOKEN: $token");
      debugPrint("========================================");
    }

    // Subscribe topic
    await firebaseMessaging.subscribeToTopic("promo_broadcast");
    debugPrint("Berhasil subscribe ke topic: promo_broadcast");
  }

  @override
  Future<NotificationPayloadModel?> getInitialMessage() async {
    RemoteMessage? message = await firebaseMessaging.getInitialMessage();
    if (message != null && message.data.isNotEmpty) {
      return NotificationPayloadModel.fromJson(message.data);
    }
    return null;
  }

  @override
  Stream<NotificationPayloadModel> onMessageOpenedApp() {
    return FirebaseMessaging.onMessageOpenedApp.map((message) {
      return NotificationPayloadModel.fromJson(message.data);
    });
  }
}
