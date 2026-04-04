import 'package:flutter/material.dart';
import '../services/achievement_service.dart';
import '../widgets/achievement_card.dart';
import '../utils/theme_manager.dart';
import '../utils/premium_background.dart';
import 'achievements_screen.dart';

class MyAchievementsScreen extends StatefulWidget {
  const MyAchievementsScreen({super.key});

  @override
  State<MyAchievementsScreen> createState() => _MyAchievementsScreenState();
}

class _MyAchievementsScreenState extends State<MyAchievementsScreen> {
  final AchievementService achievementService = AchievementService();
  final ThemeManager themeManager = ThemeManager();
  bool _isSyncing = false;

  Future<void> _handleSync() async {
    setState(() => _isSyncing = true);
    
    try {
      await achievementService.refreshAllAchievements();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Achievements updated successfully! 🏆'),
            backgroundColor: Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeManager.isDarkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final cardBgColor = isDark ? const Color(0xFF141414) : Colors.white;

    return PremiumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 20),
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: cardBgColor.withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          title: Text(
            'My Hall of Fame',
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            if (_isSyncing)
              const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF13C6DF)),
                ),
              )
            else
              IconButton(
                onPressed: _handleSync,
                icon: const Icon(Icons.sync, color: Color(0xFF13C6DF)),
                tooltip: 'Sync Achievements',
              ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AchievementsScreen()),
                );
              },
              child: const Text(
                'Full List',
                style: TextStyle(color: Color(0xFF13C6DF), fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: achievementService.getEarnedAchievementsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6)));
            }

            final earned = snapshot.data ?? [];

            if (earned.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: textColor.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.emoji_events_outlined, color: textColor.withValues(alpha: 0.2), size: 64),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No achievements yet',
                      style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your earned badges will appear here.',
                      style: TextStyle(color: textColor.withValues(alpha: 0.5), fontSize: 14),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isSyncing ? null : _handleSync,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(_isSyncing ? 'Syncing...' : 'Check Progress'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              itemCount: earned.length,
              itemBuilder: (context, index) {
                final item = earned[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: AchievementCard(
                    definition: item['definition'],
                    progress: item['progress'],
                    isDark: isDark,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
