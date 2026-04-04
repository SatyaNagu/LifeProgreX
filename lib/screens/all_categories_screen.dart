import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../utils/theme_manager.dart';
import '../utils/premium_background.dart';
import '../services/activity_service.dart';
import '../models/activity_model.dart';
import '../auth_service.dart';
import 'package:intl/intl.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  String selectedDate = 'Today';

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager();
    final isDark = themeManager.isDarkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF16102B);
    final subTextColor = isDark ? Colors.white.withValues(alpha: 0.5) : const Color(0xFF16102B).withValues(alpha: 0.5);

    final user = AuthService().currentUser;
    if (user == null) return const PremiumBackground(child: Scaffold(body: Center(child: Text("Please login"))));

    return PremiumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: _buildLogActivityFAB(context),
        body: SafeArea(
          child: StreamBuilder<List<ActivityLog>>(
            stream: ActivityService.listenToActivities(user.uid),
            builder: (context, snapshot) {
              final activities = snapshot.data ?? [];
              final filteredActivities = _filterActivitiesByDate(activities, selectedDate);
              
              // Calculate metrics from today's logs for the summary grid
              final todayLogs = _filterActivitiesByDate(activities, 'Today');
              final totalDuration = todayLogs.fold(0, (sum, log) => sum + (log.duration ?? 0));
              final totalTasks = todayLogs.length;

              return Column(
                children: [
                  _buildHeader(context, textColor),
                  _buildDateSwitcher(isDark, textColor),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSummaryGrid(isDark, textColor, subTextColor, totalDuration, totalTasks),
                          const SizedBox(height: 32),
                          _buildRecentActivitySection(isDark, textColor, subTextColor, filteredActivities),
                          const SizedBox(height: 100), // Space for FAB
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color textColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 4),
          Text(
            'Daily Activity',
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  List<ActivityLog> _filterActivitiesByDate(List<ActivityLog> logs, String dateLabel) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));

    DateTime target;
    if (dateLabel == 'Yesterday') {
      target = yesterday;
    } else if (dateLabel == 'Tomorrow') {
      target = tomorrow;
    } else {
      target = today;
    }

    return logs.where((log) {
      final logDate = DateTime(log.createdAt.year, log.createdAt.month, log.createdAt.day);
      return logDate.isAtSameMomentAs(target);
    }).toList();
  }

  Widget _buildDateSwitcher(bool isDark, Color textColor) {
    final dates = ['Yesterday', 'Today', 'Tomorrow'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: dates.map((date) {
            final isSelected = selectedDate == date;
            return GestureDetector(
              onTap: () => setState(() => selectedDate = date),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isSelected ? const LinearGradient(
                    colors: [Color(0xFFA855F7), Color(0xFFE879F9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ) : null,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: const Color(0xFFA855F7).withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ] : [],
                ),
                child: Text(
                  date,
                  style: TextStyle(
                    color: isSelected ? Colors.white : textColor.withValues(alpha: 0.4),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryGrid(bool isDark, Color textColor, Color subTextColor, int totalDuration, int totalTasks) {
    // 5 kcal per minute focus estimate
    final calories = totalDuration * 5; 
    
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.85,
      children: [
        _buildSummaryCard(
          'Active Burn',
          '$calories',
          'kcal',
          Icons.local_fire_department,
          const Color(0xFFFF5B5B),
          isDark 
            ? [const Color(0xFF3D1F1A).withValues(alpha: 0.4), const Color(0xFF221110).withValues(alpha: 0.4)]
            : [const Color(0xFFFFEEEA), const Color(0xFFFFEEEA).withValues(alpha: 0.4)],
          isDark, textColor, subTextColor,
          progress: (calories / 500).clamp(0.0, 1.0), // Target 500 kcal
        ),
        _buildSummaryCard(
          'Focus Time',
          '$totalDuration',
          'min',
          Icons.timer_outlined,
          const Color(0xFF8CE063),
          isDark 
            ? [const Color(0xFF1E2F1A).withValues(alpha: 0.4), const Color(0xFF0F180D).withValues(alpha: 0.4)]
            : [const Color(0xFFF1F8E9), const Color(0xFFF1F8E9).withValues(alpha: 0.4)],
          isDark, textColor, subTextColor,
          progress: (totalDuration / 120).clamp(0.0, 1.0), // Target 120 min
        ),
        _buildSummaryCard(
          'Wellness',
          '$totalTasks',
          'tasks',
          Icons.favorite,
          const Color(0xFFFF5BAE),
          isDark 
            ? [const Color(0xFF3D1A2F).withValues(alpha: 0.4), const Color(0xFF1F0D18).withValues(alpha: 0.4)]
            : [const Color(0xFFFCE4EC), const Color(0xFFFCE4EC).withValues(alpha: 0.4)],
          isDark, textColor, subTextColor,
          progress: (totalTasks / 5).clamp(0.0, 1.0), // Target 5 tasks
        ),
        _buildSummaryCard(
          'Consistency',
          '${(totalTasks > 0 ? 100 : 0)}',
          '%',
          Icons.auto_awesome,
          const Color(0xFFAF52DE),
          isDark 
            ? [const Color(0xFF261A3D).withValues(alpha: 0.4), const Color(0xFF130D1F).withValues(alpha: 0.4)]
            : [const Color(0xFFF3E5F5), const Color(0xFFF3E5F5).withValues(alpha: 0.4)],
          isDark, textColor, subTextColor,
          progress: totalTasks > 0 ? 1.0 : 0.0,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String label, 
    String value, 
    String unit, 
    IconData icon, 
    Color iconColor,
    List<Color> gradient,
    bool isDark, 
    Color textColor, 
    Color subTextColor,
    {double? progress}
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.05 : 0.05), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey.shade800,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (progress != null)
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 5,
                      backgroundColor: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                      valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              color: isDark ? Colors.white38 : Colors.grey.shade500,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection(bool isDark, Color textColor, Color subTextColor, List<ActivityLog> filteredActivities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            "$selectedDate's Activity",
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (filteredActivities.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.history, color: textColor.withValues(alpha: 0.1), size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'No activities found for $selectedDate',
                    style: TextStyle(color: subTextColor, fontSize: 14),
                  ),
                ],
              ),
            ),
          )
        else
          ...filteredActivities.map((log) {
            final emoji = log.data['emoji'] ?? '';
            final typeDisplay = log.type.length > 1 
                ? '${log.type[0].toUpperCase()}${log.type.substring(1)}' 
                : log.type;
            
            // If value is specific (like "Great" for mood), use it as the main title with the emoji
            final mainTitle = log.value != null ? '$emoji ${log.value}' : '$emoji $typeDisplay';
            final metric = log.duration != null ? '${log.duration} min' : '';

            return _buildActivityItem(
              mainTitle, 
              metric, 
              _getActivityIcon(log.type), 
              _getActivityColor(log.type), 
              isDark, textColor, subTextColor, 
              DateFormat('h:mm a').format(log.createdAt),
              note: log.notes,
            );
          }),
      ],
    );
  }

  IconData _getActivityIcon(String type) {
    final t = type.toLowerCase();
    if (t.contains('workout')) return Icons.fitness_center_rounded;
    if (t.contains('read')) return Icons.menu_book_rounded;
    if (t.contains('mood')) return Icons.sentiment_satisfied_rounded;
    if (t.contains('meditation')) return Icons.spa_rounded;
    if (t.contains('water')) return Icons.opacity;
    if (t.contains('sleep')) return Icons.bedtime_rounded;
    return Icons.bolt_rounded;
  }

  Color _getActivityColor(String type) {
    final t = type.toLowerCase();
    if (t.contains('workout')) return const Color(0xFFFF5B5B);
    if (t.contains('read')) return const Color(0xFF06B6D4);
    if (t.contains('mood')) return const Color(0xFFA855F7);
    if (t.contains('meditation')) return const Color(0xFF10B981);
    if (t.contains('water')) return const Color(0xFF3B82F6);
    if (t.contains('sleep')) return const Color(0xFF6366F1);
    return const Color(0xFFA855F7);
  }

  Widget _buildActivityItem(
    String name, 
    String metric, 
    IconData icon, 
    Color iconColor, 
    bool isDark, 
    Color textColor, 
    Color subTextColor,
    String time, {
    String? note,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        borderRadius: 20,
        opacity: isDark ? 0.05 : 0.4,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: iconColor.withValues(alpha: 0.2), width: 1),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    note != null && note.isNotEmpty ? note : time,
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (metric.isNotEmpty)
                  Text(
                    metric,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                if (note != null && note.isNotEmpty)
                  Text(
                    time,
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogActivityFAB(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFA855F7), Color(0xFF06B6D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA855F7).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.add_rounded, color: Colors.white, size: 24),
                SizedBox(width: 8),
                Text(
                  'Log Activity',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
