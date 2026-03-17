import 'package:flutter/material.dart';
import '../services/activity_service.dart';
import '../models/activity_model.dart';
import '../auth_service.dart';
import '../widgets/glass_card.dart';
import '../utils/premium_background.dart';
import 'package:intl/intl.dart';

class ActivityTimelineScreen extends StatelessWidget {
  final String? typeFilter;
  final String? categoryName;

  const ActivityTimelineScreen({
    super.key, 
    this.typeFilter,
    this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    if (user == null) {
      return const _ErrorScreen(message: 'User not logged in');
    }

    return PremiumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(context),
        body: StreamBuilder<List<ActivityLog>>(
          stream: ActivityService.listenToActivities(user.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _ErrorScreen(message: snapshot.error.toString());
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6)));
            }

            var logs = snapshot.data!;
            if (typeFilter != null) {
              logs = logs.where((log) => log.type.toLowerCase() == typeFilter!.toLowerCase()).toList();
            }

            if (logs.isEmpty) {
              return const _EmptyTimeline();
            }

            final groupedLogs = _groupLogsByDate(logs);

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: groupedLogs.length,
              itemBuilder: (context, index) {
                final dateGroup = groupedLogs.keys.elementAt(index);
                final groupLogs = groupedLogs[dateGroup]!;

                return _DateSection(
                  title: dateGroup,
                  logs: groupLogs,
                );
              },
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        categoryName != null ? '$categoryName Activity' : 'Activity Timeline',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }

  Map<String, List<ActivityLog>> _groupLogsByDate(List<ActivityLog> logs) {
    final Map<String, List<ActivityLog>> groups = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var log in logs) {
      final logDate = DateTime(log.createdAt.year, log.createdAt.month, log.createdAt.day);
      String label;
      if (logDate == today) {
        label = 'Today';
      } else if (logDate == yesterday) {
        label = 'Yesterday';
      } else {
        label = DateFormat('MMMM d, y').format(logDate);
      }

      if (!groups.containsKey(label)) {
        groups[label] = [];
      }
      groups[label]!.add(log);
    }
    return groups;
  }
}

class _DateSection extends StatelessWidget {
  final String title;
  final List<ActivityLog> logs;

  const _DateSection({required this.title, required this.logs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...logs.map((log) => _ActivityTile(log: log)),
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final ActivityLog log;

  const _ActivityTile({required this.log});

  @override
  Widget build(BuildContext context) {
    final iconData = _getIcon(log.type);
    final color = _getColor(log.type);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        opacity: 0.05,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(iconData, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    log.type.toUpperCase(),
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    log.value ?? 'Activity Logged',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (log.notes != null && log.notes!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        log.notes!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat('h:mm a').format(log.createdAt),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 12,
                  ),
                ),
                if (log.duration != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${log.duration} min',
                      style: const TextStyle(
                        color: Color(0xFF9FE82E),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type.toLowerCase()) {
      case 'workout': return Icons.fitness_center;
      case 'mood': return Icons.waves;
      case 'reading': return Icons.book;
      case 'water': return Icons.opacity;
      case 'sleep': return Icons.bedtime;
      default: return Icons.bolt;
    }
  }

  Color _getColor(String type) {
    switch (type.toLowerCase()) {
      case 'workout': return const Color(0xFFF98E2F);
      case 'mood': return const Color(0xFF8B5CF6);
      case 'reading': return const Color(0xFF10B981);
      case 'water': return const Color(0xFF3B82F6);
      case 'sleep': return const Color(0xFF6366F1);
      default: return Colors.white;
    }
  }
}

class _ErrorScreen extends StatelessWidget {
  final String message;
  const _ErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Error: $message',
        style: const TextStyle(color: Colors.redAccent),
      ),
    );
  }
}

class _EmptyTimeline extends StatelessWidget {
  const _EmptyTimeline();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, color: Colors.white.withOpacity(0.1), size: 100),
          const SizedBox(height: 24),
          const Text(
            'No activities logged yet',
            style: TextStyle(color: Colors.white54, fontSize: 18),
          ),
          const SizedBox(height: 12),
          const Text(
            'Start tracking to see your timeline!',
            style: TextStyle(color: Colors.white24, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
