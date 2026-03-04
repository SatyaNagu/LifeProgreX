import 'package:flutter/material.dart';
import 'utils/custom_popup.dart';
import 'utils/premium_background.dart';
import 'utils/theme_manager.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  final ThemeManager _themeManager = ThemeManager();
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(_updateTheme);
  }

  @override
  void dispose() {
    _themeManager.removeListener(_updateTheme);
    _feedbackController.dispose();
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
                          'Help & Support',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'We\'re here to help',
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
                    color: isDark ? const Color(0xFF221A3D) : const Color(0xFFF5F3FF),
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
                          Icons.help_outline,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'How can we help?',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Get support or send us feedback',
                        style: TextStyle(
                          color: subTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // QUICK HELP SECTION
                _buildSectionHeader('QUICK HELP', subTextColor),
                _buildQuickHelpCard(
                  icon: Icons.book_outlined,
                  iconBgColor: const Color(0xFF6D28D9), // Vibrant Purple
                  title: 'User Guide',
                  subtitle: 'Learn how to use all features',
                  isDark: isDark,
                  cardBgColor: cardBgColor,
                  textColor: textColor,
                  subTextColor: subTextColor,
                ),
                const SizedBox(height: 12),
                _buildQuickHelpCard(
                  icon: Icons.chat_bubble_outline,
                  iconBgColor: const Color(0xFFEA580C), // Vibrant Orange
                  title: 'FAQ',
                  subtitle: 'Find answers to common questions',
                  isDark: isDark,
                  cardBgColor: cardBgColor,
                  textColor: textColor,
                  subTextColor: subTextColor,
                ),
                const SizedBox(height: 12),
                _buildQuickHelpCard(
                  icon: Icons.open_in_new,
                  iconBgColor: const Color(0xFF4338CA), // Indigo
                  title: 'Community',
                  subtitle: 'Connect with other users',
                  isDark: isDark,
                  cardBgColor: cardBgColor,
                  textColor: textColor,
                  subTextColor: subTextColor,
                ),
                const SizedBox(height: 32),

                // COMMON QUESTIONS SECTION
                _buildSectionHeader('COMMON QUESTIONS', subTextColor),
                _buildFaqDropdown('How do I track a new habit?', isDark, cardBgColor, textColor),
                const SizedBox(height: 12),
                _buildFaqDropdown('What does the streak counter track?', isDark, cardBgColor, textColor),
                const SizedBox(height: 12),
                _buildFaqDropdown('How does the AI Coach work?', isDark, cardBgColor, textColor),
                const SizedBox(height: 12),
                _buildFaqDropdown('Can I export my data?', isDark, cardBgColor, textColor),
                const SizedBox(height: 32),

                // FEEDBACK SECTION
                _buildSectionHeader('SEND FEEDBACK', subTextColor),
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
                    children: [
                      TextField(
                        controller: _feedbackController,
                        style: TextStyle(color: textColor),
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'What can we improve?',
                          hintStyle: TextStyle(color: subTextColor.withValues(alpha: 0.5)),
                          filled: true,
                          fillColor: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFFF1F5F9),
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
                            borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: (_isSending || _feedbackController.text.isEmpty) ? null : _handleSendFeedback,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5CF6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: _isSending 
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Submit Feedback', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
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

  Future<void> _handleSendFeedback() async {
    setState(() => _isSending = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isSending = false;
        _feedbackController.clear();
      });
      CustomPopup.show(
        context: context,
        title: 'Success',
        message: 'Feedback Submitted! Thank you.',
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

  Widget _buildSectionHeader(String title, Color subTextColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          color: subTextColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildQuickHelpCard({
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required bool isDark,
    required Color cardBgColor,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
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
                    fontSize: 16,
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
          ),
          Icon(
            Icons.open_in_new,
            color: subTextColor.withValues(alpha: 0.5),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildFaqDropdown(String question, bool isDark, Color cardBgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              question,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Icon(
            Icons.arrow_drop_down,
            color: isDark ? Colors.white54 : Colors.black54,
            size: 24,
          ),
        ],
      ),
    );
  }
}
