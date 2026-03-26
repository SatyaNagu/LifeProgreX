import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'utils/custom_popup.dart';
import 'utils/premium_background.dart';
import 'utils/theme_manager.dart';
import 'utils/user_preferences.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  final ThemeManager _themeManager = ThemeManager();

  // Appearance Settings
  late bool _reducedMotion;
  late bool _compactView;
  
  // Theme Color Options
  String _selectedColor = 'Blue';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(_updateTheme);
    _reducedMotion = UserPreferences.getReducedMotion();
    _compactView = UserPreferences.getCompactView();
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
        child: Stack(
          children: [
            SingleChildScrollView(
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
                              'Appearance',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Customize your experience',
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

                    // Top Graphic Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
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
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7C3AED), // Purple icon box
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.palette_outlined,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Current Theme',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isDark ? 'Dark Mode with Purple Accent' : 'Light Mode with Purple Accent',
                            style: TextStyle(
                              color: subTextColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // DISPLAY SECTION
                    _buildSectionHeader('DISPLAY', subTextColor),
                    _buildSectionCard(
                      color: cardBgColor,
                      isDark: isDark,
                      child: Column(
                        children: [
                          _buildSwitchTile(
                            icon: Icons.nightlight_round,
                            title: 'Dark Mode',
                            subtitle: 'Toggle app theme',
                            value: isDark,
                            onChanged: (val) => _themeManager.toggleTheme(val),
                            iconColor: const Color(0xFF8B5CF6),
                            iconBgColor: isDark ? const Color(0xFF221A3D) : const Color(0xFFF1F5F9),
                            textColor: textColor,
                            subTextColor: subTextColor,
                          ),
                          _buildDivider(isDark),
                          _buildSwitchTile(
                            icon: Icons.grid_view,
                            title: 'Reduced Motion',
                            subtitle: 'Minimize animations',
                            value: _reducedMotion,
                            onChanged: (val) {
                              setState(() => _reducedMotion = val);
                              UserPreferences.setReducedMotion(val);
                            },
                            iconColor: const Color(0xFFF98E2F),
                            iconBgColor: isDark ? const Color(0xFF2B1D16) : const Color(0xFFFEF3C7),
                            textColor: textColor,
                            subTextColor: subTextColor,
                          ),
                          _buildDivider(isDark),
                          _buildSwitchTile(
                            icon: Icons.text_fields,
                            title: 'Compact View',
                            subtitle: 'Show more content',
                            value: _compactView,
                            onChanged: (val) {
                              setState(() => _compactView = val);
                              UserPreferences.setCompactView(val);
                            },
                            iconColor: isDark ? Colors.white70 : const Color(0xFF4B5563),
                            iconBgColor: isDark ? const Color(0xFF221A3D) : const Color(0xFFF1F5F9),
                            textColor: textColor,
                            subTextColor: subTextColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ACCENT COLOR SECTION
                    _buildSectionHeader('ACCENT COLOR', subTextColor),
                    
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildColorCard('Purple', const Color(0xFF7C3AED), isDark ? const Color(0xFF5B21B6) : const Color(0xFFF5F3FF), isDark),
                        _buildColorCard('Orange', const Color(0xFFF98E2F), isDark ? const Color(0xFFC2410C) : const Color(0xFFFFF7ED), isDark),
                        _buildColorCard('Blue', const Color(0xFF3B82F6), isDark ? const Color(0xFF1D4ED8) : const Color(0xFFEFF6FF), isDark),
                        _buildColorCard('Green', const Color(0xFF10B981), isDark ? const Color(0xFF047857) : const Color(0xFFECFDF5), isDark),
                      ],
                    ),
                    
                    // Extra spacing for bottom button
                    const SizedBox(height: 100), 
                  ],
                ),
              ),
            ),

            // Fixed Bottom Button
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _handleSave, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED), // Default Purple
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                    shadowColor: const Color(0xFF7C3AED).withValues(alpha: 0.5),
                  ),
                  child: _isSaving 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ),
            )
          ],
        ),
      ),
     ),
    );
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

  Widget _buildSectionCard({required Widget child, required Color color, required bool isDark}) {
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
      child: child,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required Color iconColor,
    required Color iconBgColor,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
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
          CupertinoSwitch(
            value: value,
            activeTrackColor: const Color(0xFF7C3AED), // Purple
            inactiveTrackColor: Colors.black.withValues(alpha: 0.1),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 72.0, right: 16.0), // Indent past icon
      child: Divider(
        height: 1,
        thickness: 1,
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
      ),
    );
  }

  Widget _buildColorCard(String label, Color circleColor, Color bgColor, bool isDark) {
    bool isSelected = _selectedColor == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = label;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: isSelected 
              ? Border.all(color: const Color(0xFFF98E2F), width: 2) // Orange selected border
              : Border.all(color: Colors.transparent, width: 2),
          boxShadow: isDark ? null : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: circleColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
                  ),
                ),
                if (isSelected)
                  Positioned(
                    right: -2,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF98E2F),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 10),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF111827),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
        message: 'Appearance Settings Saved!',
        primaryColor: const Color(0xFF00D12E),
      );
    }
  }
}
