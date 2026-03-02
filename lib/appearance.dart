import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'utils/custom_popup.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  // Appearance Settings
  bool _darkMode = false;
  bool _reducedMotion = true;
  bool _compactView = true;
  
  // Theme Color Options
  String _selectedColor = 'Blue';
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
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
                        _buildBackButton(context),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Appearance',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Customize your experience',
                              style: TextStyle(
                                color: Colors.white54,
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
                        color: const Color(0xFF221A3D), // Deep purple card
                        borderRadius: BorderRadius.circular(24),
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
                          const Text(
                            'Current Theme',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Dark Mode with Purple Accent',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // DISPLAY SECTION
                    _buildSectionHeader('DISPLAY'),
                    _buildSectionCard(
                      child: Column(
                        children: [
                          _buildSwitchTile(
                            icon: Icons.nightlight_round,
                            title: 'Dark Mode',
                            subtitle: 'Required for this theme',
                            value: _darkMode,
                            onChanged: (val) => setState(() => _darkMode = val),
                            iconColor: const Color(0xFF8B5CF6),
                            iconBgColor: const Color(0xFF221A3D),
                          ),
                          _buildDivider(),
                          _buildSwitchTile(
                            icon: Icons.grid_view,
                            title: 'Reduced Motion',
                            subtitle: 'Minimize animations',
                            value: _reducedMotion,
                            onChanged: (val) => setState(() => _reducedMotion = val),
                            iconColor: const Color(0xFFF98E2F),
                            iconBgColor: const Color(0xFF2B1D16),
                          ),
                          _buildDivider(),
                          _buildSwitchTile(
                            icon: Icons.text_fields,
                            title: 'Compact View',
                            subtitle: 'Show more content',
                            value: _compactView,
                            onChanged: (val) => setState(() => _compactView = val),
                            iconColor: Colors.white70,
                            iconBgColor: const Color(0xFF221A3D),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ACCENT COLOR SECTION
                    _buildSectionHeader('ACCENT COLOR'),
                    
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildColorCard('Purple', const Color(0xFF7C3AED), const Color(0xFF5B21B6)),
                        _buildColorCard('Orange', const Color(0xFFF98E2F), const Color(0xFFC2410C)),
                        _buildColorCard('Blue', const Color(0xFF3B82F6), const Color(0xFF1D4ED8)),
                        _buildColorCard('Green', const Color(0xFF10B981), const Color(0xFF047857)),
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
                  onPressed: _isSaving ? null : _handleSave, // Save functionality later
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
    );
  }

  // --- Helper Widgets ---

  Widget _buildBackButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.05),
        ),
        child: const Center(
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white70,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141414), // Very dark gray, almost black
        borderRadius: BorderRadius.circular(16),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeColor: const Color(0xFF7C3AED), // Purple
            trackColor: Colors.white24,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 72.0, right: 16.0), // Indent past icon
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.white.withValues(alpha: 0.05),
      ),
    );
  }

  Widget _buildColorCard(String label, Color circleColor, Color bgColor) {
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
              style: const TextStyle(
                color: Colors.white,
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
