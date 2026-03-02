import 'package:flutter/material.dart';
import 'profile.dart'; // For navigating to ProfileScreen
import 'quicklog_edit/mood.dart';
import 'quicklog_edit/workout.dart';
import 'quicklog_edit/reading.dart';
import 'quicklog_edit/skills.dart';
import 'quicklog_edit/edit_quick_log.dart';
import 'utils/quick_log_manager.dart';

class LandingScreen extends StatelessWidget {
  final String userName;

  const LandingScreen({
    super.key, 
    this.userName = 'Nagasai', // Defaulting to the user's name for now
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Clean, flat gradient matching the provided image/onboarding background
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B113D), // Deep dark purple glow
              Color(0xFF050505), // Near absolute black center
              Color(0xFF140A05), // Faint warm tone at bottom right
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Main scrollable content
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 20, 
                    right: 20, 
                    top: 20, 
                    bottom: 120, // padded to not overlap bottom bar
                  ), 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 24),
                      _buildGoalsCard(),
                      const SizedBox(height: 24),
                      _buildMetricsRow(),
                      const SizedBox(height: 24),
                      _buildQuickLogHeader(context),
                      const SizedBox(height: 16),
                      _buildQuickLogRow(context),
                      const SizedBox(height: 24),
                      _buildAiCoachCard(),
                      const SizedBox(height: 16),
                      _buildTwoCardsRow(),
                      const SizedBox(height: 24),
                      _buildCategoriesHeader(),
                      const SizedBox(height: 16),
                      _buildCategoriesList(),
                    ],
                  ),
                ),
              ),
              
              // Bottom Navigation Bar is fixed at the bottom
              Positioned(
                left: 20,
                right: 20,
                bottom: 30, // somewhat above the absolute bottom
                child: _buildBottomNavigationBar(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Header ---
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'LifeProgreX',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1B113D),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.notifications_none,
                color: Color(0xFFF98E2F), // Orange hue
              ),
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Today's Goals Card ---
  Widget _buildGoalsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF533B8E), Color(0xFF382370)], // Purpleish gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Goals",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Keep the momentum going!",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '3/5',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.6, // Represents 60%
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF98E2F), Color(0xFFF47036)], // Orange gradient
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Color(0xFFFFD700), size: 16),
                  const SizedBox(width: 8),
                  Text(
                    "You're doing great!",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const Text(
                '60%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Metrics Row ---
  Widget _buildMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildSmallMetricCard(Icons.local_fire_department_outlined, const Color(0xFFF98E2F), '7', 'days'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSmallMetricCard(Icons.track_changes, const Color(0xFF8B5CF6), '60', '%'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSmallMetricCard(Icons.trending_up, Colors.white, '28', 'total'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSmallMetricCard(Icons.access_time, const Color(0xFF8B5CF6), '12h', 'focus'),
        ),
      ],
    );
  }

  Widget _buildSmallMetricCard(IconData icon, Color iconColor, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF16131A), // Match the dark card color
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // --- Quick Log ---
  Widget _buildQuickLogHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Quick Log',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditQuickLogScreen())),
          child: Text(
            'EDIT',
            style: TextStyle(
              color: const Color(0xFF8B5CF6),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLogRow(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: QuickLogManager.currentActionIds,
      builder: (context, currentIds, child) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: currentIds.length,
          itemBuilder: (context, index) {
            final id = currentIds[index];
            final action = QuickLogManager.allActions[id]!;
            return _buildQuickLogCard(action.icon, action.name, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => action.page));
            });
          },
        );
      },
    );
  }

  Widget _buildQuickLogCard(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF98E2F), // Standard Orange
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- AI Coach MAX Card ---
  Widget _buildAiCoachCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF432C7A), Color(0xFF6A48D3)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: const Icon(Icons.psychology, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Coach MAX',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Get daily insights & tips',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.auto_awesome, color: Colors.white24, size: 48),
              Icon(Icons.arrow_forward_ios, color: Colors.white.withValues(alpha: 0.8), size: 16),
            ],
          ),
        ],
      ),
    );
  }

  // --- Habits and Analytics Row ---
  Widget _buildTwoCardsRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF16131A),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF98E2F).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.track_changes, color: Color(0xFFF98E2F), size: 20),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Habits',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '5 active',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF16131A),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bar_chart, color: Color(0xFF8B5CF6), size: 20),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Analytics',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'View stats',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Categories ---
  Widget _buildCategoriesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'VIEW ALL >',
          style: TextStyle(
            color: const Color(0xFF8B5CF6),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesList() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16131A),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _buildCategoryItem(Icons.fitness_center, const Color(0xFFF98E2F), 'Fitness', '12 tasks', 0.85, '85%'),
          const SizedBox(height: 24),
          _buildCategoryItem(Icons.psychology, const Color(0xFF8B5CF6), 'Learning', '8 tasks', 0.60, '60%'),
          const SizedBox(height: 24),
          _buildCategoryItem(Icons.favorite_border, const Color(0xFF6B4EE6), 'Wellness', '15 tasks', 0.92, '92%'),
          const SizedBox(height: 24),
          _buildCategoryItem(null, Colors.white, 'Reading', '10 tasks', 0.75, '75%'),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData? icon, Color color, String title, String subtitle, double progress, String percent) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: icon != null 
                  ? Icon(icon, color: color, size: 20)
                  : Container(
                      width: 20, 
                      height: 20, 
                      decoration: BoxDecoration(
                        color: Colors.white, 
                        borderRadius: BorderRadius.circular(4)
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              percent,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- Bottom Navigation Bar ---
  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B), // Dark gray
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
          _buildNavItem(Icons.bar_chart_outlined, Colors.white54, false, null),
          _buildNavItem(Icons.auto_awesome, Colors.white54, false, null),
          _buildNavItem(Icons.person_outline, Colors.white54, false, () {
            // Navigate to ProfileScreen seamlessly
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const ProfileScreen(),
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
}
