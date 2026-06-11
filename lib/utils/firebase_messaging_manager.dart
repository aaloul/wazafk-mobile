import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../firebase_options.dart';
import 'Prefs.dart';

const _logTag = 'FCM';

/// Android notification channel used for foreground / data messages.
const AndroidNotificationChannel _channel = AndroidNotificationChannel(
  'wazafak_high_importance',
  'Notifications',
  description: 'Wazafak notifications',
  importance: Importance.high,
);

/// Background / terminated message handler. Must be a top-level (or static)
/// function annotated with @pragma so it survives tree-shaking and can run in
/// its own isolate.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  log('background message: ${message.messageId} ${message.data}', name: _logTag);
}

/// Centralizes Firebase Cloud Messaging setup: init, permissions, token,
/// foreground display (via local notifications) and tap handling.
class FirebaseMessagingManager {
  FirebaseMessagingManager._();

  static final FirebaseMessagingManager _instance =
      FirebaseMessagingManager._();

  factory FirebaseMessagingManager() => _instance;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Initialize Firebase + messaging. Safe to call once at startup.
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      FirebaseMessaging.onBackgroundMessage(
        firebaseMessagingBackgroundHandler,
      );

      await _initLocalNotifications();
      await _requestPermission();

      // Show alerts while the app is in the foreground on iOS.
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      await _loadToken();
      _messaging.onTokenRefresh.listen(_saveToken);

      FirebaseMessaging.onMessage.listen(_onForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);

      // App opened from a terminated state by tapping a notification.
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) _onMessageOpened(initialMessage);
    } catch (e) {
      log('init error: $e', name: _logTag);
    }
  }

  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const settings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        _handleData(_decodePayload(response.payload));
      },
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Android 13+ runtime POST_NOTIFICATIONS prompt.
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  Future<void> _loadToken() async {
    final token = await _messaging.getToken();
    if (token != null) _saveToken(token);
  }

  void _saveToken(String token) {
    Prefs.setNotificationToken(token);
    log('token: $token', name: _logTag);
    // TODO: register [token] with the backend once the endpoint is available.
  }

  /// Foreground messages don't show a system notification on Android, so we
  /// render one via flutter_local_notifications.
  void _onForegroundMessage(RemoteMessage message) {
    log('foreground message: ${message.messageId} ${message.data}',
        name: _logTag);

    final notification = message.notification;
    final title = notification?.title ?? message.data['title']?.toString();
    final body = notification?.body ?? message.data['body']?.toString();
    if (title == null && body == null) return;

    _localNotifications.show(
      id: message.hashCode,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: _encodePayload(message.data),
    );
  }

  void _onMessageOpened(RemoteMessage message) {
    log('message opened: ${message.messageId} ${message.data}', name: _logTag);
    _handleData(message.data);
  }

  /// Routes the user based on the notification payload. Backend payload shape
  /// is not finalized yet, so this defensively honors a `route` key if present.
  void _handleData(Map<String, dynamic> data) {
    if (data.isEmpty) return;
    final route = data['route']?.toString();
    if (route != null && route.isNotEmpty) {
      Get.toNamed(route, arguments: data);
    }
  }

  String _encodePayload(Map<String, dynamic> data) => data.entries
      .map((e) => '${e.key}=${e.value}')
      .join('&');

  Map<String, dynamic> _decodePayload(String? payload) {
    if (payload == null || payload.isEmpty) return {};
    final map = <String, dynamic>{};
    for (final pair in payload.split('&')) {
      final i = pair.indexOf('=');
      if (i > 0) map[pair.substring(0, i)] = pair.substring(i + 1);
    }
    return map;
  }
}
