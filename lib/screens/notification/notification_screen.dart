import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/notification_model.dart';
import '../../services/notification_service.dart';
import '../../providers/authentication_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final NotificationService _notificationService = NotificationService();
  List<NotificationItem> _notifications = [];
  bool _showOnlyUnread = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadNotifications();
  }

  // ✅ Load notifications from service
  void _loadNotifications() {
    setState(() {
      _notifications = _notificationService.notifications;
    });

    // ✅ Listen to notification changes
    _notificationService.setNotificationsChangedCallback((notifications) {
      if (mounted) {
        setState(() {
          _notifications = notifications;
        });
      }
    });

    // ✅ Handle notification opened/tapped
    _notificationService.setNotificationOpenedCallback((notification) {
      if (mounted) {
        _handleNotificationTap(notification);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ✅ Get filtered notifications
  List<NotificationItem> get _allNotifications => _notifications;

  List<NotificationItem> get _unreadNotifications =>
      _notifications.where((n) => n.isNew).toList();

  List<NotificationItem> get _readNotifications =>
      _notifications.where((n) => !n.isNew).toList();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 650;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_showOnlyUnread
                ? Icons.filter_alt
                : Icons.filter_alt_outlined),
            onPressed: () {
              setState(() {
                _showOnlyUnread = !_showOnlyUnread;
              });
            },
            tooltip: "Filter unread",
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'mark_all_read') {
                _markAllAsRead();
              } else if (value == 'clear_all') {
                _showClearAllDialog(context, isDarkMode);
              } else if (value == 'test') {
                _sendTestNotification();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Row(
                  children: [
                    Icon(Icons.done_all),
                    SizedBox(width: 12),
                    Text('Mark all as read'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 12),
                    Text('Clear all'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'test',
                child: Row(
                  children: [
                    Icon(Icons.bug_report),
                    SizedBox(width: 12),
                    Text('Send Test'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: isDarkMode ? Colors.grey[900] : Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor:
              isDarkMode ? Colors.grey[400] : Colors.grey[600],
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: "All"),
                Tab(text: "Unread"),
                Tab(text: "Read"),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Summary Card
          if (!_showOnlyUnread) _buildSummaryCard(context, isMobile, isDarkMode),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNotificationList(_allNotifications, isMobile, isDarkMode),
                _buildNotificationList(_unreadNotifications, isMobile, isDarkMode),
                _buildNotificationList(_readNotifications, isMobile, isDarkMode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      BuildContext context, bool isMobile, bool isDarkMode) {
    final unreadCount = _unreadNotifications.length;

    return Container(
      margin: EdgeInsets.all(isMobile ? 16 : 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.1),
            Theme.of(context).primaryColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.notifications_active,
              color: Theme.of(context).primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You have $unreadCount unread notification${unreadCount != 1 ? 's' : ''}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Total: ${_notifications.length} notifications",
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text("Mark all read"),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(
      List<NotificationItem> notifications,
      bool isMobile,
      bool isDarkMode,
      ) {
    if (notifications.isEmpty) {
      return _buildEmptyState(
        isDarkMode,
        "No notifications",
        "You're all caught up!",
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadNotifications();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildNotificationCard(
              context,
              notifications[index],
              isMobile,
              isDarkMode,
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(
      BuildContext context,
      NotificationItem notification,
      bool isMobile,
      bool isDarkMode,
      ) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        _deleteNotification(notification);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notification deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // TODO: Implement undo functionality
              },
            ),
          ),
        );
      },
      child: InkWell(
        onTap: () => _handleNotificationTap(notification),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isNew
                ? (isDarkMode
                ? Colors.blue.withValues(alpha: 0.1)
                : Colors.blue.withValues(alpha: 0.05))
                : (isDarkMode ? Colors.grey[850] : Colors.white),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: notification.isNew
                  ? Theme.of(context).primaryColor.withValues(alpha: 0.3)
                  : (isDarkMode ? Colors.grey[700]! : Colors.grey[200]!),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: notification.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  notification.icon,
                  color: notification.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: notification.isNew
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                        if (notification.isNew)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color:
                          isDarkMode ? Colors.grey[500] : Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          notification.time,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode
                                ? Colors.grey[500]
                                : Colors.grey[500],
                          ),
                        ),
                        const Spacer(),
                        _buildTypeBadge(notification.type, isDarkMode),
                      ],
                    ),

                    // Action buttons if available
                    if (notification.actions.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: notification.actions.map((action) {
                          final isPrimary = action['isPrimary'] ?? false;
                          return _buildActionButton(
                            action['label'] ?? 'Action',
                            isPrimary,
                            isDarkMode,
                                () => _handleActionTap(notification, action),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeBadge(NotificationType type, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.grey[800]
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _getTypeDisplayName(type),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
        ),
      ),
    );
  }

  String _getTypeDisplayName(NotificationType type) {
    switch (type) {
      case NotificationType.appointment:
        return 'Appointment';
      case NotificationType.reminder:
        return 'Reminder';
      case NotificationType.cancellation:
        return 'Cancellation';
      case NotificationType.prescription:
        return 'Prescription';
      case NotificationType.payment:
        return 'Payment';
      case NotificationType.message:
        return 'Message';
      case NotificationType.review:
        return 'Review';
      case NotificationType.emergency:
        return 'Emergency';
      case NotificationType.report:
        return 'Report';
      case NotificationType.general:
      default:
        return 'General';
    }
  }

  Widget _buildActionButton(
      String label,
      bool isPrimary,
      bool isDarkMode,
      VoidCallback onPressed,
      ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? Theme.of(context).primaryColor
            : (isDarkMode ? Colors.grey[800] : Colors.grey[200]),
        foregroundColor: isPrimary
            ? Colors.white
            : (isDarkMode ? Colors.grey[300] : Colors.grey[800]),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode, String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Handle notification tap
  void _handleNotificationTap(NotificationItem notification) async {
    // Mark as read
    await _notificationService.markAsRead(notification);

    // Navigate based on type
    switch (notification.type) {
      case NotificationType.appointment:
      // TODO: Navigate to appointment details
        if (notification.payload?['appointmentId'] != null) {
          debugPrint('Navigate to appointment: ${notification.payload!['appointmentId']}');
          // Navigator.pushNamed(context, '/appointment-details', arguments: notification.payload);
        }
        break;

      case NotificationType.prescription:
      // TODO: Navigate to prescription details
        debugPrint('Navigate to prescriptions');
        break;

      case NotificationType.payment:
      // TODO: Navigate to payment screen
        debugPrint('Navigate to payments');
        break;

      case NotificationType.message:
      // TODO: Navigate to messages
        debugPrint('Navigate to messages');
        break;

      case NotificationType.emergency:
      // TODO: Show emergency details
        debugPrint('Show emergency details');
        break;

      default:
      // Show notification details
        _showNotificationDetails(notification);
    }
  }

  // ✅ Handle action button tap
  void _handleActionTap(NotificationItem notification, Map<String, dynamic> action) {
    debugPrint('Action tapped: ${action['label']} for notification ${notification.id}');

    // Handle specific actions
    final label = action['label']?.toString().toLowerCase() ?? '';

    if (label.contains('view')) {
      _handleNotificationTap(notification);
    } else if (label.contains('reschedule')) {
      // TODO: Navigate to reschedule screen
      debugPrint('Navigate to reschedule');
    } else if (label.contains('accept')) {
      // TODO: Accept appointment
      debugPrint('Accept appointment');
    } else if (label.contains('decline')) {
      // TODO: Decline appointment
      debugPrint('Decline appointment');
    }
  }

  // ✅ Show notification details dialog
  void _showNotificationDetails(NotificationItem notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(notification.icon, color: notification.color),
            const SizedBox(width: 12),
            Expanded(child: Text(notification.title)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.subtitle),
            const SizedBox(height: 12),
            Text(
              notification.time,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // ✅ Mark all as read
  void _markAllAsRead() async {
    await _notificationService.markAllAsRead();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ✅ Delete notification
  void _deleteNotification(NotificationItem notification) async {
    await _notificationService.deleteNotification(notification.id);
  }

  // ✅ Clear all notifications
  void _showClearAllDialog(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Clear All Notifications?"),
          content: const Text(
            "This will permanently delete all notifications. This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _notificationService.clearAllNotifications();
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All notifications cleared'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text("Clear All"),
            ),
          ],
        );
      },
    );
  }

  // ✅ Send test notification (for development)
  void _sendTestNotification() async {
    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    final userRole = authProvider.userRole ?? 'patient';

    await _notificationService.sendTestNotification(userRole);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Test notification sent'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}