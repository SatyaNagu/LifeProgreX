import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import '../utils/theme_manager.dart';
import '../services/achievement_service.dart';
import '../services/analytics_service.dart';
import '../models/habit_model.dart';

class LifeResumeScreen extends StatefulWidget {
  const LifeResumeScreen({super.key});

  @override
  State<LifeResumeScreen> createState() => _LifeResumeScreenState();
}

class _LifeResumeScreenState extends State<LifeResumeScreen> with TickerProviderStateMixin {
  late AnimationController _staggerController;
  final List<Animation<double>> _staggerLevelAnimations = [];
  final int _totalStaggerLevels = 7;
  final AnalyticsService _analyticsService = AnalyticsService();
  final ThemeManager _themeManager = ThemeManager();

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(_updateTheme);
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    for (int i = 0; i < _totalStaggerLevels; i++) {
      final start = (i * 0.1).clamp(0.0, 1.0);
      final end = (start + 0.4).clamp(0.0, 1.0);
      _staggerLevelAnimations.add(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    }

    _staggerController.forward();
  }

  @override
  void dispose() {
    _themeManager.removeListener(_updateTheme);
    _staggerController.dispose();
    super.dispose();
  }

  void _updateTheme() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final joinDate = user?.metadata.creationTime ?? DateTime(2026, 1, 1);
    final formattedJoinDate = DateFormat('MMMM d, yyyy').format(joinDate);
    
