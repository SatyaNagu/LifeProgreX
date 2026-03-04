import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'auth_service.dart';
import 'utils/custom_popup.dart';
import 'utils/premium_background.dart';
import 'utils/theme_manager.dart';

class PrivacyAndSecurityScreen extends StatefulWidget {
  const PrivacyAndSecurityScreen({super.key});

  @override
  State<PrivacyAndSecurityScreen> createState() => _PrivacyAndSecurityScreenState();
}

class _PrivacyAndSecurityScreenState extends State<PrivacyAndSecurityScreen> {
  final ThemeManager _themeManager = ThemeManager();

  // Password Change
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  // Security Settings
  bool _twoFactorAuth = false;
  bool _biometricAuth = true;
  bool _autoSessionTimeout = true;

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(_updateTheme);
  }

  @override
  void dispose() {
    _themeManager.removeListener(_updateTheme);
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updateTheme() {
    if (mounted) setState(() {});
  }

  Future<void> _handleChangePassword() async {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      CustomPopup.show(
        context: context,
        title: 'Missing Fields',
        message: 'Please fill all password fields',
        primaryColor: const Color(0xFFF98E2F), // Orange
      );
      return;
    }

    if (newPassword != confirmPassword) {
      CustomPopup.show(
        context: context,
        title: 'Password Mismatch',
        message: 'New passwords do not match',
        primaryColor: const Color(0xFFF98E2F), // Orange
      );
      return;
    }

    if (newPassword.length < 6) {
      CustomPopup.show(
        context: context,
        title: 'Weak Password',
        message: 'Password must be at least 6 characters',
        primaryColor: const Color(0xFFF98E2F), // Orange
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.changePassword(currentPassword, newPassword);
      if (mounted) {
        CustomPopup.show(
          context: context,
          title: 'Success',
          message: 'Password updated successfully!',
        );
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      }
    } catch (e) {
      if (mounted) {
        CustomPopup.show(
          context: context,
          title: 'Update Error',
          message: e.toString(),
          primaryColor: const Color(0xFFF98E2F), // Orange
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
                          'Privacy & Security',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Manage your account security',
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

                // Change Password Section
                _buildSectionCard(
                  icon: Icons.key,
                  iconBackgroundColor: isDark ? const Color(0xFF221A3D) : const Color(0xFFF5F3FF),
                  iconColor: const Color(0xFF8B5CF6), // Purple
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  color: cardBgColor,
                  isDark: isDark,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          _buildPasswordField(
                            label: 'Current Password', 
                            hintText: 'Enter current password',
                            controller: _currentPasswordController,
                            isDark: isDark,
                            textColor: textColor,
                            subTextColor: subTextColor,
                          ),
                          const SizedBox(height: 20),
                          _buildPasswordField(
                            label: 'New Password', 
                            hintText: 'Enter new password',
                            controller: _newPasswordController,
                            isDark: isDark,
                            textColor: textColor,
                            subTextColor: subTextColor,
                          ),
                          const SizedBox(height: 20),
                          _buildPasswordField(
                            label: 'Confirm New Password', 
                            hintText: 'Confirm new password',
                            controller: _confirmPasswordController,
                            isDark: isDark,
                            textColor: textColor,
                            subTextColor: subTextColor,
                          ),
                          const SizedBox(height: 24),
                          
                          // Update Password Button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleChangePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7C3AED), // Vibrant purple
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Update Password',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Security Settings Section
                _buildSectionCard(
                  icon: Icons.shield_outlined,
                  iconBackgroundColor: isDark ? const Color(0xFF2B1D16) : const Color(0xFFFEF3C7),
                  iconColor: const Color(0xFFF98E2F), // Orange
                  title: 'Security Settings',
                  subtitle: 'Additional security features',
                  color: cardBgColor,
                  isDark: isDark,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  children: [
                    _buildSwitchTile(
                      icon: Icons.lock_outline,
                      title: 'Two-Factor Authentication',
                      subtitle: 'Add an extra layer of security',
                      value: _twoFactorAuth,
                      onChanged: (val) => setState(() => _twoFactorAuth = val),
                      textColor: textColor,
                      subTextColor: subTextColor,
                    ),
                    _buildDivider(isDark),
                    _buildSwitchTile(
                      icon: Icons.fingerprint,
                      title: 'Biometric Authentication',
                      subtitle: 'Use fingerprint or face ID',
                      value: _biometricAuth,
                      onChanged: (val) => setState(() => _biometricAuth = val),
                      textColor: textColor,
                      subTextColor: subTextColor,
                    ),
                    _buildDivider(isDark),
                    _buildSwitchTile(
                      icon: Icons.timer_outlined,
                      title: 'Auto Session Timeout',
                      subtitle: 'Logout after 30 minutes of inactivity',
                      value: _autoSessionTimeout,
                      onChanged: (val) => setState(() => _autoSessionTimeout = val),
                      textColor: textColor,
                      subTextColor: subTextColor,
                    ),
                  ],
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

  Widget _buildPasswordField({
    required String label, 
    required String hintText,
    TextEditingController? controller,
    required bool isDark,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: true,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: subTextColor.withValues(alpha: 0.5)),
            filled: true,
            fillColor: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFFF1F5F9), 
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            suffixIcon: Icon(Icons.visibility_outlined, color: subTextColor.withValues(alpha: 0.5), size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.transparent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF98E2F)), // Orange focus
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: textColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: subTextColor, size: 20),
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
      padding: const EdgeInsets.only(left: 72.0, right: 20.0), // Indented past icon
      child: Divider(
        height: 1,
        thickness: 1,
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
      ),
    );
  }
}
