import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../utils/theme_manager.dart';
import '../utils/premium_background.dart';

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

    return PremiumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: _buildLogActivityFAB(),
        body: SafeArea(
          child: Column(
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
                      _buildSummaryGrid(isDark, textColor, subTextColor),
                      const SizedBox(height: 32),
                      _buildRecentActivitySection(isDark, textColor, subTextColor),
                      const SizedBox(height: 100), // Space for FAB
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

  Widget _buildSummaryGrid(bool isDark, Color textColor, Color subTextColor) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.85,
      children: [
        _buildSummaryCard(
          'Active Calories',
          '2,390',
          'kcal',
          Icons.local_fire_department,
          const Color(0xFFFF5B5B),
          isDark 
            ? [const Color(0xFF3D1F1A).withValues(alpha: 0.4), const Color(0xFF221110).withValues(alpha: 0.4)]
            : [const Color(0xFFFFEEEA), const Color(0xFFFFEEEA).withValues(alpha: 0.4)],
          isDark, textColor, subTextColor,
          progress: 0.85,
        ),
        _buildSummaryCard(
          'Total Distance',
          '2000',
          'km',
          Icons.show_chart,
          const Color(0xFF8CE063),
          isDark 
            ? [const Color(0xFF1E2F1A).withValues(alpha: 0.4), const Color(0xFF0F180D).withValues(alpha: 0.4)]
            : [const Color(0xFFF1F8E9), const Color(0xFFF1F8E9).withValues(alpha: 0.4)],
          isDark, textColor, subTextColor,
          progress: 0.65,
        ),
        _buildSummaryCard(
          'Wellness',
          '15',
          'tasks',
          Icons.favorite,
          const Color(0xFFFF5BAE),
          isDark 
            ? [const Color(0xFF3D1A2F).withValues(alpha: 0.4), const Color(0xFF1F0D18).withValues(alpha: 0.4)]
            : [const Color(0xFFFCE4EC), const Color(0xFFFCE4EC).withValues(alpha: 0.4)],
          isDark, textColor, subTextColor,
          progress: 0.92,
        ),
        _buildSummaryCard(
          'Reading',
          '10',
          'books',
          Icons.book,
          const Color(0xFFAF52DE),
          isDark 
            ? [const Color(0xFF261A3D).withValues(alpha: 0.4), const Color(0xFF130D1F).withValues(alpha: 0.4)]
            : [const Color(0xFFF3E5F5), const Color(0xFFF3E5F5).withValues(alpha: 0.4)],
          isDark, textColor, subTextColor,
          progress: 0.75,
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

  Widget _buildRecentActivitySection(bool isDark, Color textColor, Color subTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            "Today's Activity",
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        _buildActivityItem('Workout', '35 min', Icons.fitness_center_rounded, const Color(0xFFA855F7), isDark, textColor, subTextColor, "08:30 AM"),
        _buildActivityItem('Reading', '20 min', Icons.menu_book_rounded, const Color(0xFF06B6D4), isDark, textColor, subTextColor, "10:15 AM"),
        _buildActivityItem('Meditation', '10 min', Icons.spa_rounded, const Color(0xFF10B981), isDark, textColor, subTextColor, "12:45 PM"),
        _buildActivityItem('Walk', '1 km', Icons.directions_walk_rounded, const Color(0xFFF59E0B), isDark, textColor, subTextColor, "05:20 PM"),
      ],
    );
  }

  Widget _buildActivityItem(
    String name, 
    String metric, 
    IconData icon, 
    Color iconColor, 
    bool isDark, 
    Color textColor, 
    Color subTextColor,
    String time
  ) {
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
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              metric,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogActivityFAB() {
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
