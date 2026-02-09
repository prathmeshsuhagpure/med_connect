import 'package:flutter/material.dart';

enum UserRole { patient, doctor, hospital }

class NotificationScreen extends StatefulWidget {
  final UserRole userRole;

  const NotificationScreen({
    super.key,
    this.userRole = UserRole.patient,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showOnlyUnread = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
              } else if (value == 'settings') {
                // TODO: Navigate to notification settings
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
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 12),
                    Text('Settings'),
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
                _buildAllTab(context, isMobile, isDarkMode),
                _buildUnreadTab(context, isMobile, isDarkMode),
                _buildReadTab(context, isMobile, isDarkMode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      BuildContext context, bool isMobile, bool isDarkMode) {
    final unreadCount = _getNotifications()
        .where((n) => !n.isRead)
        .length;

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
                  "You have $unreadCount unread notifications",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Stay updated with your appointments and activities",
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllTab(BuildContext context, bool isMobile, bool isDarkMode) {
    final notifications = _getNotifications();
    return _buildNotificationList(notifications, isMobile, isDarkMode);
  }

  Widget _buildUnreadTab(BuildContext context, bool isMobile, bool isDarkMode) {
    final notifications = _getNotifications()
        .where((n) => !n.isRead)
        .toList();

    if (notifications.isEmpty) {
      return _buildEmptyState(
        context,
        Icons.notifications_none,
        "No Unread Notifications",
        "You're all caught up!",
        isDarkMode,
      );
    }

    return _buildNotificationList(notifications, isMobile, isDarkMode);
  }

  Widget _buildReadTab(BuildContext context, bool isMobile, bool isDarkMode) {
    final notifications = _getNotifications()
        .where((n) => n.isRead)
        .toList();

    if (notifications.isEmpty) {
      return _buildEmptyState(
        context,
        Icons.check_circle_outline,
        "No Read Notifications",
        "Read notifications will appear here",
        isDarkMode,
      );
    }

    return _buildNotificationList(notifications, isMobile, isDarkMode);
  }

  Widget _buildNotificationList(
      List<_NotificationData> notifications,
      bool isMobile,
      bool isDarkMode,
      ) {
    // Group notifications by date
    final groupedNotifications = _groupNotificationsByDate(notifications);

    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      itemCount: groupedNotifications.length,
      itemBuilder: (context, index) {
        final dateGroup = groupedNotifications[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                dateGroup['date'] as String,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
            // Notifications for this date
            ...((dateGroup['notifications'] as List<_NotificationData>)
                .map((notification) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildNotificationCard(
                  context,
                  notification,
                  isDarkMode,
                ),
              );
            })),
          ],
        );
      },
    );
  }

  Widget _buildNotificationCard(
      BuildContext context,
      _NotificationData notification,
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
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          // TODO: Remove notification
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Notification deleted"),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: InkWell(
        onTap: () {
          setState(() {
            notification.isRead = true;
          });
          // TODO: Navigate to relevant screen
          _handleNotificationTap(notification);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isRead
                ? (isDarkMode ? Colors.grey[850] : Colors.white)
                : Theme.of(context).primaryColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead
                  ? (isDarkMode ? Colors.grey[700]! : Colors.grey[200]!)
                  : Theme.of(context).primaryColor.withValues(alpha: 0.2),
              width: notification.isRead ? 1 : 2,
            ),
            boxShadow: [
              if (!notification.isRead)
                BoxShadow(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getNotificationColor(notification.type)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: _getNotificationColor(notification.type),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

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
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                              fontWeight: notification.isRead
                                  ? FontWeight.w600
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
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
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
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
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          notification.time,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),

                    // Action Buttons (if applicable)
                    if (notification.actions.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: notification.actions.map((action) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: TextButton(
                              onPressed: () {
                                // TODO: Handle action
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: action['isPrimary'] == true
                                    ? Theme.of(context).primaryColor
                                    : (isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[200]),
                                foregroundColor: action['isPrimary'] == true
                                    ? Colors.white
                                    : (isDarkMode
                                    ? Colors.grey[300]
                                    : Colors.grey[800]),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                action['label'] as String,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
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

  Widget _buildEmptyState(
      BuildContext context,
      IconData icon,
      String title,
      String subtitle,
      bool isDarkMode,
      ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.grey[800]
                    : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 80,
                color: isDarkMode
                    ? Colors.grey[600]
                    : Theme.of(context).primaryColor.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.appointment:
        return Icons.calendar_today;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.cancellation:
        return Icons.cancel;
      case NotificationType.prescription:
        return Icons.medication;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.message:
        return Icons.message;
      case NotificationType.review:
        return Icons.star;
      case NotificationType.general:
        return Icons.info;
      case NotificationType.emergency:
        return Icons.emergency;
      case NotificationType.report:
        return Icons.description;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.appointment:
        return Colors.blue;
      case NotificationType.reminder:
        return Colors.orange;
      case NotificationType.cancellation:
        return Colors.red;
      case NotificationType.prescription:
        return Colors.green;
      case NotificationType.payment:
        return Colors.purple;
      case NotificationType.message:
        return Colors.cyan;
      case NotificationType.review:
        return Colors.amber;
      case NotificationType.general:
        return Colors.grey;
      case NotificationType.emergency:
        return Colors.red;
      case NotificationType.report:
        return Colors.indigo;
    }
  }

  List<Map<String, dynamic>> _groupNotificationsByDate(
      List<_NotificationData> notifications) {
    final Map<String, List<_NotificationData>> grouped = {};

    for (var notification in notifications) {
      if (!grouped.containsKey(notification.date)) {
        grouped[notification.date] = [];
      }
      grouped[notification.date]!.add(notification);
    }

    return grouped.entries
        .map((entry) => {
      'date': entry.key,
      'notifications': entry.value,
    })
        .toList();
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _getNotifications()) {
        notification.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("All notifications marked as read"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.clear_all, color: Colors.red),
              ),
              const SizedBox(width: 16),
              const Expanded(child: Text("Clear All")),
            ],
          ),
          content: const Text(
            "Are you sure you want to clear all notifications? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  // TODO: Clear all notifications
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("All notifications cleared"),
                    backgroundColor: Colors.red,
                  ),
                );
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

  void _handleNotificationTap(_NotificationData notification) {
    // TODO: Navigate based on notification type
    switch (notification.type) {
      case NotificationType.appointment:
      // Navigate to appointment details
        break;
      case NotificationType.reminder:
      // Navigate to appointment or calendar
        break;
      case NotificationType.prescription:
      // Navigate to prescription details
        break;
      case NotificationType.payment:
      // Navigate to payment screen
        break;
      case NotificationType.message:
      // Navigate to messages/chat
        break;
      default:
        break;
    }
  }

  List<_NotificationData> _getNotifications() {
    // Different notifications based on user role
    switch (widget.userRole) {
      case UserRole.patient:
        return _getPatientNotifications();
      case UserRole.doctor:
        return _getDoctorNotifications();
      case UserRole.hospital:
        return _getHospitalNotifications();
    }
  }

  List<_NotificationData> _getPatientNotifications() {
    return [
      _NotificationData(
        id: '1',
        type: NotificationType.appointment,
        title: 'Appointment Confirmed',
        message: 'Your appointment with Dr. Sarah Johnson is confirmed for tomorrow at 10:30 AM.',
        time: '2 hours ago',
        date: 'Today',
        isRead: false,
        actions: [
          {'label': 'View Details', 'isPrimary': true},
          {'label': 'Reschedule', 'isPrimary': false},
        ],
      ),
      _NotificationData(
        id: '2',
        type: NotificationType.reminder,
        title: 'Appointment Reminder',
        message: 'You have an appointment with Dr. Michael Brown in 24 hours.',
        time: '5 hours ago',
        date: 'Today',
        isRead: false,
        actions: [
          {'label': 'View', 'isPrimary': true},
        ],
      ),
      _NotificationData(
        id: '3',
        type: NotificationType.prescription,
        title: 'New Prescription Available',
        message: 'Dr. Sarah Johnson has added a new prescription for you. View details and purchase.',
        time: '1 day ago',
        date: 'Yesterday',
        isRead: true,
        actions: [
          {'label': 'View Prescription', 'isPrimary': true},
        ],
      ),
      _NotificationData(
        id: '4',
        type: NotificationType.payment,
        title: 'Payment Successful',
        message: 'Your payment of \$150.00 for appointment #APT123 was successful.',
        time: '2 days ago',
        date: 'Feb 5, 2026',
        isRead: true,
      ),
      _NotificationData(
        id: '5',
        type: NotificationType.review,
        title: 'Rate Your Experience',
        message: 'How was your visit with Dr. Robert Wilson? Share your feedback.',
        time: '3 days ago',
        date: 'Feb 4, 2026',
        isRead: true,
        actions: [
          {'label': 'Rate Now', 'isPrimary': true},
          {'label': 'Later', 'isPrimary': false},
        ],
      ),
    ];
  }

  List<_NotificationData> _getDoctorNotifications() {
    return [
      _NotificationData(
        id: '1',
        type: NotificationType.appointment,
        title: 'New Appointment Request',
        message: 'Sarah Johnson has requested an appointment for tomorrow at 2:00 PM.',
        time: '1 hour ago',
        date: 'Today',
        isRead: false,
        actions: [
          {'label': 'Accept', 'isPrimary': true},
          {'label': 'Decline', 'isPrimary': false},
        ],
      ),
      _NotificationData(
        id: '2',
        type: NotificationType.reminder,
        title: 'Upcoming Appointment',
        message: 'You have an appointment with Robert Williams in 30 minutes.',
        time: '3 hours ago',
        date: 'Today',
        isRead: false,
      ),
      _NotificationData(
        id: '3',
        type: NotificationType.cancellation,
        title: 'Appointment Cancelled',
        message: 'Lisa Anderson has cancelled her appointment scheduled for Feb 10.',
        time: '5 hours ago',
        date: 'Today',
        isRead: true,
      ),
      _NotificationData(
        id: '4',
        type: NotificationType.message,
        title: 'New Message',
        message: 'You have a new message from patient John Doe regarding medication dosage.',
        time: '1 day ago',
        date: 'Yesterday',
        isRead: true,
        actions: [
          {'label': 'Reply', 'isPrimary': true},
        ],
      ),
      _NotificationData(
        id: '5',
        type: NotificationType.report,
        title: 'Lab Results Ready',
        message: 'Lab results for patient Emma Thompson are now available for review.',
        time: '2 days ago',
        date: 'Feb 5, 2026',
        isRead: true,
        actions: [
          {'label': 'View Results', 'isPrimary': true},
        ],
      ),
    ];
  }

  List<_NotificationData> _getHospitalNotifications() {
    return [
      _NotificationData(
        id: '1',
        type: NotificationType.appointment,
        title: 'New Appointment Booked',
        message: '5 new appointments have been scheduled for today across all departments.',
        time: '30 minutes ago',
        date: 'Today',
        isRead: false,
        actions: [
          {'label': 'View All', 'isPrimary': true},
        ],
      ),
      _NotificationData(
        id: '2',
        type: NotificationType.emergency,
        title: 'Emergency Alert',
        message: 'Emergency department at 90% capacity. Additional staff may be required.',
        time: '2 hours ago',
        date: 'Today',
        isRead: false,
        actions: [
          {'label': 'View Status', 'isPrimary': true},
        ],
      ),
      _NotificationData(
        id: '3',
        type: NotificationType.payment,
        title: 'Payment Received',
        message: 'Payment of \$2,450.00 received from insurance company for claim #CLM789.',
        time: '4 hours ago',
        date: 'Today',
        isRead: true,
      ),
      _NotificationData(
        id: '4',
        type: NotificationType.general,
        title: 'System Maintenance',
        message: 'Scheduled maintenance on Feb 10, 2026 from 2:00 AM to 4:00 AM.',
        time: '1 day ago',
        date: 'Yesterday',
        isRead: true,
      ),
      _NotificationData(
        id: '5',
        type: NotificationType.review,
        title: 'New Reviews',
        message: '12 new patient reviews have been posted. Overall rating: 4.8 stars.',
        time: '2 days ago',
        date: 'Feb 5, 2026',
        isRead: true,
        actions: [
          {'label': 'View Reviews', 'isPrimary': true},
        ],
      ),
    ];
  }
}

// Enums and Helper Classes
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

class _NotificationData {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final String time;
  final String date;
  bool isRead;
  final List<Map<String, dynamic>> actions;

  _NotificationData({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.date,
    this.isRead = false,
    this.actions = const [],
  });
}