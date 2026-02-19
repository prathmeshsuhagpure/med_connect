import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/notification_model.dart';
import 'api_service.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("📩 Handling background message: ${message.messageId}");
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final ApiService _apiService = ApiService();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  List<NotificationItem> _notifications = [];
  Function(List<NotificationItem>)? _onNotificationsChanged;
  Function(NotificationItem)? _onNotificationOpened;

  String? get fcmToken => _fcmToken;
  List<NotificationItem> get notifications => _notifications;
  int get newNotificationsCount => _notifications.where((n) => n.isNew).length;

  void setNotificationsChangedCallback(
      Function(List<NotificationItem>) callback) {
    _onNotificationsChanged = callback;
  }

  void setNotificationOpenedCallback(Function(NotificationItem) callback) {
    _onNotificationOpened = callback;
  }

  Future<void> initialize() async {
    try {
      // Register background handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Request permissions
      NotificationSettings settings =
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('✅ Notification permission granted');
      } else {
        print('❌ Notification permission denied');
        return; // No point continuing if permission denied
      }

      // ✅ FIX: iOS foreground notification presentation options
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Initialize local notifications
      const androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInit = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );
      const initSettings = InitializationSettings(
        android: androidInit,
        iOS: iosInit,
      );

      // ✅ FIX: `initialize` takes positional argument, not named `settings:`
      await _localNotifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // ✅ FIX: Get and store the FCM token
      _fcmToken = await _firebaseMessaging.getToken();
      print('📲 FCM Token: $_fcmToken');

      // Refresh token when it changes
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        print('🔄 FCM Token refreshed: $_fcmToken');
        // TODO: Send new token to your backend
      });

      // ✅ FIX: Handle ALL foreground messages, not just those with a notification block.
      // Backend may send data-only messages; we handle both cases.
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('📨 Foreground message: ${message.notification?.title}');
        print("📨 FULL MESSAGE DATA: ${message.data}");
        _handleForegroundMessage(message);
      });

      // Handle notification opened from background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('👆 Notification opened from background');
        _handleNotificationOpened(message);
      });

      // Handle notification opened from terminated state
      RemoteMessage? initialMessage =
      await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        print('🚀 App opened from terminated state via notification');
        _handleNotificationOpened(initialMessage);
      }

      // Subscribe to topics
      await _firebaseMessaging.subscribeToTopic('all_users');
      await _firebaseMessaging.subscribeToTopic('med_connect');

      // Load stored notifications
      await _loadStoredNotifications();

      print('✅ Notification service initialized successfully');
    } catch (e) {
      print('❌ Error initializing notification service: $e');
    }
  }

  Future<void> subscribeToRoleTopic(String role) async {
    try {
      await _firebaseMessaging.subscribeToTopic(role.toLowerCase());
      print('✅ Subscribed to topic: $role');
    } catch (e) {
      print('❌ Error subscribing to topic: $e');
    }
  }

  Future<void> unsubscribeFromRoleTopic(String role) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(role.toLowerCase());
      print('✅ Unsubscribed from topic: $role');
    } catch (e) {
      print('❌ Error unsubscribing from topic: $e');
    }
  }

  // ✅ FIX: Removed the `message.notification != null` guard — handle all messages
  void _handleForegroundMessage(RemoteMessage message) {
    final notification = _createNotificationFromMessage(message);
    _notifications.insert(0, notification);
    _saveNotifications();
    _showLocalNotification(message);
    _onNotificationsChanged?.call(_notifications);
  }

  void _handleNotificationOpened(RemoteMessage message) {
    final notification = _createNotificationFromMessage(message);
    notification.isNew = false;

    if (!_notifications.any((n) => n.id == notification.id)) {
      _notifications.insert(0, notification);
      _saveNotifications();
      _onNotificationsChanged?.call(_notifications);
    }
    _onNotificationOpened?.call(notification);
  }

  NotificationItem _createNotificationFromMessage(RemoteMessage message) {
    final data = message.data;
    final notification = message.notification;
    final typeString = data['type'] ?? 'general';

    // ✅ FIX: Fall back to data fields when notification block is absent (data-only messages)
    final title = notification?.title ?? data['title'] ?? 'New Notification';
    final body =
        notification?.body ?? data['body'] ?? 'You have a new message';

    return NotificationItem(
      id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      subtitle: body,
      time: _getTimeAgo(DateTime.now()),
      icon: _getIconFromType(typeString),
      color: _getColorFromType(typeString),
      isNew: true,
      type: _getNotificationType(typeString),
      payload: data,
      actions: _parseActions(data['actions']),
    );
  }

  NotificationType _getNotificationType(String type) {
    return NotificationType.values.firstWhere(
          (e) => e.name.toLowerCase() == type.toLowerCase(),
      orElse: () => NotificationType.general,
    );
  }

  List<Map<String, dynamic>> _parseActions(dynamic actionsData) {
    if (actionsData == null) return [];
    if (actionsData is String) {
      try {
        final decoded = jsonDecode(actionsData);
        if (decoded is List) {
          return decoded.cast<Map<String, dynamic>>();
        }
      } catch (e) {
        return [];
      }
    }
    if (actionsData is List) {
      return actionsData.cast<Map<String, dynamic>>();
    }
    return [];
  }

  IconData _getIconFromType(String type) {
    switch (type.toLowerCase()) {
      case 'appointment':
        return Icons.event;
      case 'reminder':
        return Icons.alarm;
      case 'cancellation':
        return Icons.cancel;
      case 'prescription':
        return Icons.medication;
      case 'payment':
        return Icons.payment;
      case 'message':
        return Icons.message;
      case 'review':
        return Icons.star_rate;
      case 'emergency':
        return Icons.emergency;
      case 'report':
        return Icons.assessment;
      case 'general':
      default:
        return Icons.notifications;
    }
  }

  Color _getColorFromType(String type) {
    switch (type.toLowerCase()) {
      case 'appointment':
        return const Color(0xFF2E7D32);
      case 'reminder':
        return const Color(0xFFFF9800);
      case 'cancellation':
        return const Color(0xFFF44336);
      case 'prescription':
        return const Color(0xFF9C27B0);
      case 'payment':
        return const Color(0xFF1976D2);
      case 'message':
        return const Color(0xFF00BCD4);
      case 'review':
        return const Color(0xFFFFEB3B);
      case 'emergency':
        return const Color(0xFFD32F2F);
      case 'report':
        return const Color(0xFF607D8B);
      case 'general':
      default:
        return const Color(0xFF757575);
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${(difference.inDays / 7).floor()}w ago';
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'med_connect_channel',
      'MedConnect Notifications',
      channelDescription: 'Notifications for MedConnect app',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // ✅ FIX: Fall back to data fields for title/body in data-only messages
    final title =
        message.notification?.title ?? message.data['title'] ?? 'Notification';
    final body = message.notification?.body ?? message.data['body'] ?? '';

    await _localNotifications.show(
      id: message.hashCode,
      title: title,
      body: body,
      notificationDetails: platformDetails,
      payload: jsonEncode(message.data),
    );

  }

  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        print('Notification tapped with payload: $data');
        // TODO: Handle navigation based on payload
      } catch (e) {
        print('Error parsing notification payload: $e');
      }
    }
  }

  Future<void> _loadStoredNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = prefs.getStringList('notifications') ?? [];
      _notifications = notificationsJson
          .map((json) => NotificationItem.fromJson(jsonDecode(json)))
          .toList();
      print('✅ Loaded ${_notifications.length} stored notifications');
      _onNotificationsChanged?.call(_notifications);
    } catch (e) {
      print('❌ Error loading stored notifications: $e');
      _notifications = [];
    }
  }

  Future<void> _saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson =
      _notifications.map((n) => jsonEncode(n.toJson())).toList();
      await prefs.setStringList('notifications', notificationsJson);
    } catch (e) {
      print('❌ Error saving notifications: $e');
    }
  }

  Future<void> clearAllNotifications() async {
    _notifications.clear();
    await _saveNotifications();
    _onNotificationsChanged?.call(_notifications);
  }

  Future<void> markAllAsRead() async {
    for (var notification in _notifications) {
      notification.isNew = false;
    }
    await _saveNotifications();
    _onNotificationsChanged?.call(_notifications);
  }

  Future<void> markAsRead(NotificationItem notification) async {
    notification.isNew = false;
    await _saveNotifications();
    _onNotificationsChanged?.call(_notifications);
  }

  Future<void> deleteNotification(String notificationId) async {
    _notifications.removeWhere((n) => n.id == notificationId);
    await _saveNotifications();
    _onNotificationsChanged?.call(_notifications);
  }

  Future<void> sendTestNotification(String role) async {
    final testNotification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Test Notification',
      subtitle: 'This is a test notification for $role',
      time: 'Just now',
      icon: Icons.notifications,
      color: Colors.blue,
      isNew: true,
      type: NotificationType.general,
      payload: {'test': 'true', 'role': role},
    );

    _notifications.insert(0, testNotification);
    await _saveNotifications();
    _onNotificationsChanged?.call(_notifications);
  }
}