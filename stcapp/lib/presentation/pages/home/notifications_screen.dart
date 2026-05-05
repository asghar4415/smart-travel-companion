import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<_DestinationNotification> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = _buildMockNotifications();
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications
          .map((notification) => notification.copyWith(isRead: true))
          .toList();
    });
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  List<_DestinationNotification> _buildMockNotifications() {
    final now = DateTime.now();

    return [
      _DestinationNotification(
        placeName: 'Bali',
        message: 'A new tropical destination has been added to explore.',
        arrivedAt: now.subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      _DestinationNotification(
        placeName: 'Swiss Alps',
        message: 'A scenic mountain destination is now available.',
        arrivedAt: now.subtract(const Duration(days: 1, hours: 3)),
        isRead: false,
      ),
      _DestinationNotification(
        placeName: 'Cappadocia',
        message: 'A cultural hot-air balloon destination has been added.',
        arrivedAt: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
      _DestinationNotification(
        placeName: 'Santorini',
        message: 'A beautiful island destination has just arrived.',
        arrivedAt: now.subtract(const Duration(days: 4)),
        isRead: true,
      ),
      _DestinationNotification(
        placeName: 'Kyoto',
        message: 'A historical destination has been added to the list.',
        arrivedAt: now.subtract(const Duration(days: 6)),
        isRead: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((item) => !item.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: unreadCount == 0 ? null : _markAllAsRead,
              icon: const Icon(Icons.done_all, size: 18),
              label: const Text('Mark all read'),
            ),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? const Center(child: Text('No notifications yet'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final notification = _notifications[index];

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: notification.isRead
                        ? Theme.of(context).cardColor
                        : AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: notification.isRead
                          ? AppColors.divider
                          : AppColors.primary.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        notification.isRead
                            ? Icons.notifications_none
                            : Icons.notifications_active_outlined,
                        color: notification.isRead
                            ? AppColors.textLight
                            : AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New destination: ${notification.placeName}',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notification.message,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Arrived: ${_formatDate(notification.arrivedAt)}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.textLight),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: notification.isRead
                              ? AppColors.success.withValues(alpha: 0.12)
                              : AppColors.warning.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          notification.isRead ? 'Read' : 'Unread',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: notification.isRead
                                    ? AppColors.success
                                    : AppColors.warning,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _DestinationNotification {
  final String placeName;
  final String message;
  final DateTime arrivedAt;
  final bool isRead;

  const _DestinationNotification({
    required this.placeName,
    required this.message,
    required this.arrivedAt,
    required this.isRead,
  });

  _DestinationNotification copyWith({bool? isRead}) {
    return _DestinationNotification(
      placeName: placeName,
      message: message,
      arrivedAt: arrivedAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
