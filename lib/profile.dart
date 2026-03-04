import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'login_screen.dart';
import 'landing_screen.dart';
import 'personal_information.dart';
import 'email_preferences.dart';
import 'privacy_and_security.dart';
import 'appearance.dart';
import 'help_and_support.dart';
import 'utils/premium_background.dart';
import 'utils/theme_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    final user = FirebaseAuth.instance.currentUser;
    // Extract name from email or set default
    final userName = user?.email?.split('@')[0] ?? 'User';
    final userEmail = user?.email ?? 'No email found';
    final isDark = _themeManager.isDarkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subTextColor = isDark ? Colors.white54 : const Color(0xFF6B7280);
    final cardBgColor = isDark ? const Color(0xFF141414) : Colors.white;

    return PremiumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
      body: Stack(
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
                            'Profile',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Manage your account',
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

                  // Profile Card
                  _buildProfileCard(userName, userEmail, isDark),
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
                          onChanged: (val) => setState(() => _pushNotifications = val),
                          textColor: textColor,
                          subTextColor: subTextColor,
                        ),
                        _buildDivider(isDark),
                        _buildSwitchTile(
                          title: 'Weekly Reports',
                          subtitle: 'Progress summaries',
                          value: _weeklyReports,
                          onChanged: (val) => setState(() => _weeklyReports = val),
                          textColor: textColor,
                          subTextColor: subTextColor,
                        ),
                        _buildDivider(isDark),
                        _buildSwitchTile(
                          title: 'Dark Mode',
                          subtitle: 'Toggle app theme',
                          value: isDark,
                          onChanged: (val) => _themeManager.toggleTheme(val),
                          activeColor: const Color(0xFF8B5CF6),
                          textColor: textColor,
                          subTextColor: subTextColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Account Section
                  _buildSectionHeader('ACCOUNT', subTextColor),
                  _buildSectionCard(
                    color: cardBgColor,
                    child: Column(
                      children: [
                        _buildNavigationTile(
                          icon: Icons.person_outline,
                          title: 'Personal Information',
                          subtitle: 'Update your profile details',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PersonalInformationScreen()),
                          ),
                          textColor: textColor,
                          subTextColor: subTextColor,
                        ),
                        _buildDivider(isDark),
                        _buildNavigationTile(
                          icon: Icons.mail_outline,
                          title: 'Email Preferences',
                          subtitle: 'Manage email notifications',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EmailPreferencesScreen()),
                          ),
                          textColor: textColor,
                          subTextColor: subTextColor,
                        ),
                        _buildDivider(isDark),
                        _buildNavigationTile(
                          icon: Icons.lock_outline,
                          title: 'Privacy & Security',
                          subtitle: 'Password and security settings',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PrivacyAndSecurityScreen()),
                          ),
                          textColor: textColor,
                          subTextColor: subTextColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

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
                            MaterialPageRoute(builder: (context) => const AppearanceScreen()),
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
                            MaterialPageRoute(builder: (context) => const HelpAndSupportScreen()),
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
                        backgroundColor: isDark ? const Color(0xFF2B1D16) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: isDark ? 0 : 5,
                        shadowColor: Colors.black.withValues(alpha: 0.05),
                        side: isDark ? null : const BorderSide(color: Color(0xFFF1F5F9)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Color(0xFFF98E2F), size: 20),
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
                        color: isDark ? Colors.white24 : Colors.grey.withValues(alpha: 0.4),
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
      ),
     ),
    );
  }

  // --- Widgets ---

  Widget _buildBackButton(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          boxShadow: isDark ? null : [
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

  Widget _buildProfileCard(String name, String email, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF221A3D) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: isDark ? null : Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFF98E2F), // Orange border
                    width: 2,
                  ),
                  image: const DecorationImage(
                    // Default image for now, ideally user photo
                    image: AssetImage('Assets/onboarding_image_3.png'), 
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Name & Badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF111827),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(
                        color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF3B2A42) : const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'PREMIUM',
                        style: TextStyle(
                          color: const Color(0xFFF98E2F), // Orange text
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatBox('7', 'STREAK', const Color(0xFFF98E2F), isDark),
              _buildStatBox('140', 'HABITS', const Color(0xFF8B5CF6), isDark), // Purple
              _buildStatBox('4', 'CATS', isDark ? Colors.white : const Color(0xFF111827), isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String value, String label, Color valueColor, bool isDark) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ],
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
        boxShadow: _themeManager.isDarkMode ? null : [
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
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeColor: activeColor,
            trackColor: Colors.black.withValues(alpha: 0.1),
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
                color: _themeManager.isDarkMode ? const Color(0xFF221A3D) : const Color(0xFFF1F5F9), 
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: _themeManager.isDarkMode ? Colors.white70 : const Color(0xFF4B5563),
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
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 13,
                    ),
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
      padding: const EdgeInsets.only(left: 64.0, right: 16.0), // Align with text
      child: Divider(
        height: 1,
        thickness: 1,
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
      ),
    );
  }

  // --- Bottom Navigation Bar ---
  Widget _buildBottomNavigationBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B), // Dark gray remains fixed
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
            // Navigate back to LandingScreen seamlessly
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const LandingScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }),
          _buildNavItem(Icons.bar_chart_outlined, Colors.white54, false, null),
          _buildNavItem(Icons.auto_awesome, Colors.white54, false, null),
          _buildNavItem(Icons.person_outline, const Color(0xFFF98E2F), true, null), // Active Tab
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
