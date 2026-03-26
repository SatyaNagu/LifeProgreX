import 'package:flutter/material.dart';
import 'utils/custom_popup.dart';
import 'utils/premium_background.dart';
import 'utils/theme_manager.dart';
import 'utils/user_preferences.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final ThemeManager _themeManager = ThemeManager();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(_updateTheme);
    _firstNameController.text = UserPreferences.getFirstName();
    _lastNameController.text = UserPreferences.getLastName();
    _emailController.text = UserPreferences.getEmail();
    _phoneController.text = UserPreferences.getPhone();
    _bioController.text = UserPreferences.getBio();
  }

  @override
  void dispose() {
    _themeManager.removeListener(_updateTheme);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
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
                          'Personal Information',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Update your profile details',
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

                // Profile Image Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30),
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
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFF98E2F), // Orange border
                                width: 3,
                              ),
                              image: const DecorationImage(
                                image: AssetImage('Assets/onboarding_image_3.png'), 
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7C3AED), // Purple floating action button
                              shape: BoxShape.circle,
                              border: Border.all(color: isDark ? const Color(0xFF221A3D) : Colors.white, width: 3),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Click to change profile picture',
                        style: TextStyle(
                          color: subTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Form Fields Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBgColor,
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
                      _buildInputField(
                        controller: _firstNameController,
                        icon: Icons.person_outline,
                        label: 'First Name',
                        hintText: 'Demo',
                        iconColor: const Color(0xFF7C3AED),
                        isDark: isDark,
                        textColor: textColor,
                        subTextColor: subTextColor,
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        controller: _lastNameController,
                        icon: Icons.person_outline,
                        label: 'Last Name',
                        hintText: 'User',
                        iconColor: const Color(0xFF7C3AED),
                        isDark: isDark,
                        textColor: textColor,
                        subTextColor: subTextColor,
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        controller: _emailController,
                        icon: Icons.mail_outline,
                        label: 'Email Address',
                        hintText: 'demo@example.com',
                        iconColor: const Color(0xFF7C3AED),
                        isDark: isDark,
                        textColor: textColor,
                        subTextColor: subTextColor,
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        hintText: '+1 (555) 000-0000',
                        optional: true,
                        isDark: isDark,
                        textColor: textColor,
                        subTextColor: subTextColor,
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        controller: _bioController,
                        label: 'Bio',
                        hintText: 'Tell us a bit about yourself...',
                        maxLines: 4,
                        optional: true,
                        isDark: isDark,
                        textColor: textColor,
                        subTextColor: subTextColor,
                      ),
                    ],
                  ),
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
                      : const Text('Save Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildInputField({
    IconData? icon,
    required String label,
    required String hintText,
    Color? iconColor,
    int maxLines = 1,
    bool optional = false,
    TextEditingController? controller,
    required bool isDark,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor ?? subTextColor, size: 18),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (optional) ...[
              const SizedBox(width: 8),
              Text(
                '(Optional)',
                style: TextStyle(
                  color: subTextColor.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
              ),
            ]
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: subTextColor.withValues(alpha: 0.5)),
            filled: true,
            fillColor: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFFF1F5F9), 
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1));
    
    await UserPreferences.setFirstName(_firstNameController.text.trim());
    await UserPreferences.setLastName(_lastNameController.text.trim());
    await UserPreferences.setEmail(_emailController.text.trim());
    await UserPreferences.setPhone(_phoneController.text.trim());
    await UserPreferences.setBio(_bioController.text.trim());

    if (mounted) {
      setState(() => _isSaving = false);
      CustomPopup.show(
        context: context,
        title: 'Success',
        message: 'Profile Updated Successfully!',
        primaryColor: const Color(0xFF00D12E),
      );
    }
  }
}
