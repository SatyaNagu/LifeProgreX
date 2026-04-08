import 'package:flutter/material.dart';
import '../utils/theme_manager.dart';
import '../utils/premium_background.dart';
import 'dart:math';
import 'package:intl/intl.dart';

import '../landing_screen.dart';
import '../services/analytics_service.dart';
import '../models/habit_model.dart';
import 'my_achievements_screen.dart';
import 'life_resume_screen.dart';
import 'ai_coach_screen.dart';
import '../settings.dart';
import '../utils/quick_log_manager.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with TickerProviderStateMixin {
  final ThemeManager _themeManager = ThemeManager();
  final AnalyticsService _analyticsService = AnalyticsService();
  String _selectedTab = 'Week';

  late AnimationController _iconRotationController;
  late AnimationController _pulseController;
  late AnimationController _dot1Controller;
  late AnimationController _dot2Controller;
  late AnimationController _dot3Controller;
  late AnimationController _entranceController;
  late AnimationController _moodEntranceController;

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(_updateTheme);
    QuickLogManager.loadPreferences();

    _iconRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _dot1Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _dot2Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _dot3Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _moodEntranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    // Add a slight delay to start the mood entrance controller
    // ensuring it slides up 0.2s after the page loads.
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _moodEntranceController.forward();
    });
  }

  @override
  void dispose() {
    _themeManager.removeListener(_updateTheme);
    _iconRotationController.dispose();
    _pulseController.dispose();
    _dot1Controller.dispose();
    _dot2Controller.dispose();
    _dot3Controller.dispose();
    _entranceController.dispose();
    _moodEntranceController.dispose();
    super.dispose();
  }

  void _updateTheme() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeManager.isDarkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final cardBgColor = isDark
        ? const Color(0xFF1B113D).withValues(alpha: 0.4)
        : Colors.white;
    final borderColor = (isDark ? Colors.white : Colors.black).withValues(
      alpha: isDark ? 0.05 : 0.05,
    );

    return PremiumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 20),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const LandingScreen(),
                  transitionDuration: const Duration(milliseconds: 200),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                ),
              );
            },
            style: IconButton.styleFrom(
              backgroundColor: cardBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Life Overview',
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Track your progress journey',
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        body: StreamBuilder<AnalyticsData>(
          stream: _analyticsService.getAnalyticsDataStream(_selectedTab),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF13C6DF)),
              );
            }
            final data = snapshot.data;
            if (data == null) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF13C6DF)),
              );
            }
            return Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                      ),
                      child: _buildTimeToggle(isDark),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 12,
                          bottom: 120,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildOverallProgress(
                              isDark,
                              cardBgColor,
                              borderColor,
                              data,
                            ),
                            const SizedBox(height: 24),
                            _buildMoodTracker(
                              isDark,
                              cardBgColor,
                              borderColor,
                              data,
                            ),
                            const SizedBox(height: 24),
                            _buildCategoryProgress(
                              isDark,
                              cardBgColor,
                              borderColor,
                              data,
                            ),
                            const SizedBox(height: 24),
                            _buildActivityTimeline(
                              isDark,
                              cardBgColor,
                              borderColor,
                              data,
                            ),
                            const SizedBox(height: 24),
                            _buildStatsGrid(
                              isDark,
                              cardBgColor,
                              borderColor,
                              data,
                            ),
                            const SizedBox(height: 32),
                            _buildBottomCTA(),
                            const SizedBox(height: 100), // Space for bottom nav
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Bottom Navigation Bar
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 30,
                  child: _buildBottomNavigationBar(context),
                ),
              ],
            );
          },
        ),
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
          _buildNavItem(Icons.home_outlined, Colors.white54, false, () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const LandingScreen(),
                transitionDuration: const Duration(milliseconds: 200),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
              ),
            );
          }),
          _buildNavItem(
            Icons.bar_chart_outlined,
            const Color(0xFF13C6DF),
            true,
            null,
          ), // Active state for analytics
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

  // --- Header & Toggles ---

  Widget _buildTimeToggle(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: ['Day', 'Week', 'Month', 'Year'].map((tab) {
          final isSelected = _selectedTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFFFBF00) // Golden yellow highlight
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isSelected && !isDark
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFFFFBF00,
                            ).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  tab,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.black87
                        : (isDark ? Colors.white54 : Colors.black54),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- Overall Progress (Life Score) ---

  int _getMockQuickLogValue(String id) {
    switch (id) {
      case 'mood':
        return 23;
      case 'workout':
        return 28;
      case 'reading':
        return 18;
      case 'skill':
        return 20;
      case 'water':
        return 25;
      case 'meditation':
        return 15;
      case 'journal':
        return 21;
      case 'nutrition':
        return 26;
      case 'sleep':
        return 29;
      case 'creative':
        return 12;
      case 'music':
        return 19;
      case 'social':
        return 22;
      default:
        return 15;
    }
  }

  int _calculateHealthScore(List<String> activeIds, AnalyticsData data) {
    if (activeIds.isEmpty) return 0;
    final moodPct = data.averageMood * 10.0;
    final workoutPct = data.averageWorkoutIntensity * 10.0;
    final skillPct = data.averageSkillIntensity * 10.0;

    final avg = (moodPct + workoutPct + skillPct) / 3.0;
    return avg.ceil();
  }

  Widget _buildOverallProgress(
    bool isDark,
    Color cardBg,
    Color borderColor,
    AnalyticsData data,
  ) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: QuickLogManager.currentActionIds,
      builder: (context, _, child) {
        // Enforce specific tiles requested by user dynamically masking the list.
        final activeLogs = ['mood', 'workout', 'skill'];
        final healthScore = _calculateHealthScore(activeLogs, data);

        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1B113D).withValues(alpha: 0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF00D9FF).withValues(alpha: 0.3)
                  : Colors.grey.shade200,
              width: 1.5,
            ),
            gradient: isDark
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1F1033).withValues(alpha: 0.9),
                      const Color(0xFF261547).withValues(alpha: 0.7),
                      const Color(0xFF2D1B57).withValues(alpha: 0.5),
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.8),
                      Colors.white.withValues(alpha: 0.6),
                    ],
                  ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Overall Progress',
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black87,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Your journey snapshot',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          // The animated spinning icon was removed entirely per user request
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 220,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: 1.0 + (_pulseController.value * 0.05),
                                  child: Container(
                                    width: 180,
                                    height: 180,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(
                                            0xFF00D9FF,
                                          ).withValues(alpha: 0.2),
                                          const Color(
                                            0xFFB24BF3,
                                          ).withValues(alpha: 0.2),
                                          const Color(
                                            0xFFFFBF00,
                                          ).withValues(alpha: 0.2),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: isDark
                                      ? [
                                          const Color(0xFF1F1033),
                                          const Color(0xFF2D1B57),
                                        ]
                                      : [Colors.white, Colors.grey.shade50],
                                ),
                                border: Border.all(
                                  color: const Color(
                                    0xFF00D9FF,
                                  ).withValues(alpha: isDark ? 0.3 : 0.2),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
                                          colors: [
                                            Color(0xFF00D9FF),
                                            Color(0xFFB24BF3),
                                            Color(0xFFFFBF00),
                                          ],
                                        ).createShader(bounds),
                                    child: Text(
                                      '$healthScore',
                                      style: const TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'PERSONAL SCORE',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.grey[400]
                                          : Colors.grey[500],
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ...List.generate(activeLogs.length, (index) {
                              final action = QuickLogManager
                                  .allActions[activeLogs[index]]!;
                              final controllers = [
                                _dot1Controller,
                                _dot2Controller,
                                _dot3Controller,
                              ];
                              final anim =
                                  controllers[index % controllers.length];
                              final initialAngle =
                                  (index * 120 - 90) * (pi / 180);

                              return AnimatedBuilder(
                                animation: anim,
                                builder: (context, child) {
                                  final angle =
                                      initialAngle + (anim.value * 2 * pi);
                                  return Transform.translate(
                                    offset: Offset(
                                      cos(angle) * 85,
                                      sin(angle) * 85,
                                    ),
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: action.color,
                                        boxShadow: [
                                          BoxShadow(
                                            color: action.color.withValues(
                                              alpha: 0.8,
                                            ),
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: activeLogs.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final id = entry.value;
                          final action = QuickLogManager.allActions[id]!;
                          final pct = id == 'mood'
                              ? (data.averageMood * 10).round()
                              : id == 'workout'
                              ? (data.averageWorkoutIntensity * 10).round()
                              : id == 'skill'
                              ? (data.averageSkillIntensity * 10).round()
                              : ((_getMockQuickLogValue(id) / 30) * 100)
                                    .round();

                          String status = pct >= 80
                              ? 'Excellent'
                              : (pct >= 60 ? 'Good' : 'Growing');

                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: idx < activeLogs.length - 1 ? 12.0 : 0,
                              ),
                              child: SlideTransition(
                                position:
                                    Tween<Offset>(
                                      begin: const Offset(0, 0.5),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: _entranceController,
                                        curve: Interval(
                                          0.4 + (idx * 0.2),
                                          1.0,
                                          curve: Curves.easeOutBack,
                                        ),
                                      ),
                                    ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.05)
                                        : Colors.white.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.1)
                                          : Colors.grey.shade200,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 48,
                                        width: 48,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            CustomPaint(
                                              size: const Size(48, 48),
                                              painter: CircularProgressPainter(
                                                progress: pct / 100,
                                                color: action.color,
                                                strokeWidth: 4,
                                                isDark: isDark,
                                                arcStyle: true,
                                              ),
                                            ),
                                            Text(
                                              '$pct%',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w900,
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        action.name,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? Colors.grey[300]
                                              : Colors.grey[700],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      // Detail values row completely removed to standardize tile size.
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: action.color,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            status,
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w600,
                                              color: isDark
                                                  ? Colors.grey[400]
                                                  : Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Mood Tracker ---

  Widget _buildMoodTracker(
    bool isDark,
    Color cardBg,
    Color borderColor,
    AnalyticsData data,
  ) {
    // Dynamically calculate the grouped days out of the timeframe bounds.
    final Map<String, Map<String, dynamic>> groupedMoods = {};
    for (var m in data.weekMoods) {
      final dayStr = DateFormat('E').format(m.timestamp); // "Mon", "Tue"
      if (!groupedMoods.containsKey(dayStr)) {
        groupedMoods[dayStr] = {
          'day': dayStr,
          'mood': m.score,
          'emoji': m.emoji,
        };
      } else {
        // Display dominant emoji (highest score) if multiple exist natively
        if (m.score > (groupedMoods[dayStr]!['mood'] as int)) {
          groupedMoods[dayStr]!['mood'] = m.score;
          groupedMoods[dayStr]!['emoji'] = m.emoji;
        }
      }
    }

    // Sort array logically based on standard timeframe logs.
    final List<Map<String, dynamic>> activeMoodData = groupedMoods.values
        .toList()
        .reversed
        .take(7)
        .toList();

    // Mathematically calculate 0-10 baseline percentage output.
    final percentage = (data.averageMood * 10).toStringAsFixed(0);
    // Find absolute dominant emoji for the summary
    String summaryEmoji = '😐';
    if (data.averageMood >= 8)
      summaryEmoji = '😁';
    else if (data.averageMood >= 6)
      summaryEmoji = '😊';
    else if (data.averageMood >= 4)
      summaryEmoji = '🙂';
    else if (data.averageMood >= 2)
      summaryEmoji = '🙁';
    else if (data.averageMood >= 0 && data.weekMoods.isNotEmpty)
      summaryEmoji = '😫';

    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: _moodEntranceController,
              curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
            ),
          ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _moodEntranceController,
          curve: const Interval(0.0, 0.3),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? const Color(0xFFB24BF3).withValues(alpha: 0.3)
                  : Colors.grey.shade200,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF1F1033).withValues(alpha: 0.8),
                      const Color(0xFF261547).withValues(alpha: 0.6),
                      const Color(0xFF2D1B57).withValues(alpha: 0.4),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.7),
                      Colors.white.withValues(alpha: 0.5),
                    ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mood Tracker',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.grey.shade900,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'This Week',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.grey.shade300
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Emoji Grid
              activeMoodData.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          "No moods logged yet in this timeframe",
                          style: TextStyle(
                            color: isDark ? Colors.white54 : Colors.black54,
                          ),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(activeMoodData.length, (index) {
                        final day = activeMoodData[index];
                        // Stagger logic: 0.2 to 1.0 spreading items => 0.2 + (index * 0.1) ends at 0.8.
                        final startOffset = 0.2 + (index * 0.08);
                        final endOffset = startOffset + 0.3 > 1.0
                            ? 1.0
                            : startOffset + 0.3;

                        return ScaleTransition(
                          scale: CurvedAnimation(
                            parent: _moodEntranceController,
                            curve: Interval(
                              startOffset,
                              endOffset,
                              curve: Curves.elasticOut,
                            ),
                          ),
                          child: FadeTransition(
                            opacity: CurvedAnimation(
                              parent: _moodEntranceController,
                              curve: Interval(startOffset, startOffset + 0.1),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 35,
                                  height: 35,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.1)
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    day['emoji'],
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  day['day'],
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
              const SizedBox(height: 16),

              // Summary Badge
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: RichText(
                  text: TextSpan(
                    text: 'Average mood: ',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                    children: [
                      TextSpan(
                        text: '$percentage%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.grey.shade900,
                        ),
                      ),
                      TextSpan(text: ' $summaryEmoji'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Category Progress ---

  Widget _buildCategoryProgress(
    bool isDark,
    Color cardBg,
    Color borderColor,
    AnalyticsData data,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category Progress',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
            children: [
              _buildCategoryCard(
                'Happiness',
                '${data.categoryStats[HabitCategory.happiness]?['active'] ?? 0}/${data.categoryStats[HabitCategory.happiness]?['total'] ?? 0}',
                data.categoryStats[HabitCategory.happiness]?['progress']
                        ?.toDouble() ??
                    0.0,
                const Color(0xFFB24BF3),
                isDark,
                Icons.sentiment_satisfied_alt,
              ),
              _buildCategoryCard(
                'Health',
                '${data.categoryStats[HabitCategory.health]?['active'] ?? 0}/${data.categoryStats[HabitCategory.health]?['total'] ?? 0}',
                data.categoryStats[HabitCategory.health]?['progress']
                        ?.toDouble() ??
                    0.0,
                const Color(0xFFFF6B35),
                isDark,
                Icons.fitness_center,
              ),
              _buildCategoryCard(
                'Knowledge',
                '${data.categoryStats[HabitCategory.knowledge]?['active'] ?? 0}/${data.categoryStats[HabitCategory.knowledge]?['total'] ?? 0}',
                data.categoryStats[HabitCategory.knowledge]?['progress']
                        ?.toDouble() ??
                    0.0,
                const Color(0xFF13C6DF),
                isDark,
                Icons.menu_book,
              ),
              _buildCategoryCard(
                'Career',
                '${data.categoryStats[HabitCategory.career]?['active'] ?? 0}/${data.categoryStats[HabitCategory.career]?['total'] ?? 0}',
                data.categoryStats[HabitCategory.career]?['progress']
                        ?.toDouble() ??
                    0.0,
                const Color(0xFFFFBF00),
                isDark,
                Icons.work,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    String title,
    String subtitle,
    double progress,
    Color color,
    bool isDark,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.black54,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: color.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Activity Timeline ---

  Widget _buildActivityTimeline(
    bool isDark,
    Color cardBg,
    Color borderColor,
    AnalyticsData data,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.show_chart, color: Color(0xFF13C6DF), size: 18),
              const SizedBox(width: 8),
              const Text(
                'Activity Timeline',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            width: double.infinity,
            child: CustomPaint(
              painter: TimelineAreaPainter(
                color: const Color(0xFFB24BF3),
                isDark: isDark,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Sleep', const Color(0xFF13C6DF), isDark),
              const SizedBox(width: 16),
              _buildLegendItem('Rest', const Color(0xFFFFBF00), isDark),
              const SizedBox(width: 16),
              _buildLegendItem('Active', const Color(0xFFB24BF3), isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, bool isDark) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
        ),
      ],
    );
  }

  // --- Stats Grid ---

  Widget _buildStatsGrid(
    bool isDark,
    Color cardBg,
    Color borderColor,
    AnalyticsData data,
  ) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        // Active Calories style for Day Streak
        _buildStatCard(
          'Day Streak',
          data.maxStreak.toString(),
          'Active',
          const Color(0xFFFF6B35),
          Icons.local_fire_department,
          isDark,
          isDark
              ? const [Color(0xFF3D1F1A), Color(0xFF221110)]
              : const [Color(0xFFFFEEEA), Color(0xFFFFEEEA)],
          borderColor,
        ),
        // Total Distance style for Total Goals
        _buildStatCard(
          'Total Goals',
          data.totalGoals.toString(),
          'Active',
          const Color(0xFF13C6DF),
          Icons.track_changes,
          isDark,
          isDark
              ? const [Color(0xFF1E2F1A), Color(0xFF0F180D)]
              : const [Color(0xFFF1F8E9), Color(0xFFF1F8E9)],
          borderColor,
        ),
        // Reading style for Achievements
        _buildStatCard(
          'Achievements',
          data.achievements.toString(),
          'Good',
          const Color(0xFFB24BF3),
          Icons.emoji_events,
          isDark,
          isDark
              ? const [Color(0xFF261A3D), Color(0xFF130D1F)]
              : const [Color(0xFFF3E5F5), Color(0xFFF3E5F5)],
          borderColor,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyAchievementsScreen(),
            ),
          ),
        ),
        // Wellness style for Wellness Score
        _buildStatCard(
          'Wellness Score',
          data.wellnessScore.toStringAsFixed(1),
          'Avg',
          const Color(0xFFFF2D95),
          Icons.favorite,
          isDark,
          isDark
              ? const [Color(0xFF3D1A2F), Color(0xFF1F0D18)]
              : const [Color(0xFFFCE4EC), Color(0xFFFCE4EC)],
          borderColor,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String badgeText,
    Color badgeColor,
    IconData icon,
    bool isDark,
    List<Color> gradientColors,
    Color borderColor, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: badgeColor, size: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontSize: 9,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ), // Larger typography
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Bottom CTA ---

  Widget _buildBottomCTA() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF13C6DF), Color(0xFFB24BF3)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB24BF3).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LifeResumeScreen()),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'View Detailed Analytics',
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
    );
  }
}

// --- Custom Painters ---

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;
  final bool isDark;
  final bool arcStyle;

  CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
    required this.isDark,
    this.arcStyle = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - strokeWidth / 2;

    // Background track
    final bgPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double startAngle;
    double sweepAngle;

    if (arcStyle) {
      startAngle = -pi / 2; // Start from top
      sweepAngle = 2 * pi;
    } else {
      // Horseshoe look
      startAngle = -220 * (pi / 180);
      sweepAngle = 260 * (pi / 180);
    }

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // Active progress track
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Shadow effect behind active segment (matching spec's drop-shadow)
    if (arcStyle) {
      final shadowPaint = Paint()
        ..color = color.withValues(alpha: 0.5)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle * progress,
        false,
        shadowPaint,
      );
    }

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.isDark != isDark;
  }
}

class TimelineAreaPainter extends CustomPainter {
  final Color color;
  final bool isDark;

  TimelineAreaPainter({required this.color, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final chartHeight = size.height - 20; // Reserve space for x-axis labels
    final xOffset = 20.0;

    // Draw grid lines
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)
      ..strokeWidth = 1;

    for (var i = 0; i <= 4; i++) {
      final y = chartHeight * (i / 4);
      canvas.drawLine(Offset(xOffset, y), Offset(size.width, y), gridPaint);
    }

    // Mock Path for timeline
    final path = Path();
    path.moveTo(xOffset, chartHeight * 0.8);
    path.quadraticBezierTo(
      size.width * 0.2,
      chartHeight * 0.2,
      size.width * 0.4,
      chartHeight * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.6,
      chartHeight * 0.8,
      size.width * 0.8,
      chartHeight * 0.3,
    );
    path.lineTo(size.width, chartHeight * 0.4);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    // Fill area under path
    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, chartHeight);
    fillPath.lineTo(xOffset, chartHeight);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, chartHeight));

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
