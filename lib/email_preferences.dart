import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'utils/custom_popup.dart';
import 'utils/premium_background.dart';
import 'utils/theme_manager.dart';

class EmailPreferencesScreen extends StatefulWidget {
  const EmailPreferencesScreen({super.key});

  @override
  State<EmailPreferencesScreen> createState() => _EmailPreferencesScreenState();
}

class _EmailPreferencesScreenState extends State<EmailPreferencesScreen> {
  final ThemeManager _themeManager = ThemeManager();

  // Habit & Progress Updates
  bool _dailyReminders = true;
  bool _weeklyReports = true;
  bool _monthlyInsights = true;
  bool _streakMilestones = true;

  // AI Coach & Features
  bool _aiCoachUpdates = false;

  // Product & Marketing
  bool _productUpdates = true;
  bool _marketingEmails = false;
  bool _isSaving = false;

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
    final subTextColor = isDark ? Colors.white54 : const Color(0xFF6B7280);
    final cardBgColor = isDark ? const Color(0xFF141414) : Colors.white;

    return PremiumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                
                // Header Loop
                Row(
                  children: [
                    _buildBackButton(context, isDark),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email Preferences',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Manage your email notifications',
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

                // Habit & Progress Updates Section
                _buildSectionCard(
                  icon: Icons.trending_up,
                  iconBackgroundColor: isDark ? const Color(0xFF2B1D16) : const Color(0xFFFEF3C7),
                  iconColor: const Color(0xFFF98E2F), // Orange
                  title: 'Habit & Progress Updates',
                  subtitle: 'Stay on track with your personal growth journey',
                  color: cardBgColor,
                  isDark: isDark,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  children: [
                    _buildSwitchTile(
                      title: 'Daily Habit Reminders',
                      subtitle: 'Get notified to complete your daily habits',
                      value: _dailyReminders,
                      onChanged: (val) => setState(() => _dailyReminders = val),
                      textColor: textColor,
                      subTextColor: subTextColor,
                    ),
                    _buildDivider(isDark),
                    _buildSwitchTile(
                      title: 'Weekly Progress Reports',
                      subtitle: 'Summary of your weekly achievements',
                      value: _weeklyReports,
                      onChanged: (val) => setState(() => _weeklyReports = val),
                      textColor: textColor,
                      subTextColor: subTextColor,
                    ),
                    _buildDivider(isDark),
                    _buildSwitchTile(
                      title: 'Monthly Insights',
                      subtitle: 'Deep dive into your monthly trends',
                      value: _monthlyInsights,
                      onChanged: (val) => setState(() => _monthlyInsights = val),
                      textColor: textColor,
                      subTextColor: subTextColor,
                    ),
                    _buildDivider(isDark),
                    _buildSwitchTile(
                      title: 'Streak Milestones',
                      subtitle: 'Celebrate when you hit streak goals',
                      value: _streakMilestones,
                      onChanged: (val) => setState(() => _streakMilestones = val),
                      textColor: textColor,
                      subTextColor: subTextColor,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // AI Coach & Features Section
                _buildSectionCard(
                  icon: Icons.auto_awesome,
                  iconBackgroundColor: isDark ? const Color(0xFF221A3D) : const Color(0xFFF5F3FF),
                  iconColor: const Color(0xFF8B5CF6), // Purple
                  title: 'AI Coach & Features',
                  subtitle: 'Personalized insights and recommendations',
                  color: cardBgColor,
                  isDark: isDark,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  children: [
                    _buildSwitchTile(
                      title: 'AI Coach Updates',
                      subtitle: 'New insights and personalized tips',
                      value: _aiCoachUpdates,
                      onChanged: (val) => setState(() => _aiCoachUpdates = val),
                      textColor: textColor,
                      subTextColor: subTextColor,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Product & Marketing Section
                _buildSectionCard(
                  icon: Icons.mail_outline,
                  iconBackgroundColor: isDark ? const Color(0xFF221A3D) : const Color(0xFFF1F5F9),
                  iconColor: const Color(0xFF8B5CF6), // Purple
                  title: 'Product & Marketing',
                  subtitle: 'Updates about LifeProgreX',
                  color: cardBgColor,
                  isDark: isDark,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  children: [
                    _buildSwitchTile(
                      title: 'Product Updates',
                      subtitle: 'New features and improvements',
                      value: _productUpdates,
                      onChanged: (val) => setState(() => _productUpdates = val),
                      textColor: textColor,
                      subTextColor: subTextColor,
                    ),
                    _buildDivider(isDark),
                    _buildSwitchTile(
                      title: 'Marketing Emails',
                      subtitle: 'Tips, stories, and inspiration',
                      value: _marketingEmails,
                      onChanged: (val) => setState(() => _marketingEmails = val),
                      textColor: textColor,
                      subTextColor: subTextColor,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF98E2F), // Orange
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isSaving 
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Save Preferences', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
     ),
    );
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isSaving = false);
      CustomPopup.show(
        context: context,
        title: 'Success',
        message: 'Preferences Saved Successfully!',
        primaryColor: const Color(0xFF00D12E),
      );
    }
  }

  // --- Helper Widgets ---

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

  Widget _buildSectionCard({
    required IconData icon,
    required Color iconBackgroundColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required List<Widget> children,
    required Color color,
    required bool isDark,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: subTextColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    Color activeColor = const Color(0xFF8B5CF6), // Default Purple
    required Color textColor,
    required Color subTextColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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

  Widget _buildDivider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Divider(
        height: 1,
        thickness: 1,
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
      ),
    );
  }
}
