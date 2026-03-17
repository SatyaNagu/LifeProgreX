import 'package:flutter/material.dart';
import 'profile.dart'; // For navigating to ProfileScreen
import 'settings.dart';
import 'quicklog_edit/edit_quick_log.dart';
import 'utils/quick_log_manager.dart';
import 'utils/theme_manager.dart';
import 'utils/premium_background.dart';
import 'screens/all_categories_screen.dart';
import 'screens/analytics_screen.dart';
import 'dart:ui' as ui;

class LandingScreen extends StatefulWidget {
  final String userName;

  const LandingScreen({
    super.key, 
    this.userName = 'Nagasai', 
  });

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
                  _buildMainContent(textColor, isDark),
                  
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
    return Positioned.fill(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(
          left: 20, 
          right: 20, 
          top: 20, 
          bottom: 120,
        ), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(textColor),
            const SizedBox(height: 24),
            _buildGoalsCard(),
            const SizedBox(height: 32),
            _buildSectionHeader('Overview', textColor),
            const SizedBox(height: 16),
            _buildOverviewGrid(),
            const SizedBox(height: 32),
            _buildQuickLogHeader(context, textColor),
            const SizedBox(height: 16),
            _buildQuickLogList(context),
            const SizedBox(height: 32),
            _buildAiCoachCard(),
            const SizedBox(height: 12),
            _buildActionRowItem(
              icon: Icons.track_changes, 
              color: const Color(0xFF13C6DF), 
              title: 'My Habits', 
              subtitle: '5 Active Habits',
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _buildActionRowItem(
              icon: Icons.bar_chart, 
              color: const Color(0xFF8B5CF6), 
              title: 'Analytics', 
              subtitle: 'View Your Stats',
              isDark: isDark,
            ),
            const SizedBox(height: 32),
            _buildSectionHeader(
              'Daily Activity', 
              textColor, 
              trailingText: 'SEE ALL >',
              onTrailingTap: () => Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const AllCategoriesScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _buildDailyActivityGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color textColor, {String? trailingText, VoidCallback? onTrailingTap}) {
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

  // --- Header ---
  Widget _buildHeader(Color textColor) {
    final isDark = _themeManager.isDarkMode;
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = "Good Morning 👋";
    } else if (hour < 17) {
      greeting = "Good Afternoon 👋";
    } else {
      greeting = "Good Evening 👋";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
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
              widget.userName,
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
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
          image: const DecorationImage(
            image: AssetImage('Assets/onboarding_image_3.png'), 
            fit: BoxFit.cover,
          ),
          boxShadow: isDark ? null : [
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
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.2 : 0.05),
          width: 1,
        ),
        boxShadow: isDark ? null : [
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
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF9FE82E),
                shape: BoxShape.circle,
                border: Border.all(color: isDark ? const Color(0xFF1A0B2E) : Colors.white, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Today's Goals Card ---
  Widget _buildGoalsCard() {
    final isDark = _themeManager.isDarkMode;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark 
              ? [
                  const Color(0xFF1F1033).withValues(alpha: 0.8), 
                  const Color(0xFF261547).withValues(alpha: 0.6),
                  const Color(0xFF2D1B57).withValues(alpha: 0.4)
                ]
              : [
                  Colors.white.withValues(alpha: 0.9), 
                  const Color(0xFFF9FAFB).withValues(alpha: 0.6)
                ],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isDark ? const Color(0xFFB24BF3).withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            // Decorative blobs inside card
            Positioned(
              top: -40,
              right: -40,
              child: _buildBlob(
                size: 160, 
                color: const Color(0xFFFFBF00).withValues(alpha: isDark ? 0.3 : 0.15), 
                blur: 64, // blur-3xl
              ),
            ),
            Positioned(
              bottom: -32,
              left: -32,
              child: _buildBlob(
                size: 128, 
                color: const Color(0xFFB24BF3).withValues(alpha: isDark ? 0.3 : 0.15), 
                blur: 40, // blur-2xl
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                           const Icon(Icons.emoji_events_rounded, color: Color(0xFFFFBF00), size: 24),
                           const SizedBox(width: 12),
                           Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Today's Goals",
                                style: TextStyle(
                                  color: isDark ? Colors.white : const Color(0xFF111827),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                "Keep the momentum going! 🚀",
                                style: TextStyle(
                                  color: isDark ? Colors.grey[300] : const Color(0xFF6B7280),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFFFFBF00), Color(0xFFF59E0B)]),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFBF00).withValues(alpha: 0.3),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Text(
                          '3/5',
                          style: TextStyle(
                            color: Color(0xFF0A0E0A),
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Progress Bar
                  Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 6,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.transparent),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.6,
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF6B35), Color(0xFFFFBF00), Color(0xFF9FE82E)],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFFBF00).withValues(alpha: 0.4),
                                    blurRadius: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Percentage Indicator
                          Positioned(
                            left: (MediaQuery.of(context).size.width - 88) * 0.6 - 25,
                            top: -35,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                     gradient: const LinearGradient(colors: [Color(0xFFFF2D95), Color(0xFFFF6B35)]),
                                     borderRadius: BorderRadius.circular(10),
                                     boxShadow: [
                                       BoxShadow(
                                         color: const Color(0xFFFF2D95).withValues(alpha: 0.3),
                                         blurRadius: 10,
                                       ),
                                     ],
                                  ),
                                  child: const Text(
                                    '60%',
                                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900),
                                  ),
                                ),
                                CustomPaint(
                                  size: const Size(10, 5),
                                  painter: TrianglePainter(color: const Color(0xFFFF6B35)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _buildStatusDot(const Color(0xFFFFBF00), 'Completed: 3', isDark),
                          const SizedBox(width: 20),
                          _buildStatusDot(isDark ? Colors.grey[600]! : Colors.grey[400]!, 'Remaining: 2', isDark),
                        ],
                      ),
                      if (0.6 >= 0.8) // Example logic, would normally use currentProgress variable
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF9FE82E).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFF9FE82E).withValues(alpha: 0.4)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.auto_awesome, color: Color(0xFF9FE82E), size: 14),
                                SizedBox(width: 6),
                                Text(
                                  'Excellent!',
                                  style: TextStyle(color: Color(0xFF9FE82E), fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDot(Color color, String label, bool isDark) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            gradient: label.contains('Completed') 
                ? const LinearGradient(colors: [Color(0xFFFF6B35), Color(0xFFFFBF00)])
                : null,
            color: label.contains('Completed') ? null : color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.grey.shade600,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // --- Overview Grid ---
  Widget _buildOverviewGrid() {
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
          value: '7', 
          unit: 'days',
          cardGradient: isDark 
            ? [const Color(0xFF382370).withValues(alpha: 0.4), const Color(0xFF1B113D).withValues(alpha: 0.4)]
            : [const Color(0xFFFFE5E5), const Color(0xFFFFE5E5).withValues(alpha: 0.4)],
        ),
        _buildOverviewCard(
          icon: Icons.track_changes, 
          iconColor: const Color(0xFFFDB913), 
          title: 'SCORE', 
          value: '60', 
          unit: '%',
          cardGradient: isDark 
            ? [const Color(0xFF3D2C1A).withValues(alpha: 0.4), const Color(0xFF1D140B).withValues(alpha: 0.4)]
            : [const Color(0xFFFFF7E0), const Color(0xFFFFF7E0).withValues(alpha: 0.4)],
        ),
        _buildOverviewCard(
          icon: Icons.trending_up, 
          iconColor: const Color(0xFF5AC8FA), 
          title: 'HABITS', 
          value: '28', 
          unit: 'total',
          cardGradient: isDark 
            ? [const Color(0xFF1B264E).withValues(alpha: 0.4), const Color(0xFF0D1426).withValues(alpha: 0.4)]
            : [const Color(0xFFE3F2FD), const Color(0xFFE3F2FD).withValues(alpha: 0.4)],
        ),
        _buildOverviewCard(
          icon: Icons.access_time_filled, 
          iconColor: const Color(0xFFAF52DE), 
          title: 'TIME', 
          value: '12h', 
          unit: 'focus',
          cardGradient: isDark 
            ? [const Color(0xFF382370).withValues(alpha: 0.4), const Color(0xFF1B113D).withValues(alpha: 0.4)]
            : [const Color(0xFFF3E5F5), const Color(0xFFF3E5F5).withValues(alpha: 0.4)],
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
        gradient: LinearGradient(colors: cardGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.4), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
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
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditQuickLogScreen())),
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
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.8, // Adjust as needed to fit the content
          ),
          itemCount: currentIds.length,
          itemBuilder: (context, index) {
            final id = currentIds[index];
            final action = QuickLogManager.allActions[id]!;
            // Convert name to sentence case if it's all caps
            String label = action.name;
            if (label == label.toUpperCase()) {
              label = label[0] + label.substring(1).toLowerCase();
            }
            
            return _buildQuickLogSmallCard(action.icon, label, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => action.page));
            });
          },
        );
      },
    );
  }

  Widget _buildQuickLogSmallCard(IconData icon, String label, VoidCallback onTap) {
    final isDark = _themeManager.isDarkMode;
    
    // Exact colors from images
    Color baseColor;
    if (label == 'Mood') baseColor = const Color(0xFFFF2D95);
    else if (label == 'Workout') baseColor = const Color(0xFFFF6B35);
    else if (label == 'Reading') baseColor = const Color(0xFF13C6DF);
    else if (label == 'Skill') baseColor = const Color(0xFF9FE82E);
    else baseColor = const Color(0xFF8B5CF6);

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
            Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.w900, // Matching the bold look
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
        color: isDark ? const Color(0xFF1B113D).withValues(alpha: 0.4) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF98E2F).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.psychology, color: Color(0xFFF98E2F), size: 28),
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
              gradient: const LinearGradient(colors: [Color(0xFFF98E2F), Color(0xFFFDB913)]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF98E2F).withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text('START', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
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
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B113D).withValues(alpha: 0.4) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.4)),
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
          Icon(Icons.chevron_right, color: isDark ? Colors.white24 : Colors.grey.shade400),
        ],
      ),
    );
  }

  // --- Daily Activity Grid ---
  Widget _buildDailyActivityGrid() {
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
          title: 'Active Calories',
          value: '2,390',
          unit: 'kcal',
          progress: 0.85,
          cardGradient: isDark 
            ? [const Color(0xFF3D1F1A).withValues(alpha: 0.4), const Color(0xFF221110).withValues(alpha: 0.4)]
            : [const Color(0xFFFFEEEA), const Color(0xFFFFEEEA).withValues(alpha: 0.4)],
        ),
        _buildActivityCard(
          iconSource: Icons.show_chart,
          iconColor: const Color(0xFF8CE063),
          title: 'Total Distance',
          value: '2000',
          unit: 'km',
          progress: 0.65,
          cardGradient: isDark 
            ? [const Color(0xFF1E2F1A).withValues(alpha: 0.4), const Color(0xFF0F180D).withValues(alpha: 0.4)]
            : [const Color(0xFFF1F8E9), const Color(0xFFF1F8E9).withValues(alpha: 0.4)],
          isChart: true,
        ),
        _buildActivityCard(
          iconSource: Icons.favorite,
          iconColor: const Color(0xFFFF5BAE),
          title: 'Wellness',
          value: '15',
          unit: 'tasks',
          progress: 0.92,
          cardGradient: isDark 
            ? [const Color(0xFF3D1A2F).withValues(alpha: 0.4), const Color(0xFF1F0D18).withValues(alpha: 0.4)]
            : [const Color(0xFFFCE4EC), const Color(0xFFFCE4EC).withValues(alpha: 0.4)],
        ),
        _buildActivityCard(
          iconSource: Icons.book,
          iconColor: const Color(0xFFAF52DE),
          title: 'Reading',
          value: '10',
          unit: 'books',
          progress: 0.75,
          cardGradient: isDark 
            ? [const Color(0xFF261A3D).withValues(alpha: 0.4), const Color(0xFF130D1F).withValues(alpha: 0.4)]
            : [const Color(0xFFF3E5F5), const Color(0xFFF3E5F5).withValues(alpha: 0.4)],
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
        gradient: LinearGradient(colors: cardGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.05 : 0.05), width: 1.5),
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
                  child: CustomPaint(painter: LineChartPainter(color: iconColor)),
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
          _buildNavItem(Icons.home_outlined, const Color(0xFFF98E2F), true, null),
          _buildNavItem(Icons.bar_chart_outlined, Colors.white54, false, () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const AnalyticsScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }),
          _buildNavItem(Icons.auto_awesome_outlined, Colors.white54, false, null),
          _buildNavItem(Icons.settings_outlined, Colors.white54, false, () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const SettingsScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, Color color, bool isActive, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
  Widget _buildBlob({required double size, required Color color, required double blur}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
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