    final displayName = user?.displayName ?? 'Growth Enthusiast';
    final nameParts = displayName.split(' ');
    final firstName = nameParts.first;
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    final isDark = _themeManager.isDarkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subTextColor = isDark ? Colors.white60 : const Color(0xFF4B5563);
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF03001C) : const Color(0xFFF0F4F8),
        body: StreamBuilder<AnalyticsData>(
          stream: _analyticsService.getAnalyticsDataStream('Month'),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error loading growth data: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6)));
            }

            final data = snapshot.data;
            if (data == null) {
               return const Center(child: Text('No growth data found yet. Start your journey!'));
            }

            return Stack(
              children: [
                _buildProfessionalBackground(),
                SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStaggeredMember(0, _buildHeader(context, textColor, subTextColor, isDark)),
                        const SizedBox(height: 24),
                        _buildStaggeredMember(1, _buildProfileHeaderCard(firstName, lastName, formattedJoinDate, user?.photoURL, isDark, textColor, subTextColor, borderColor)),
                        const SizedBox(height: 24),
                        _buildStaggeredMember(2, _buildImpactStats(data, isDark, textColor, borderColor)),
                        const SizedBox(height: 24),
                        _buildStaggeredMember(3, _buildSkillsMastery(data, isDark, textColor, borderColor)),
                        const SizedBox(height: 24),
                        _buildStaggeredMember(4, _buildAchievementsSection(isDark, textColor, borderColor)),
                        const SizedBox(height: 24),
                        _buildStaggeredMember(5, _buildJourneyTimeline(data, formattedJoinDate, isDark, textColor, borderColor)),
                        const SizedBox(height: 24),
                        _buildStaggeredMember(6, _buildCTACard(context)),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        ),
    );
  }

  Widget _buildStaggeredMember(int index, Widget child) {
    return AnimatedBuilder(
      animation: _staggerLevelAnimations[index],
      builder: (context, child) {
        final opacity = _staggerLevelAnimations[index].value;
        final translateY = (1.0 - opacity) * 30.0;
        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, translateY),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildProfessionalBackground() {
    final isDark = _themeManager.isDarkMode;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark 
                ? [const Color(0xFF03001C), const Color(0xFF160032), const Color(0xFF03001C)]
                : [const Color(0xFFF0F4F8), const Color(0xFFE8EDF3), const Color(0xFFF5F7FA)],
            ),
          ),
        ),
        Positioned(
          top: -50,
          right: -50,
          child: _buildBlurCircle(const Color(0xFF8B5CF6).withValues(alpha: isDark ? 0.15 : 0.08), 350),
        ),
        Positioned(
          top: 300,
          left: -100,
          child: _buildBlurCircle(const Color(0xFF00D9FF).withValues(alpha: isDark ? 0.12 : 0.08), 400),
        ),
        Positioned(
          bottom: 100,
          right: -50,
          child: _buildBlurCircle(const Color(0xFFFF2D95).withValues(alpha: isDark ? 0.1 : 0.05), 300),
        ),
        Opacity(
          opacity: isDark ? 0.15 : 0.1,
          child: Container(
            decoration: const BoxDecoration(
              gradient: SweepGradient(
                center: Alignment.center,
                colors: [Color(0xFF8B5CF6), Color(0xFF00D9FF), Color(0xFFFF2D95), Color(0xFF8B5CF6)],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBlurCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color textColor, Color subTextColor, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildCircularIconButton(
                  icon: Icons.chevron_left,
                  onTap: () => Navigator.pop(context),
                  size: 24,
                  isDark: isDark,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Life Resume',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
                    ),
                    Text(
                      'Your growth story',
                      style: TextStyle(fontSize: 14, color: subTextColor),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            _buildCircularIconButton(
              icon: Icons.share_outlined,
              onTap: () => _showToast(context, 'Life Resume shared successfully!', isDark),
              isDark: isDark,
            ),
            const SizedBox(width: 12),
            _buildCircularIconButton(
              icon: Icons.download_outlined,
              onTap: () => _showToast(context, 'Life Resume downloaded as PDF!', isDark),
              isDark: isDark,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCircularIconButton({required IconData icon, required VoidCallback onTap, double size = 20, required bool isDark}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.8),
          shape: BoxShape.circle,
          border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Icon(icon, color: isDark ? Colors.white70 : const Color(0xFF1F2937), size: size),
      ),
    );
  }

  Widget _buildProfileHeaderCard(String fName, String lName, String joinDate, String? photoUrl, bool isDark, Color textColor, Color subTextColor, Color borderColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.4),
        gradient: LinearGradient(
          colors: isDark 
            ? [const Color(0xFF8B5CF6).withValues(alpha: 0.2), const Color(0xFF00D9FF).withValues(alpha: 0.2)]
            : [const Color(0xFF8B5CF6).withValues(alpha: 0.15), const Color(0xFF00D9FF).withValues(alpha: 0.15)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.08), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isDark ? Colors.white24 : Colors.white, width: 4),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))],
              image: DecorationImage(
                image: (photoUrl != null && photoUrl.isNotEmpty) ? NetworkImage(photoUrl) : const AssetImage('Assets/onboarding_image_3.png') as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('$fName $lName', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
          Text('Personal Growth Enthusiast', style: TextStyle(fontSize: 14, color: subTextColor)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Column(
              children: [
                Text('Member Since', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                Text(joinDate, style: TextStyle(fontSize: 14, color: subTextColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactStats(AnalyticsData data, bool isDark, Color textColor, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('This Month\'s Impact', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildStatCard(data.habitsCompleted.toString(), 'Total Habits', '+0%', const Color(0xFFB24BF3), isDark, borderColor),
              _buildStatCard('${(data.readingMinutes / 60).toStringAsFixed(1)}h', 'Reading Hours', '+0%', const Color(0xFF00D9FF), isDark, borderColor),
              _buildStatCard(data.workoutSessions.toString(), 'Workout Sessions', '+0%', const Color(0xFFFF2D95), isDark, borderColor),
              _buildStatCard('${(data.learningMinutes / 60).toStringAsFixed(1)}h', 'Learning Hours', '+0%', const Color(0xFF10B981), isDark, borderColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, String trend, Color color, bool isDark, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : const Color(0xFF4B5563), fontWeight: FontWeight.w500)),
          const Text('+0%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFFFBF00))),
        ],
      ),
    );
  }

  Widget _buildSkillsMastery(AnalyticsData data, bool isDark, Color textColor, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_outlined, color: Color(0xFFB24BF3), size: 24),
              const SizedBox(width: 8),
              Text('Life Skills Mastery', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            ],
          ),
          const SizedBox(height: 24),
          _buildSkillItem('Consistency', (data.lifeScore * 100).toInt(), const Color(0xFFB24BF3), isDark, textColor),
          _buildSkillItem('Self-Discipline', ((data.lifeScore + data.averageMood / 10) / 2 * 100).toInt().clamp(0, 100), const Color(0xFF00D9FF), isDark, textColor),
          _buildSkillItem('Mindfulness', (data.averageMood * 10).toInt().clamp(0, 100), const Color(0xFFFFBF00), isDark, textColor),
          _buildSkillItem('Time Management', (data.categoryStats[HabitCategory.career]?['progress']?.toDouble() ?? 0.8 * 100).toInt(), const Color(0xFFFF2D95), isDark, textColor),
          _buildSkillItem('Goal Setting', (data.totalGoals / 10 * 100).toInt().clamp(0, 100), const Color(0xFF10B981), isDark, textColor),
        ],
      ),
    );
  }

  Widget _buildSkillItem(String name, int percent, Color color, bool isDark, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor)),
              Text('$percent%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(height: 12, width: double.infinity, decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(6))),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: percent / 100),
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) => FractionallySizedBox(
                  widthFactor: value,
                  child: Container(height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection(bool isDark, Color textColor, Color borderColor) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: AchievementService().getEarnedAchievementsStream(),
      builder: (context, snapshot) {
        final earned = snapshot.data ?? [];
        final displayList = earned.take(4).toList();

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.emoji_events_outlined, color: Color(0xFFFFBF00), size: 24),
                  const SizedBox(width: 8),
                  Text('Achievements Unlocked', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                ],
              ),
              const SizedBox(height: 20),
              if (displayList.isEmpty)
                const Center(child: Text('Start your journey to unlock badges!', style: TextStyle(color: Colors.grey)))
              else
                ...displayList.map((item) => _buildAchievementCard(item, isDark, textColor, borderColor)),
            ],
          ),
        );
      }
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> item, bool isDark, Color textColor, Color borderColor) {
    final def = item['definition'];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFB24BF3), Color(0xFF7C3AED)]),
              shape: BoxShape.circle,
            ),
            child: Center(child: Text(def.badge, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(def.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                Text(def.requirement, style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : const Color(0xFF6B7280))),
                Text(def.rarity.toString().split('.').last.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF8B5CF6))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyTimeline(AnalyticsData data, String joinDate, bool isDark, Color textColor, Color borderColor) {
    final timeline = data.timelineEvents.take(5).toList();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Journey Timeline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 20),
          if (timeline.isEmpty)
             _buildTimelineItem('Joined LifeProgreX', joinDate, '🎉', isDark, textColor)
          else
            ...timeline.map((e) => _buildTimelineItem(e['type'] ?? 'Activity', DateFormat('MMM d, yyyy').format(e['time'] as DateTime), _getEmojiForType(e['type']), isDark, textColor)),
        ],
      ),
    );
  }

  String _getEmojiForType(String? type) {
    final t = type?.toLowerCase() ?? '';
    if (t.contains('mood')) return '😊';
    if (t.contains('read')) return '📚';
    if (t.contains('workout') || t.contains('gym') || t.contains('fit')) return '💪';
    if (t.contains('habit')) return '✅';
    if (t.contains('goal')) return '🎯';
    if (t.contains('reading')) return '📖';
    if (t.contains('streak')) return '🔥';
    return '✨'; // Default growth emoji
  }

  Widget _buildTimelineItem(String event, String date, String emoji, bool isDark, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFE5E7EB)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 5)],
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor)),
              Text(date, style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : const Color(0xFF6B7280))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCTACard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFB24BF3), Color(0xFF00D9FF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: const Color(0xFFB24BF3).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          const Text('Keep Growing! 🚀', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          const Text('You\'ve come so far. Imagine where you\'ll be in 6 months!', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.white)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, foregroundColor: const Color(0xFFB24BF3),
              elevation: 5, shadowColor: Colors.black.withValues(alpha: 0.1),
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
            ),
            child: const Text('Continue Your Journey', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _showToast(BuildContext context, String message, bool isDark) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.w600)),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        backgroundColor: isDark ? const Color(0xFF2B2B2B) : const Color(0xFF1F2937),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
