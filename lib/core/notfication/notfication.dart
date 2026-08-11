import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

import 'notfication_api.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  final Set<String> _processedNotificationIds = {};
  StreamSubscription<RemoteMessage>? _onMessageSubscription;

  /// Callback لمعالجة الإشعارات في المشروع الجديد
  Function(RemoteMessage)? onNotificationReceived;

  // --- التعديل الأساسي هنا ---
  Future<void> initialize(String accesToken) async {
    // 1. طلب الإذن أولاً ومعرفة النتيجة
    bool isAuthorized = await _requestPermission();

    // 2. تهيئة الإشعارات المحلية
    await _setupFlutterNotifications();

    // 3. إعداد مستمعي الرسائل
    await _setupMessageHandlers();

    // 4. إذا وافق المستخدم، نقوم بإرسال التوكن للسيرفر
    if (isAuthorized) {
      await uploadDeviceToken(accesToken);
    }
  }

  // دالة طلب الإذن المحسنة
  Future<bool> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // نتحقق إذا كان المستخدم قد أعطى الموافقة
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  // دالة جلب التوكن وإرساله
  Future<void> uploadDeviceToken(String accessToken) async {
    try {
      String? token = await _messaging.getToken();
      if (token != null) {
        await _sendTokenToServer(token,accessToken);
      }
    } catch (e) {
    }
  }

  // هذه الدالة هي التي تربطها مع الـ API الخاص بك
  Future<void> _sendTokenToServer(String token,String accessToken) async {
   final String  response= await NotficationAPi.notficationEnabled(token,accessToken);
  }
  // ---------------------------

  Future<void> _setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) return;

    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsDarwin = DarwinInitializationSettings();

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // يمكن معالجة النقر هنا إذا أردت
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> _setupMessageHandlers() async {
    await _onMessageSubscription?.cancel();

    _onMessageSubscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleIncomingMessage(message, showLocal: true);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleIncomingMessage(message, showLocal: false);
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleIncomingMessage(initialMessage, showLocal: false);
    }
  }

  void _handleIncomingMessage(RemoteMessage message, {required bool showLocal}) {
    final notificationId = message.messageId ?? message.data.toString();

    if (_processedNotificationIds.contains(notificationId)) return;
    _processedNotificationIds.add(notificationId);

    if (showLocal && message.notification != null) {
      _showLocalNotification(
        message.notification?.title ?? 'Notification',
        message.notification?.body ?? '',
        message.data,
      );
    }

    if (onNotificationReceived != null) {
      onNotificationReceived!(message);
    }

    if (_processedNotificationIds.length > 50) {
      _processedNotificationIds.remove(_processedNotificationIds.first);
    }
  }

  Future<void> _showLocalNotification(String title, String body, Map<String, dynamic> data) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
      payload: data.toString(),
    );
  }

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  }

  void dispose() {
    _onMessageSubscription?.cancel();
    _processedNotificationIds.clear();
  }
}