// ============================================================================
// core/services/notification_service.dart - Serviço de Notificações
// ============================================================================

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Serviço para notificações locais e push (FCM)
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Inicializa o plugin de notificações locais
  static Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(initSettings);
  }

  /// Exibe uma notificação local imediata
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'inclusimove_channel',
      'InclusIMove',
      channelDescription: 'Notificações do aplicativo InclusIMove',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(id, title, body, notificationDetails, payload: payload);
  }

  /// Agenda uma notificação para daqui a [minutes] minutos
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required Duration delay,
  }) async {
    // Implementação com zonedSchedule para versões mais recentes
    // TODO: implementar com flutter_local_notifications timezone
    await Future.delayed(delay);
    await showNotification(id: id, title: title, body: body);
  }
}
