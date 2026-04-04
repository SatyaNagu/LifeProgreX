import 'package:flutter/material.dart';
import '../models/achievement_model.dart';
import '../services/achievement_service.dart';
import '../widgets/achievement_card.dart';
import '../utils/theme_manager.dart';
import '../utils/premium_background.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> with SingleTickerProviderStateMixin {
  final AchievementService _achievementService = AchievementService();
  final ThemeManager _themeManager = ThemeManager();
  late TabController _tabController;
  int _konamiCounter = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: AchievementCategory.values.length, vsync: this);
    
    // Auto-trigger backfill on first load to reward existing users
    _achievementService.refreshAllAchievements();
  }

  void _handleKonamiTap() {
    setState(() {
      _konamiCounter++;
      if (_konamiCounter >= 10) {
        _achievementService.notifyActivity('hidden_konami');
        _konamiCounter = 0;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('👾 Logic is for mortals. You are a Legend! (Konami Code Unlocked)'),
            backgroundColor: Color(0xFF8B5CF6),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeManager.isDarkMode;
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
          title: GestureDetector(
            onTap: _handleKonamiTap,
            child: Text(
              'Achievements',
              style: TextStyle(
                color: textColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: textColor, size: 20),
              onPressed: () {
                _achievementService.refreshAllAchievements();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Syncing your achievements...')),
                );
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: const Color(0xFF8B5CF6),
            indicatorWeight: 3,
            labelColor: textColor,
            unselectedLabelColor: textColor.withValues(alpha: 0.5),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: AchievementCategory.values.map((cat) {
              return Tab(text: cat.toString().split('.').last.toUpperCase());
            }).toList(),
          ),
        ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _achievementService.getAchievementsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6)));
            }

            final allAchievements = snapshot.data ?? [];

            return TabBarView(
              controller: _tabController,
              children: AchievementCategory.values.map((category) {
                final categoryAchievements = allAchievements.where(
                  (a) => (a['definition'] as AchievementDefinition).category == category
                ).toList();

                if (categoryAchievements.isEmpty) {
                  return Center(
                    child: Text(
                      'No achievements in this category yet.',
                      style: TextStyle(color: textColor.withValues(alpha: 0.5)),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: categoryAchievements.length,
                  itemBuilder: (context, index) {
                    final item = categoryAchievements[index];
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
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
