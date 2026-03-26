import 'package:flutter/material.dart';
import '../utils/theme_manager.dart';
import '../utils/premium_background.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ThemeManager _themeManager = ThemeManager();

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(_updateTheme);
  }

  @override
  void dispose() {
    _themeManager.removeListener(_updateTheme);
    super.dispose();
  }

  void _updateTheme() {
    if (mounted) setState(() {});
  }

  // Dummy data representing notifications
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Meditation Streak!',
      'time': '2m ago',
      'message': 'You\'ve meditated for 7 days in a row. Keep it up! 🧘‍♂️',
      'icon': Icons.bolt,
      'iconColor': const Color(0xFFFFBF00), // Yellow
      'isUnread': true,
    },
    {
      'title': 'New Badge Unlocked',
      'time': '1h ago',
      'message': 'You earned the \'Early Bird\' badge for logging in before 8 AM.',
      'icon': Icons.verified_outlined,
      'iconColor': const Color(0xFF8B5CF6), // Purple
      'isUnread': true,
    },
    {
      'title': 'App Update',
      'time': '5h ago',
      'message': 'LifeProgreX v2.0 is here with new AI features.',
      'icon': Icons.error_outline,
      'iconColor': const Color(0xFF6B7280), // Grey
      'isUnread': false,
    },
    {
      'title': 'Community Challenge',
      'time': '1d ago',
      'message': 'Join the \'30 Days of Reading\' challenge starting tomorrow!',
      'icon': Icons.chat_bubble_outline,
      'iconColor': const Color(0xFF13C6DF), // Blue
      'isUnread': false,
    },
  ];

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n['isUnread'] = false;
      }
    });
  }

  void _clearAll() {
    setState(() {
      _notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeManager.isDarkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subTextColor = isDark ? Colors.white54 : const Color(0xFF6B7280);

    return PremiumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    // Back Button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark 
                              ? Colors.white.withValues(alpha: 0.1) 
                              : Colors.white.withValues(alpha: 0.8),
                          border: Border.all(
                            color: (isDark ? Colors.white : Colors.black)
                                .withValues(alpha: isDark ? 0.05 : 0.05),
                          ),
                          boxShadow: isDark ? null : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: textColor,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Title
                    Text(
                      'Notifications',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    // Mark read
                    GestureDetector(
                      onTap: _markAllAsRead,
                      child: const Text(
                        'Mark read',
                        style: TextStyle(
                          color: Color(0xFF8B5CF6),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 16,
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
                    ),
                    const SizedBox(width: 8),
                    // Delete
                    GestureDetector(
                      onTap: _clearAll,
                      child: Icon(
                        Icons.delete_outline,
                        color: subTextColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // Notifications List
              Expanded(
                child: _notifications.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_off_outlined,
                              size: 64,
                              color: subTextColor.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No new notifications',
                              style: TextStyle(
                                color: subTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        physics: const BouncingScrollPhysics(),
                        itemCount: _notifications.length,
                        itemBuilder: (context, index) {
                          final notif = _notifications[index];
                          return _buildNotificationCard(
                            notif,
                            isDark,
                            textColor,
                            subTextColor,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    Map<String, dynamic> notif,
    bool isDark,
    Color textColor,
    Color subTextColor,
  ) {
    final bool isUnread = notif['isUnread'];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark 
            ? Colors.white.withValues(alpha: 0.08) 
            : Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.4),
          width: 1.5,
        ),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark 
                      ? Colors.white.withValues(alpha: 0.05) 
                      : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark 
                        ? Colors.transparent 
                        : Colors.grey.withValues(alpha: 0.1),
                  ),
                  boxShadow: isDark ? null : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  notif['icon'],
                  color: notif['iconColor'],
                  size: 24,
                ),
              ),
              if (isUnread)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF2D95), // Pink dot
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content Area
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notif['title'],
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      notif['time'],
                      style: TextStyle(
                        color: subTextColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  notif['message'],
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
    );
  }
}
