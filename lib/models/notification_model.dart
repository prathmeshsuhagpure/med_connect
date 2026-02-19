import 'package:flutter/material.dart';

enum NotificationType {
  appointment,
  reminder,
  cancellation,
  prescription,
  payment,
  message,
  review,
  general,
  emergency,
  report,
}

class NotificationItem {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color color;
  bool isNew;
  final NotificationType type;
  final Map<String, dynamic>? payload;
  final List<Map<String, dynamic>> actions;

  NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
    this.isNew = true,
    required this.type,
    this.payload,
    this.actions = const [],
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      time: json['time'] ?? '',
      icon: _iconFromString(json['iconName'] ?? 'notifications'),
      color: Color(json['color'] ?? 0xFF607D8B),
      isNew: json['isNew'] ?? false,
      type: _typeFromString(json['type'] ?? 'general'),
      payload: json['payload'],
      actions: (json['actions'] as List?)?.cast<Map<String, dynamic>>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'time': time,
      'iconName': _iconToString(icon),
      'color': color.value,
      'isNew': isNew,
      'type': type.name,
      'payload': payload,
      'actions': actions,
    };
  }

  static IconData _iconFromString(String iconName) {
    switch (iconName) {
      case 'directions_car':
        return Icons.directions_car;
      case 'payment':
        return Icons.payment;
      case 'star_rate':
        return Icons.star_rate;
      case 'local_offer':
        return Icons.local_offer;
      case 'person':
        return Icons.person;
      case 'warning':
        return Icons.warning;
      case 'event':
        return Icons.event;
      case 'cancel':
        return Icons.cancel;
      case 'medication':
        return Icons.medication;
      case 'message':
        return Icons.message;
      case 'report':
        return Icons.assessment;
      case 'emergency':
        return Icons.emergency;
      default:
        return Icons.notifications;
    }
  }

  static String _iconToString(IconData icon) {
    if (icon == Icons.directions_car) return 'directions_car';
    if (icon == Icons.payment) return 'payment';
    if (icon == Icons.star_rate) return 'star_rate';
    if (icon == Icons.local_offer) return 'local_offer';
    if (icon == Icons.person) return 'person';
    if (icon == Icons.warning) return 'warning';
    if (icon == Icons.event) return 'event';
    if (icon == Icons.cancel) return 'cancel';
    if (icon == Icons.medication) return 'medication';
    if (icon == Icons.message) return 'message';
    if (icon == Icons.assessment) return 'report';
    if (icon == Icons.emergency) return 'emergency';
    return 'notifications';
  }

  static NotificationType _typeFromString(String type) {
    return NotificationType.values.firstWhere(
          (e) => e.name == type,
      orElse: () => NotificationType.general,
    );
  }

  // Helper to check if notification is read
  bool get isRead => !isNew;
}