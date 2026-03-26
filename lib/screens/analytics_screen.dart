import 'package:flutter/material.dart';
import '../utils/theme_manager.dart';
import '../utils/premium_background.dart';
import 'dart:math';
import '../profile.dart';
import '../landing_screen.dart';
import '../settings.dart';

// Note: This is an initial structure based on the provided design. 
// It will need to be refined and integrated with actual data logic.

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final ThemeManager _themeManager = ThemeManager();
  String _selectedTab = 'Week';

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
    final cardBgColor = isDark ? const Color(0xFF1B113D).withValues(alpha: 0.4) : Colors.white;
    final borderColor = (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.05 : 0.05);

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
                  pageBuilder: (context, animation, secondaryAnimation) => const LandingScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            style: IconButton.styleFrom(
              backgroundColor: cardBgColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Life Overview',
                style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Track your progress journey',
                style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 12),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                  child: const Icon(Icons.person, color: Color(0xFF8B5CF6), size: 20),
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimeToggle(isDark),
                  const SizedBox(height: 24),
                  _buildOverallProgress(isDark, cardBgColor, borderColor),
                  const SizedBox(height: 24),
                  _buildMoodTracker(isDark, cardBgColor, borderColor),
                  const SizedBox(height: 24),
                  _buildCategoryProgress(isDark, cardBgColor, borderColor),
              const SizedBox(height: 24),
              _buildActivityTimeline(isDark, cardBgColor, borderColor),
              const SizedBox(height: 24),
              _buildStatsGrid(isDark, cardBgColor, borderColor),
                  const SizedBox(height: 32),
                  _buildBottomCTA(),
                  const SizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
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
              pageBuilder: (context, animation, secondaryAnimation) => const LandingScreen(),
              transitionDuration: const Duration(milliseconds: 200),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        }),
        _buildNavItem(Icons.bar_chart_outlined, const Color(0xFF13C6DF), true, null), // Active state for analytics
        _buildNavItem(Icons.auto_awesome_outlined, Colors.white54, false, null),
        _buildNavItem(Icons.settings_outlined, Colors.white54, false, () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const SettingsScreen(),
              transitionDuration: const Duration(milliseconds: 200),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
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

// --- Header & Toggles ---

  Widget _buildTimeToggle(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
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
                  boxShadow: isSelected && !isDark ? [
                    BoxShadow(color: const Color(0xFFFFBF00).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))
                  ] : null,
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

  Widget _buildOverallProgress(bool isDark, Color cardBg, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Overall Progress',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 32),
          // Nested Circular Progress Area
          SizedBox(
            height: 200,
            width: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer Ring (e.g., Workout)
                CustomPaint(
                  size: const Size(200, 200),
                  painter: CircularProgressPainter(
                    progress: 0.8,
                    color: const Color(0xFFFF2D95), // Pink
                    strokeWidth: 12,
                    isDark: isDark,
                  ),
                ),
                // Middle Ring (e.g., Reading)
                CustomPaint(
                  size: const Size(160, 160),
                  painter: CircularProgressPainter(
                    progress: 0.6,
                    color: const Color(0xFFFFBF00), // Yellow
                    strokeWidth: 12,
                    isDark: isDark,
                  ),
                ),
                // Inner Ring (e.g., Sleep)
                CustomPaint(
                  size: const Size(120, 120),
                  painter: CircularProgressPainter(
                    progress: 0.9,
                    color: const Color(0xFF13C6DF), // Blue
                    strokeWidth: 12,
                    isDark: isDark,
                  ),
                ),
                // Center Text (Life Score)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '75%',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      'Health Score',
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
          const SizedBox(height: 16),
          // Micro Insight
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF8CE063).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '↑ You improved +8% from last week. Great consistency!',
              style: TextStyle(color: Color(0xFF8CE063), fontSize: 12, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          // Stat Rows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSubStat('23d', 'Mood', const Color(0xFFFF2D95), 'Good'),
              _buildSubStat('28d', 'Workout', const Color(0xFFFFBF00), 'Excellent'),
              _buildSubStat('18d', 'Reading', const Color(0xFF13C6DF), 'Good'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubStat(String value, String label, Color dotColor, String statusText) {
    final isDark = _themeManager.isDarkMode;
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
        Text(label, style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.black54)),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(width: 6, height: 6, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
            const SizedBox(width: 4),
            Text(statusText, style: TextStyle(fontSize: 10, color: isDark ? Colors.white38 : Colors.black38)),
          ],
        ),
      ],
    );
  }

  // --- Mood Tracker ---

  Widget _buildMoodTracker(bool isDark, Color cardBg, Color borderColor) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Mood Tracker', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('This Week', style: TextStyle(fontSize: 10, color: isDark ? Colors.white70 : Colors.black87)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMoodDay('Mon', '😐', false),
                _buildMoodDay('Tue', '🙂', false),
                _buildMoodDay('Wed', '😐', false),
                _buildMoodDay('Thu', '🙂', false),
                _buildMoodDay('Fri', '😃', true), // Highlighted
                _buildMoodDay('Sat', '😐', false),
                _buildMoodDay('Sun', '🙂', false),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Average mood: ', style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 13)),
                const Text('8.1/10 😐', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodDay(String day, String emoji, bool isHighlighted) {
    final isDark = _themeManager.isDarkMode;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isHighlighted 
                ? (isDark ? Colors.white.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.05))
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 20)),
        ),
        const SizedBox(height: 8),
        Text(day, style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.black38)),
      ],
    );
  }

  // --- Category Progress ---

  Widget _buildCategoryProgress(bool isDark, Color cardBg, Color borderColor) {
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
          const Text('Category Progress', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
            children: [
              _buildCategoryCard('Meditation', '23/30 days', 0.77, const Color(0xFFB24BF3), isDark, Icons.self_improvement),
              _buildCategoryCard('Fitness', '28/30 days', 0.93, const Color(0xFFFF6B35), isDark, Icons.fitness_center),
              _buildCategoryCard('Reading', '18/30 days', 0.60, const Color(0xFF13C6DF), isDark, Icons.menu_book),
              _buildCategoryCard('Sleep', '25/30 days', 0.83, const Color(0xFFFFBF00), isDark, Icons.nights_stay),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, String subtitle, double progress, Color color, bool isDark, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.02),
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
              Text('${(progress * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 10)),
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
          )
        ],
      ),
    );
  }

  // --- Activity Timeline ---

  Widget _buildActivityTimeline(bool isDark, Color cardBg, Color borderColor) {
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
              const Text('Activity Timeline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.black54)),
      ],
    );
  }

  // --- Stats Grid ---

  Widget _buildStatsGrid(bool isDark, Color cardBg, Color borderColor) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        // Active Calories style for Day Streak
        _buildStatCard('Day Streak', '56', '+12%', const Color(0xFFFF6B35), Icons.local_fire_department, isDark,
            isDark ? const [Color(0xFF3D1F1A), Color(0xFF221110)] : const [Color(0xFFFFEEEA), Color(0xFFFFEEEA)], borderColor),
        // Total Distance style for Total Goals
        _buildStatCard('Total Goals', '142', 'Active', const Color(0xFF13C6DF), Icons.track_changes, isDark,
            isDark ? const [Color(0xFF1E2F1A), Color(0xFF0F180D)] : const [Color(0xFFF1F8E9), Color(0xFFF1F8E9)], borderColor),
        // Reading style for Achievements
        _buildStatCard('Achievements', '18', 'New!', const Color(0xFFB24BF3), Icons.emoji_events, isDark,
            isDark ? const [Color(0xFF261A3D), Color(0xFF130D1F)] : const [Color(0xFFF3E5F5), Color(0xFFF3E5F5)], borderColor),
        // Wellness style for Wellness Score
        _buildStatCard('Wellness Score', '8.7', '+5%', const Color(0xFFFF2D95), Icons.favorite, isDark,
            isDark ? const [Color(0xFF3D1A2F), Color(0xFF1F0D18)] : const [Color(0xFFFCE4EC), Color(0xFFFCE4EC)], borderColor),
      ],
    );
  }


  Widget _buildStatCard(String title, String value, String badgeText, Color badgeColor, IconData icon, bool isDark, List<Color> gradientColors, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05), width: 1.5),
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
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(badgeText, style: TextStyle(fontSize: 9, color: isDark ? Colors.white70 : Colors.black87)),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)), // Larger typography
              Text(title, style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black54)),
            ],
          )
        ],
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
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {}, // Action for detailed analytics
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'View Detailed Analytics',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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

  CircularProgressPainter({
    required this.progress, 
    required this.color, 
    required this.strokeWidth,
    required this.isDark,
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

    // We draw the arc from roughly -220 degrees to +40 degrees for a "horseshoe" look
    const startAngle = -220 * (pi / 180);
    const sweepAngle = 260 * (pi / 180);

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

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class TimelineAreaPainter extends CustomPainter {
  final Color color;
  final bool isDark;

  TimelineAreaPainter({required this.color, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final chartHeight = size.height - 20; // Reserve space for x-axis labels
    final chartWidth = size.width - 20; // Reserve space for y-axis labels
    final xOffset = 20.0;
    
    // Draw grid lines
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Y Axis lines & labels
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final yLabels = ['8', '6', '4', '2', '0'];
    for (int i = 0; i < yLabels.length; i++) {
        final yValue = chartHeight * (i / (yLabels.length - 1));
        
        // Draw dashed grid line
        double startX = xOffset;
        while (startX < size.width) {
          canvas.drawLine(Offset(startX, yValue), Offset(startX + 5, yValue), gridPaint);
          startX += 10;
        }

        textPainter.text = TextSpan(
          text: yLabels[i],
          style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 10),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(0, yValue - 5));
    }

    // X Axis labels
    final xLabels = ['6 AM', '9 AM', '12 PM', '3 PM', '6 PM', '9 PM', '12 AM'];
    for (int i = 0; i < xLabels.length; i++) {
      final xValue = xOffset + (chartWidth * (i / (xLabels.length - 1)));
      textPainter.text = TextSpan(
        text: xLabels[i],
        style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 9),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(xValue - textPainter.width/2, chartHeight + 10));
    }

    // Data points
    final points = [
      Offset(xOffset, chartHeight * 0.1),              // 6 AM (High)
      Offset(xOffset + chartWidth * 0.16, chartHeight * 0.9), // 9 AM (Low)
      Offset(xOffset + chartWidth * 0.33, chartHeight * 0.95), // 12 PM (Low)
      Offset(xOffset + chartWidth * 0.5, chartHeight * 0.9), // 3 PM (Low)
      Offset(xOffset + chartWidth * 0.66, chartHeight * 0.8), // 6 PM
      Offset(xOffset + chartWidth * 0.83, chartHeight * 0.9), // 9 PM
      Offset(xOffset + chartWidth, chartHeight * 0.2),        // 12 AM (High)
    ];

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    // Natural spline curve
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, p1.dx, p1.dy);
    }

    // Gradient Area Fill
    final areaPath = Path.from(path);
    areaPath.lineTo(size.width, chartHeight);
    areaPath.lineTo(xOffset, chartHeight);
    areaPath.close();

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.4),
          color.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, chartHeight));
    
    canvas.drawPath(areaPath, gradientPaint);

    // Stroke line
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
