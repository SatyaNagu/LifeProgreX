import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'utils/premium_background.dart';
import 'utils/theme_manager.dart';

class AboutDevelopersScreen extends StatefulWidget {
  const AboutDevelopersScreen({super.key});

  @override
  State<AboutDevelopersScreen> createState() => _AboutDevelopersScreenState();
}

class _AboutDevelopersScreenState extends State<AboutDevelopersScreen> {
  final ThemeManager _themeManager = ThemeManager();
  String? _expandedProfileId;

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
                  // Header
                  Row(
                    children: [
                      _buildBackButton(context, isDark),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About the Developers',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Meet the team behind LifeProgreX',
                              style: TextStyle(
                                color: subTextColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Profiles Section
                  _buildSectionHeader('THE CREATORS', subTextColor),
                  
                  DeveloperProfileCard(
                    name: 'Satya Pranav Nagunoori',
                    role: 'Lead Full Stack Developer & System Architect',
                    email: 'satyapranavnagunoori@gmail.com',
                    linkedin: 'https://www.linkedin.com/in/satya-nagunoori-pr',
                    imagePath: 'Assets/satya.jpg',
                    isDark: isDark,
                    themeManager: _themeManager,
                    colorSeed: const Color(0xFF8B5CF6),
                    isExpanded: _expandedProfileId == 'satya',
                    onToggle: () => setState(() => _expandedProfileId = _expandedProfileId == 'satya' ? null : 'satya'),
                    animationType: 1,
                  ),
                  const SizedBox(height: 20),
                  
                  DeveloperProfileCard(
                    name: 'Naga Sai Donthi',
                    role: 'Frontend Engineer & UX Architect',
                    email: 'nagasaidonthii@gmail.com',
                    linkedin: 'https://www.linkedin.com/in/nagasaidonthi',
                    imagePath: 'Assets/sai.jpg',
                    isDark: isDark,
                    themeManager: _themeManager,
                    colorSeed: const Color(0xFF00D9FF),
                    isExpanded: _expandedProfileId == 'sai',
                    onToggle: () => setState(() => _expandedProfileId = _expandedProfileId == 'sai' ? null : 'sai'),
                    animationType: 2,
                  ),
                  const SizedBox(height: 20),

                  DeveloperProfileCard(
                    name: 'Bhanu Sai Priya Gomasani',
                    role: 'QA Engineer & Integration Specialist',
                    email: 'bhanusai.cs@gmail.com',
                    linkedin: 'https://www.linkedin.com/in/bhanu-gomasani-b53448246',
                    imagePath: 'Assets/bhanu.jpg',
                    isDark: isDark,
                    themeManager: _themeManager,
                    colorSeed: const Color(0xFFFF2D95),
                    isExpanded: _expandedProfileId == 'bhanu',
                    onToggle: () => setState(() => _expandedProfileId = _expandedProfileId == 'bhanu' ? null : 'bhanu'),
                    animationType: 3,
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

  Widget _buildSectionHeader(String title, Color subTextColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 16.0),
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
}

class DeveloperProfileCard extends StatelessWidget {
  final String name;
  final String role;
  final String email;
  final String linkedin;
  final String? imagePath;
  final bool isDark;
  final ThemeManager themeManager;
  final Color colorSeed;
  final bool isExpanded;
  final VoidCallback onToggle;
  final int animationType;

  const DeveloperProfileCard({
    super.key,
    required this.name,
    required this.role,
    required this.email,
    required this.linkedin,
    this.imagePath,
    required this.isDark,
    required this.themeManager,
    required this.colorSeed,
    required this.isExpanded,
    required this.onToggle,
    required this.animationType,
  });

  String get initials {
    List<String> parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subTextColor = isDark ? Colors.white54 : const Color(0xFF6B7280);
    final cardBgColor = isDark ? const Color(0xFF141414) : Colors.white;
    final expandedBgColor = isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFFF8FAFC);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isExpanded ? colorSeed.withValues(alpha: 0.5) : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Column(
        children: [
          // Header Row (Always visible)
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Profile Photo / Initials Circle
                  _buildAnimatedAvatar(),
                  const SizedBox(height: 16),
                  
                  // Name and Collapse Arrow
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: subTextColor,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded Content
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: expandedBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(Icons.badge_outlined, 'Role', role, textColor, subTextColor, colorSeed, null),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.email_outlined, 'Email', email, textColor, subTextColor, colorSeed, () {
                      Clipboard.setData(ClipboardData(text: email));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email copied to clipboard'), duration: Duration(seconds: 2), backgroundColor: Color(0xFF10C655)));
                    }),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.link_outlined, 'LinkedIn', linkedin, textColor, subTextColor, colorSeed, () async {
                      final url = Uri.parse(linkedin);
                      try {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not open link: $e')));
                        }
                      }
                    }),
                  ],
                ),
              ),
            ),
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
            sizeCurve: Curves.easeInOutCubic,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedAvatar() {
    Widget avatar = Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: imagePath == null ? LinearGradient(
          colors: [
            colorSeed.withValues(alpha: 0.8),
            colorSeed.withValues(alpha: 0.4)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ) : null,
        image: imagePath != null 
            ? DecorationImage(
                image: AssetImage(imagePath!),
                fit: BoxFit.cover,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: colorSeed.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: imagePath == null ? Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ) : null,
    );

    if (animationType == 1) {
      // Satya: Architectural scale up and glowing shimmer
      return avatar.animate(target: isExpanded ? 1 : 0)
        .scaleXY(end: 1.15, duration: 400.ms, curve: Curves.easeOutBack)
        .shimmer(duration: 800.ms, color: Colors.white.withValues(alpha: 0.5));
    } else if (animationType == 2) {
      // Sai: Creative shake and dynamic tint shift
      return avatar.animate(target: isExpanded ? 1 : 0)
        .shake(hz: 3, duration: 400.ms)
        .tint(color: colorSeed, end: 0.2, duration: 300.ms)
        .scaleXY(end: 1.1, duration: 300.ms, curve: Curves.easeOutCirc);
    } else if (animationType == 3) {
      // Bhanu: Precise 3D flip (rotate) representing QA inspection
      return avatar.animate(target: isExpanded ? 1 : 0)
        .flipH(end: 1, duration: 600.ms, curve: Curves.easeInOutCubic)
        .scaleXY(end: 1.1, duration: 600.ms);
    }
    return avatar;
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color textColor, Color subTextColor, Color iconColor, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: iconColor.withValues(alpha: 0.8)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      color: onTap != null ? Colors.blue.shade400 : textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: onTap != null && label == 'LinkedIn' ? TextDecoration.underline : TextDecoration.none,
                      decorationColor: Colors.blue.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
