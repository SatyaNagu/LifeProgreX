import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/notification_service.dart';
import '../models/notification_model.dart';
import '../utils/theme_manager.dart';
import '../utils/premium_background.dart';
import '../widgets/glass_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = NotificationService();
  final ThemeManager _themeManager = ThemeManager();

  @override
  Widget build(BuildContext context) {
    final isDark = _themeManager.isDarkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subTextColor = isDark ? Colors.white54 : Colors.grey.shade600;

    return PremiumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(context, textColor, isDark),
        body: StreamBuilder<List<NotificationModel>>(
          stream: _notificationService.getNotificationsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6)));
            }

            final notifications = snapshot.data ?? [];

            if (notifications.isEmpty) {
              return _buildEmptyState(textColor, subTextColor);
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationCard(notifications[index], textColor, subTextColor, isDark);
              },
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, Color textColor, bool isDark) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 70,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
              ),
            ),
            child: Icon(Icons.chevron_left, color: textColor, size: 24),
          ),
        ),
      ),
      title: Text(
        'Notifications',
        style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 20),
      ),
      actions: [
        TextButton(
          onPressed: () => _notificationService.markAllAsRead(),
          child: const Text(
            'Mark read',
            style: TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        IconButton(
          onPressed: () => _notificationService.clearAll(),
          icon: Icon(Icons.delete_outline, color: textColor.withValues(alpha: 0.4), size: 22),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildEmptyState(Color textColor, Color subTextColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 80, color: textColor.withValues(alpha: 0.1)),
          const SizedBox(height: 24),
          Text(
            'All caught up!',
            style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new updates.',
            style: TextStyle(color: subTextColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification, Color textColor, Color subTextColor, bool isDark) {
    final timeStr = _formatTimestamp(notification.createdAt);
    final iconData = _getNotificationIcon(notification.type);
    final iconColor = _getNotificationColor(notification.type);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        opacity: isDark ? 0.05 : 0.6,
        borderRadius: 24,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
                    ),
                  ),
                  child: Icon(iconData, color: iconColor, size: 24),
                ),
                if (!notification.isRead)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF2D95),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        timeStr,
                        style: TextStyle(
                          color: subTextColor.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return 'now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    
    return DateFormat('MMM d').format(timestamp);
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.goalComplete: return Icons.emoji_events_outlined;
      case NotificationType.deadlineNear: return Icons.alarm_on_outlined;
      case NotificationType.streakMilestone: return Icons.bolt_outlined;
      case NotificationType.achievementUnlocked: return Icons.workspace_premium_outlined;
      case NotificationType.communityChallenge: return Icons.chat_bubble_outline_outlined;
      default: return Icons.info_outline;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.goalComplete: return const Color(0xFFFFBF00);
      case NotificationType.deadlineNear: return const Color(0xFFFF6B35);
      case NotificationType.streakMilestone: return const Color(0xFF13C6DF);
      case NotificationType.achievementUnlocked: return const Color(0xFF8B5CF6);
      case NotificationType.communityChallenge: return const Color(0xFF00D12E);
      default: return const Color(0xFF8B5CF6);
    }
  }
}
