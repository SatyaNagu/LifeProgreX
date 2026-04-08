import 'package:flutter/material.dart';
import 'profile.dart'; // For navigating to ProfileScreen
import 'settings.dart';
import 'screens/ai_coach_screen.dart';
import 'quicklog_edit/edit_quick_log.dart';
import 'utils/quick_log_manager.dart';
import 'utils/theme_manager.dart';
import 'utils/premium_background.dart';
import 'screens/all_categories_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/goals_screen.dart';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/firestore_service.dart';
import 'models/habit_model.dart';
import 'models/goal_model.dart';
import 'services/goal_service.dart';
import 'services/activity_service.dart';
import 'models/activity_model.dart';
import 'auth_service.dart';
import 'widgets/animated_goals_card.dart';
import 'models/notification_model.dart';
import 'services/notification_service.dart';
import 'screens/notifications_screen.dart';

class LandingScreen extends StatefulWidget {
  final String userName;

  const LandingScreen({super.key, this.userName = 'Nagasai'});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
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

  @override
  Widget build(BuildContext context) {
    final isDark = _themeManager.isDarkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);

    return PremiumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Main content
            SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  Positioned.fill(child: _buildMainContent(textColor, isDark)),

                  // Bottom Navigation Bar
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 30,
                    child: _buildBottomNavigationBar(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(Color textColor, bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),
      child: StreamBuilder<List<HabitModel>>(
        stream: FirestoreService().getHabitsStream(),
        builder: (context, habitSnapshot) {
          return StreamBuilder<List<GoalModel>>(
            stream: GoalService().getGoalsStream(),
            builder: (context, goalSnapshot) {
              final habits = habitSnapshot.data ?? [];
              final goals = goalSnapshot.data ?? [];

              // Habit Stats
              final totalHabits = habits.length;
              final maxStreak = habits.isNotEmpty
                  ? habits.map((h) => h.currentStreak).reduce(max)
                  : 0;
              final activeHabits = habits
                  .where((h) => h.currentStreak > 0)
                  .length;
              final habitScore = totalHabits > 0
                  ? ((activeHabits / totalHabits) * 100).toInt()
                  : 0;

              // Goal Stats (Today)
              final now = DateTime.now();
              final todayGoals = goals
                  .where(
                    (g) =>
                        g.targetDate.year == now.year &&
                        g.targetDate.month == now.month &&
                        g.targetDate.day == now.day,
                  )
                  .toList();
              final totalTodayGoals = todayGoals.length;
              final completedTodayGoals = todayGoals
                  .where((g) => g.isCompleted)
                  .length;

              final user = AuthService().currentUser;

              return StreamBuilder<List<ActivityLog>>(
                stream: user != null
                    ? ActivityService.listenToActivities(user.uid)
                    : Stream.value([]),
                builder: (context, activitySnapshot) {
                  final activities = activitySnapshot.data ?? [];
                  final todayLogs = activities.where((a) {
                    final logDate = DateTime(
                      a.createdAt.year,
                      a.createdAt.month,
                      a.createdAt.day,
                    );
                    final today = DateTime(now.year, now.month, now.day);
                    return logDate.isAtSameMomentAs(today);
                  }).toList();

                  final totalDuration = todayLogs.fold(
                    0,
                    (sum, log) => sum + (log.duration ?? 0),
                  );
                  final totalTasks = todayLogs.length;
                  final calories = totalDuration * 5;

                  final analyticsMathScore = (() {
                     double moodPoints = 0; int moodCount = 0;
                     double workoutPoints = 0; int workoutCount = 0;
                     double skillPoints = 0; int skillCount = 0;

                     for (var a in activities) {
                        final type = a.type.toLowerCase();
                        if (type == 'mood' && a.value != null) {
                           int score = 4;
                           final lbl = a.value!.toLowerCase();
                           if (lbl == 'terrible') score = 0;
                           else if (lbl == 'bad') score = 2;
                           else if (lbl == 'okay') score = 4;
                           else if (lbl == 'good') score = 6;
                           else if (lbl == 'great') score = 8;
                           else if (lbl == 'amazing') score = 10;
                           moodPoints += score;
                           moodCount++;
                        } else if (type.contains('workout') || type.contains('gym') || type.contains('fit')) {
                           double? intensity;
                           if (a.data.containsKey('intensity')) {
                              intensity = double.tryParse(a.data['intensity'].toString());
                           }
                           if (intensity == null && a.value != null) {
                              intensity = double.tryParse(a.value!.toString());
                           }
                           if (intensity != null) { workoutPoints += intensity; workoutCount++; }
                        } else if (type.contains('learn') || type.contains('skill')) {
                           double? sInt;
                           if (a.data.containsKey('points')) {
                              sInt = double.tryParse(a.data['points'].toString());
                           }
                           if (sInt == null && a.duration != null && a.duration! > 0) {
                              sInt = a.duration! / 9.0;
                           }
                           if (sInt != null) { skillPoints += sInt; skillCount++; }
                        }
                     }
                     double avgMood = moodCount > 0 ? (moodPoints / moodCount) * 10 : 0.0;
                     double avgWorkout = workoutCount > 0 ? (workoutPoints / workoutCount) * 10 : 0.0;
                     double avgSkill = skillCount > 0 ? (skillPoints / skillCount) * 10 : 0.0;
                     
                     return ((avgMood + avgWorkout + avgSkill) / 3.0).ceil();
                  })();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(textColor),
                      const SizedBox(height: 24),
                      AnimatedGoalsCard(
                        completedGoals: goals
                            .where((g) => g.isCompleted)
                            .length,
                        totalGoals: goals.length,
                        score: goals.isNotEmpty
                            ? ((goals.where((g) => g.isCompleted).length /
                                          goals.length) *
                                      100)
                                  .toInt()
                            : 0,
                        hasAnyGoals: goals.isNotEmpty,
                        themeManager: _themeManager,
                      ),
                      const SizedBox(height: 32),
                      _buildSectionHeader('Overview', textColor),
                      const SizedBox(height: 16),
                      _buildOverviewGrid(
                        maxStreak: maxStreak,
                        score: analyticsMathScore,
                        totalHabits: activities.length,
                      ),
                      const SizedBox(height: 32),
                      _buildQuickLogHeader(context, textColor),
                      const SizedBox(height: 16),
                      _buildQuickLogList(context),
                      const SizedBox(height: 32),
                      _buildTodayGoalsSection(
                        context,
                        goals,
                        textColor,
                        isDark,
                      ),
                      const SizedBox(height: 32),
                      _buildAiCoachCard(),
                      const SizedBox(height: 12),
                      _buildActionRowItem(
                        icon: Icons.track_changes,
                        color: const Color(0xFF13C6DF),
                        title: 'My Habits',
                        subtitle: '$activeHabits Active Habits',
                        isDark: isDark,
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      _buildActionRowItem(
                        icon: Icons.flag,
                        color: const Color(0xFFFFBF00),
                        title: 'My Goals',
                        subtitle: 'Track your personal goals',
                        isDark: isDark,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GoalsScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildActionRowItem(
                        icon: Icons.bar_chart,
                        color: const Color(0xFF8B5CF6),
                        title: 'Analytics',
                        subtitle: 'View Your Stats',
                        isDark: isDark,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AnalyticsScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildSectionHeader(
                        'Daily Activity',
                        textColor,
                        trailingText: 'SEE ALL >',
                        onTrailingTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllCategoriesScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDailyActivityGrid(
                        calories,
                        totalDuration,
                        totalTasks,
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    Color textColor, {
    String? trailingText,
    VoidCallback? onTrailingTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (trailingText != null)
          GestureDetector(
            onTap: onTrailingTap,
            child: Text(
              trailingText,
              style: const TextStyle(
                color: Color(0xFF8B5CF6),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
      ],
    );
  }

  // --- Today's Priorities (Vanishing Goals) ---
  Widget _buildTodayGoalsSection(
    BuildContext context,
    List<GoalModel> goals,
    Color textColor,
    bool isDark,
  ) {
    final now = DateTime.now();
    final activeTodayGoals = goals
        .where(
          (g) =>
              !g.isCompleted &&
              g.targetDate.year == now.year &&
              g.targetDate.month == now.month &&
              g.targetDate.day == now.day,
        )
        .toList();

    if (activeTodayGoals.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader('Today\'s Priorities', textColor),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFBF00).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${activeTodayGoals.length} Pending',
                style: const TextStyle(
                  color: Color(0xFFFFBF00),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...activeTodayGoals.map(
          (goal) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildGoalActionCard(goal, isDark, textColor),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalActionCard(GoalModel goal, bool isDark, Color textColor) {
    final Map<GoalCategory, String> categoryEmoji = {
      GoalCategory.fitness: 'ðŸ’ª',
      GoalCategory.learning: 'ðŸ“š',
      GoalCategory.wellness: 'â¤ï¸',
      GoalCategory.career: 'ðŸ’¼',
      GoalCategory.habits: 'â­',
      GoalCategory.personal: 'ðŸŽ¯',
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1B113D).withValues(alpha: 0.4)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              HapticFeedback.mediumImpact();
              await GoalService().updateGoal(goal.copyWith(isCompleted: true));
            },
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFFBF00), width: 2),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.transparent,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${categoryEmoji[goal.category] ?? 'ðŸŽ¯'} ${goal.title}',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (goal.description.isNotEmpty)
                  Text(
                    goal.description,
                    style: TextStyle(
                      color: isDark ? Colors.white38 : Colors.grey.shade500,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: isDark ? Colors.white10 : Colors.black12,
            size: 20,
          ),
        ],
      ),
    );
  }

  // --- Header ---
  Widget _buildHeader(Color textColor) {
    final isDark = _themeManager.isDarkMode;
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = "Good Morning";
    } else if (hour < 17) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good Evening";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : const Color(0xFF6B7280),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                (() {
                  final name = FirebaseAuth.instance.currentUser?.displayName;
                  if (name != null && name.trim().isNotEmpty) {
                    return name.split(' ')[0];
                  }
                  return widget.userName.split(' ')[0];
                })(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNotificationIcon(),
            const SizedBox(width: 12),
            _buildProfileIcon(context),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileIcon(BuildContext context) {
    final isDark = _themeManager.isDarkMode;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFF98E2F), // Orange border
            width: 2,
          ),
          image: DecorationImage(
            image:
                (FirebaseAuth.instance.currentUser?.photoURL?.isNotEmpty ??
                    false)
                ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                : const AssetImage('Assets/onboarding_image_3.png')
                      as ImageProvider,
            fit: BoxFit.cover,
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    final isDark = _themeManager.isDarkMode;

    return StreamBuilder<List<NotificationModel>>(
      stream: NotificationService().getNotificationsStream(),
      builder: (context, snapshot) {
        final notifications = snapshot.data ?? [];
        final hasUnread = notifications.any((n) => !n.isRead);

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotificationsScreen(),
            ),
          ),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withValues(
                  alpha: isDark ? 0.2 : 0.05,
                ),
                width: 1,
              ),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  color: isDark ? Colors.grey[200] : const Color(0xFF6B7280),
                  size: 24,
                ),
                if (hasUnread)
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF2D95), // Vibrant pink dot
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF1A0B2E)
                              : Colors.white,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Animated Goals Card extracted

  // --- Overview Grid ---
  Widget _buildOverviewGrid({
    int maxStreak = 0,
    int score = 0,
    int totalHabits = 0,
  }) {
    final isDark = _themeManager.isDarkMode;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildOverviewCard(
          icon: Icons.local_fire_department,
          iconColor: const Color(0xFFFF5B5B),
          title: 'STREAK',
          value: '$maxStreak',
          unit: 'days',
          cardGradient: isDark
              ? [
                  const Color(0xFF382370).withValues(alpha: 0.4),
                  const Color(0xFF1B113D).withValues(alpha: 0.4),
                ]
              : [
                  const Color(0xFFFFE5E5),
                  const Color(0xFFFFE5E5).withValues(alpha: 0.4),
                ],
        ),
        _buildOverviewCard(
          icon: Icons.track_changes,
          iconColor: const Color(0xFFFDB913),
          title: 'SCORE',
          value: '$score',
          unit: '%',
          cardGradient: isDark
              ? [
                  const Color(0xFF3D2C1A).withValues(alpha: 0.4),
                  const Color(0xFF1D140B).withValues(alpha: 0.4),
                ]
              : [
                  const Color(0xFFFFF7E0),
                  const Color(0xFFFFF7E0).withValues(alpha: 0.4),
                ],
        ),
        _buildOverviewCard(
          icon: Icons.trending_up,
          iconColor: const Color(0xFF5AC8FA),
          title: 'ACTIVITIES',
          value: '$totalHabits',
          unit: 'total',
          cardGradient: isDark
              ? [
                  const Color(0xFF1B264E).withValues(alpha: 0.4),
                  const Color(0xFF0D1426).withValues(alpha: 0.4),
                ]
              : [
                  const Color(0xFFE3F2FD),
                  const Color(0xFFE3F2FD).withValues(alpha: 0.4),
                ],
        ),
        _buildOverviewCard(
          icon: Icons.access_time_filled,
          iconColor: const Color(0xFFAF52DE),
          title: 'TIME',
          value: '12h',
          unit: 'focus',
          cardGradient: isDark
              ? [
                  const Color(0xFF382370).withValues(alpha: 0.4),
                  const Color(0xFF1B113D).withValues(alpha: 0.4),
                ]
              : [
                  const Color(0xFFF3E5F5),
                  const Color(0xFFF3E5F5).withValues(alpha: 0.4),
                ],
        ),
      ],
    );
  }

  Widget _buildOverviewCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String unit,
    required List<Color> cardGradient,
  }) {
    final isDark = _themeManager.isDarkMode;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: cardGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey.shade600,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  color: isDark ? Colors.white38 : Colors.grey.shade500,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Quick Log ---
  Widget _buildQuickLogHeader(BuildContext context, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Quick Log',
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditQuickLogScreen()),
          ),
          child: const Text(
            'EDIT',
            style: TextStyle(
              color: Color(0xFF8B5CF6),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLogList(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: QuickLogManager.currentActionIds,
      builder: (context, currentIds, child) {
        if (currentIds.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'All daily logs completed! ðŸŽ‰',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.8,
          ),
          itemCount: currentIds.length,
          itemBuilder: (context, index) {
            final id = currentIds[index];
            final action = QuickLogManager.allActions[id]!;
            String label = action.name;
            if (label == label.toUpperCase()) {
              label = label[0] + label.substring(1).toLowerCase();
            }

            return _buildQuickLogSmallCard(action.icon, label, () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => action.page),
              );
            });
          },
        );
      },
    );
  }

  Widget _buildQuickLogSmallCard(
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    final isDark = _themeManager.isDarkMode;

    // Exact colors from images
    Color baseColor;
    if (label == 'Mood') {
      baseColor = const Color(0xFFFF2D95);
    } else if (label == 'Workout') {
      baseColor = const Color(0xFFFF6B35);
    } else if (label == 'Reading') {
      baseColor = const Color(0xFF13C6DF);
    } else if (label == 'Skill') {
      baseColor = const Color(0xFF9FE82E);
    } else {
      baseColor = const Color(0xFF8B5CF6);
    }

    final List<Color> cardGradient = isDark
        ? [baseColor.withValues(alpha: 0.15), baseColor.withValues(alpha: 0.05)]
        : [baseColor.withValues(alpha: 0.2), baseColor.withValues(alpha: 0.1)];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: cardGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: baseColor.withValues(alpha: isDark ? 0.3 : 0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: baseColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDark ? baseColor.withValues(alpha: 0.9) : baseColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.w900, // Matching the bold look
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }

  // --- AI Coach Card ---
  Widget _buildAiCoachCard() {
    final isDark = _themeManager.isDarkMode;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1B113D).withValues(alpha: 0.4)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF98E2F).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.psychology,
              color: Color(0xFFF98E2F),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Coach',
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Get Daily Insights',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF98E2F), Color(0xFFFDB913)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF98E2F).withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              'START',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRowItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1B113D).withValues(alpha: 0.4)
              : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.4),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.grey.shade600,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? Colors.white24 : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyActivityGrid(int calories, int focusTime, int tasks) {
    final isDark = _themeManager.isDarkMode;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.85,
      children: [
        _buildActivityCard(
          iconSource: Icons.local_fire_department,
          iconColor: const Color(0xFFFF5B5B),
          title: 'Active Burn',
          value: '$calories',
          unit: 'kcal',
          progress: (calories / 500).clamp(0.0, 1.0),
          cardGradient: isDark
              ? [
                  const Color(0xFF3D1F1A).withValues(alpha: 0.4),
                  const Color(0xFF221110).withValues(alpha: 0.4),
                ]
              : [
                  const Color(0xFFFFEEEA),
                  const Color(0xFFFFEEEA).withValues(alpha: 0.4),
                ],
        ),
        _buildActivityCard(
          iconSource: Icons.timer,
          iconColor: const Color(0xFF8CE063),
          title: 'Focus Time',
          value: '$focusTime',
          unit: 'min',
          progress: (focusTime / 120).clamp(0.0, 1.0),
          cardGradient: isDark
              ? [
                  const Color(0xFF1E2F1A).withValues(alpha: 0.4),
                  const Color(0xFF0F180D).withValues(alpha: 0.4),
                ]
              : [
                  const Color(0xFFF1F8E9),
                  const Color(0xFFF1F8E9).withValues(alpha: 0.4),
                ],
          isChart: true,
        ),
        _buildActivityCard(
          iconSource: Icons.favorite,
          iconColor: const Color(0xFFFF5BAE),
          title: 'Wellness',
          value: '$tasks',
          unit: 'tasks',
          progress: (tasks / 5).clamp(0.0, 1.0),
          cardGradient: isDark
              ? [
                  const Color(0xFF3D1A2F).withValues(alpha: 0.4),
                  const Color(0xFF1F0D18).withValues(alpha: 0.4),
                ]
              : [
                  const Color(0xFFFCE4EC),
                  const Color(0xFFFCE4EC).withValues(alpha: 0.4),
                ],
        ),
        _buildActivityCard(
          iconSource: Icons.auto_awesome,
          iconColor: const Color(0xFFAF52DE),
          title: 'Consistency',
          value: tasks > 0 ? 'Peak' : 'Start',
          unit: 'today',
          progress: tasks > 0 ? 1.0 : 0.0,
          cardGradient: isDark
              ? [
                  const Color(0xFF261A3D).withValues(alpha: 0.4),
                  const Color(0xFF130D1F).withValues(alpha: 0.4),
                ]
              : [
                  const Color(0xFFF3E5F5),
                  const Color(0xFFF3E5F5).withValues(alpha: 0.4),
                ],
        ),
      ],
    );
  }

  Widget _buildActivityCard({
    required IconData iconSource,
    required Color iconColor,
    required String title,
    required String value,
    required String unit,
    required double progress,
    required List<Color> cardGradient,
    bool isChart = false,
  }) {
    final isDark = _themeManager.isDarkMode;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: cardGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(
            alpha: isDark ? 0.05 : 0.05,
          ),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(iconSource, color: iconColor, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
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
          Center(
            child: isChart
                ? SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: LineChartPainter(color: iconColor),
                    ),
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 5,
                          backgroundColor:
                              (isDark ? Colors.white : Colors.black).withValues(
                                alpha: 0.05,
                              ),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
        ],
      ),
    );
  }

  // --- Bottom Navigation Bar ---
  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B), // Fixed dark gray
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(0, 5),
            blurRadius: 15,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            Icons.home_outlined,
            const Color(0xFFF98E2F),
            true,
            null,
          ),
          _buildNavItem(Icons.bar_chart_outlined, Colors.white54, false, () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const AnalyticsScreen(),
                transitionDuration: const Duration(milliseconds: 200),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
              ),
            );
          }),
          _buildNavItem(Icons.auto_awesome_outlined, Colors.white54, false, () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const AiCoachScreen(),
                transitionDuration: const Duration(milliseconds: 200),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
              ),
            );
          }),
          _buildNavItem(Icons.settings_outlined, Colors.white54, false, () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const SettingsScreen(),
                transitionDuration: const Duration(milliseconds: 200),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    Color color,
    bool isActive,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }

  Widget _buildBlob({
    required double size,
    required Color color,
    required double blur,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: ClipOval(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }
}

// --- Custom Painters ---

class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = color;
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class LineChartPainter extends CustomPainter {
  final Color color;
  LineChartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.lineTo(size.width * 0.2, size.height * 0.7);
    path.lineTo(size.width * 0.4, size.height * 0.5);
    path.lineTo(size.width * 0.6, size.height * 0.45);
    path.lineTo(size.width * 0.8, size.height * 0.4);
    path.lineTo(size.width, size.height * 0.3);

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
