import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'utils/premium_background.dart';
import 'utils/theme_manager.dart';

class AboutDevelopersScreen extends StatefulWidget {
  const AboutDevelopersScreen({super.key});

  @override
  State<AboutDevelopersScreen> createState() => _AboutDevelopersScreenState();
}

class _AboutDevelopersScreenState extends State<AboutDevelopersScreen> {
  final ThemeManager _themeManager = ThemeManager();

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

class DeveloperProfileCard extends StatefulWidget {
  final String name;
  final String role;
  final String email;
  final String linkedin;
  final String? imagePath;
  final bool isDark;
  final ThemeManager themeManager;
  final Color colorSeed;

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
  });

  @override
  State<DeveloperProfileCard> createState() => _DeveloperProfileCardState();
}

class _DeveloperProfileCardState extends State<DeveloperProfileCard> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  String get initials {
    List<String> parts = widget.name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return widget.name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDark ? Colors.white : const Color(0xFF111827);
    final subTextColor = widget.isDark ? Colors.white54 : const Color(0xFF6B7280);
    final cardBgColor = widget.isDark ? const Color(0xFF141414) : Colors.white;
    final expandedBgColor = widget.isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFFF8FAFC);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _isExpanded ? widget.colorSeed.withValues(alpha: 0.5) : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: widget.isDark
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
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Profile Photo / Initials Circle
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: widget.imagePath == null ? LinearGradient(
                        colors: [
                          widget.colorSeed.withValues(alpha: 0.8),
                          widget.colorSeed.withValues(alpha: 0.4)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ) : null,
                      image: widget.imagePath != null 
                          ? DecorationImage(
                              image: AssetImage(widget.imagePath!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: widget.colorSeed.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: widget.imagePath == null ? Center(
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
                  ),
                  const SizedBox(height: 16),
                  
                  // Name and Collapse Arrow
                  Text(
                    widget.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF1F5F9),
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
                    color: widget.isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(Icons.badge_outlined, 'Role', widget.role, textColor, subTextColor, widget.colorSeed, null),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.email_outlined, 'Email', widget.email, textColor, subTextColor, widget.colorSeed, () {
                      Clipboard.setData(ClipboardData(text: widget.email));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email copied to clipboard'), duration: Duration(seconds: 2), backgroundColor: Color(0xFF10C655)));
                    }),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.link_outlined, 'LinkedIn', widget.linkedin, textColor, subTextColor, widget.colorSeed, () async {
                      final url = Uri.parse(widget.linkedin);
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
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
            sizeCurve: Curves.easeInOutCubic,
          ),
        ],
      ),
    );
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
