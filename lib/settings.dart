import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'auth_service.dart';
import 'login_screen.dart';
import 'landing_screen.dart';
import 'screens/analytics_screen.dart';

import 'appearance.dart';
import 'help_and_support.dart';
import 'screens/achievements_screen.dart';
import 'utils/premium_background.dart';
import 'utils/theme_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  final ThemeManager _themeManager = ThemeManager();

  // Mock state for switches
  bool _pushNotifications = true;
  bool _weeklyReports = true;

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

  void _handleSignOut() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeManager.isDarkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subTextColor = isDark ? Colors.white54 : const Color(0xFF6B7280);
    final cardBgColor = isDark ? const Color(0xFF141414) : Colors.white;

    return PremiumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Main Scrollable Content
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),

                      // Header with Back Button
                      Row(
                        children: [
                          _buildBackButton(context, isDark),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Settings',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'App preferences',
                                style: TextStyle(
                                  color: subTextColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Profile card removed here

                      // Progress Section
                      _buildSectionHeader('PROGRESS', subTextColor),
                      _buildSectionCard(
                        color: cardBgColor,
                        child: _buildNavigationTile(
                          icon: Icons.emoji_events_outlined,
                          title: 'Achievements',
                          subtitle: 'View your milestones and badges',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AchievementsScreen(),
                            ),
                          ),
                          textColor: textColor,
                          subTextColor: subTextColor,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Settings Section
                      _buildSectionHeader('SETTINGS', subTextColor),
                      _buildSectionCard(
                        color: cardBgColor,
                        child: Column(
                          children: [
                            _buildSwitchTile(
                              title: 'Push Notifications',
                              subtitle: 'Get daily reminders',
                              value: _pushNotifications,
                              onChanged: (val) =>
                                  setState(() => _pushNotifications = val),
                              textColor: textColor,
                              subTextColor: subTextColor,
                            ),
                            _buildDivider(isDark),
                            _buildSwitchTile(
                              title: 'Weekly Reports',
                              subtitle: 'Progress summaries',
                              value: _weeklyReports,
                              onChanged: (val) =>
                                  setState(() => _weeklyReports = val),
                              textColor: textColor,
                              subTextColor: subTextColor,
                            ),
                            _buildDivider(isDark),
                            _buildSwitchTile(
                              title: 'Dark Mode',
                              subtitle: 'Toggle app theme',
                              value: isDark,
                              onChanged: (val) =>
                                  _themeManager.toggleTheme(val),
                              activeColor: const Color(0xFF8B5CF6),
                              textColor: textColor,
                              subTextColor: subTextColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Account Section moved to Profile Screen

                      // App Section
                      _buildSectionHeader('APP', subTextColor),
                      _buildSectionCard(
                        color: cardBgColor,
                        child: Column(
                          children: [
                            _buildNavigationTile(
                              icon: Icons.palette_outlined,
                              title: 'Appearance',
                              subtitle: 'Customize your experience',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AppearanceScreen(),
                                ),
                              ),
                              textColor: textColor,
                              subTextColor: subTextColor,
                            ),
                            _buildDivider(isDark),
                            _buildNavigationTile(
                              icon: Icons.help_outline,
                              title: 'Help & Support',
                              subtitle: 'Get help and send feedback',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const HelpAndSupportScreen(),
                                ),
                              ),
                              textColor: textColor,
                              subTextColor: subTextColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Sign Out Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _handleSignOut,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? const Color(0xFF2B1D16)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: isDark ? 0 : 5,
                            shadowColor: Colors.black.withValues(alpha: 0.05),
                            side: isDark
                                ? null
                                : const BorderSide(color: Color(0xFFF1F5F9)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                color: Color(0xFFF98E2F),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Sign Out',
                                style: TextStyle(
                                  color: Color(0xFFF98E2F),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Version Code
                      Center(
                        child: Text(
                          'LIFEPROGREX V1.0.0',
                          style: TextStyle(
                            color: isDark
                                ? Colors.white24
                                : Colors.grey.withValues(alpha: 0.4),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),

                      // Extra spacing for the floating navigation bar
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),

              // Fixed Bottom Navigation Bar
              Positioned(
                bottom: 30, // Distance from bottom
                left: 20, // Distance from left edge
                right: 20, // Distance from right edge
                child: _buildBottomNavigationBar(isDark),
              ),
            ],
          ), // Stack
        ), // SafeArea
      ),
    );
  }

  // --- Widgets ---

  Widget _buildBackButton(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () {
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
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
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
        child: Center(
          child: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white70 : const Color(0xFF111827),
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color subColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          color: subColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSectionCard({required Widget child, required Color color}) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: _themeManager.isDarkMode
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: child,
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required Color textColor,
    required Color subTextColor,
    Color activeColor = const Color(0xFF8B5CF6),
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: subTextColor, fontSize: 13),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeTrackColor: activeColor,
            inactiveTrackColor: Colors.black.withValues(alpha: 0.1),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color textColor,
    required Color subTextColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _themeManager.isDarkMode
                    ? const Color(0xFF221A3D)
                    : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: _themeManager.isDarkMode
                    ? Colors.white70
                    : const Color(0xFF4B5563),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: subTextColor, fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: subTextColor.withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 64.0,
        right: 16.0,
      ), // Align with text
      child: Divider(
        height: 1,
        thickness: 1,
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.05),
      ),
    );
  }

  // --- Bottom Navigation Bar ---
  Widget _buildBottomNavigationBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
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
          _buildNavItem(
            Icons.auto_awesome_outlined,
            Colors.white54,
            false,
            null,
          ),
          _buildNavItem(
            Icons.settings_outlined,
            const Color(0xFFF98E2F),
            true,
            null,
          ), // Active Tab
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
}
