import 'package:flutter/material.dart';
import '../utils/custom_popup.dart';
import '../services/activity_service.dart';
import '../models/activity_model.dart';
import '../auth_service.dart';
import '../widgets/glass_card.dart';
import '../utils/theme_manager.dart';
import '../widgets/quick_log_base_layout.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  int _duration = 10;
  String? _selectedFocus;
  final TextEditingController _noteController = TextEditingController();
  bool _isSaving = false;
  final ThemeManager _themeManager = ThemeManager();

  final List<Map<String, dynamic>> _focusOptions = [
    {'label': 'Breath', 'icon': Icons.air_outlined, 'color': Color(0xFF67B2FF)},
    {'label': 'Mindfulness', 'icon': Icons.self_improvement_outlined, 'color': Color(0xFFB267FF)},
    {'label': 'Zen', 'icon': Icons.spa_outlined, 'color': Color(0xFF67FFB2)},
    {'label': 'Focus', 'icon': Icons.center_focus_strong_outlined, 'color': Color(0xFFFFB267)},
    {'label': 'Calm', 'icon': Icons.water_drop_outlined, 'color': Color(0xFF67B2FF)},
    {'label': 'Gratitude', 'icon': Icons.favorite_border_rounded, 'color': Color(0xFFFF67B2)},
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeManager.isDarkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF16102B);
    final subTextColor = isDark ? Colors.white.withValues(alpha: 0.5) : const Color(0xFF16102B).withValues(alpha: 0.5);

    return QuickLogScaffold(
      title: 'Meditation',
      subtitle: 'Find your inner peace',
      topImage: Image.asset(
        'Assets/onboarding_image_2.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: isDark ? const Color(0xFF1A1A2E) : const Color(0xFFE5E7EB),
          child: Icon(Icons.self_improvement_outlined, color: isDark ? Colors.white24 : Colors.black26, size: 48),
        ),
      ),
      saveButton: QuickLogSaveButton(
        label: 'Save Meditation Log',
        isReady: _selectedFocus != null,
        isSaving: _isSaving,
        onPressed: _handleSave,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Duration', subtitle: 'How long did you meditate?', isDark: isDark),
          const SizedBox(height: 16),
          _buildDurationStepper(isDark, textColor),
          const SizedBox(height: 32),
          SectionHeader(title: 'Focus Area', subtitle: 'What was your primary focus?', isDark: isDark),
          const SizedBox(height: 16),
          _buildFocusGrid(isDark, textColor),
          const SizedBox(height: 32),
          SectionHeader(title: 'Notes (Optional)', subtitle: 'How do you feel now?', isDark: isDark),
          const SizedBox(height: 16),
          _buildNoteField(isDark, textColor, subTextColor),
        ],
      ),
    );
  }

  Widget _buildDurationStepper(bool isDark, Color textColor) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      opacity: isDark ? 0.08 : 0.6,
      color: isDark ? null : Colors.white.withValues(alpha: 0.8),
      borderRadius: 24,
      border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.5), width: 1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepButton(Icons.remove, () {
            if (_duration >= 5) setState(() => _duration -= 5);
          }),
          Column(
            children: [
              Text(
                '$_duration',
                style: TextStyle(
                  color: textColor,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              Text(
                'minutes',
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          _buildStepButton(Icons.add, () {
            setState(() => _duration += 5);
          }),
        ],
      ),
    );
  }

  Widget _buildStepButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: const Color(0xFF8B5CF6), size: 24),
      ),
    );
  }

  Widget _buildFocusGrid(bool isDark, Color textColor) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      opacity: isDark ? 0.08 : 0.6,
      color: isDark ? null : Colors.white.withValues(alpha: 0.8),
      borderRadius: 24,
      border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.5), width: 1.5),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.95,
        ),
        itemCount: _focusOptions.length,
        itemBuilder: (context, index) {
          final focus = _focusOptions[index];
          final isSelected = _selectedFocus == focus['label'];
          final Color accentColor = focus['color'];

          return GestureDetector(
            onTap: () => setState(() => _selectedFocus = focus['label']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected 
                    ? accentColor.withValues(alpha: isDark ? 0.2 : 0.1)
                    : isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? accentColor : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    focus['icon'],
                    color: isSelected ? accentColor : textColor.withValues(alpha: 0.4),
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    focus['label'],
                    style: TextStyle(
                      color: isSelected ? (isDark ? accentColor.withValues(alpha: 0.8) : textColor) : textColor.withValues(alpha: 0.6),
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoteField(bool isDark, Color textColor, Color subTextColor) {
    return GlassCard(
      padding: const EdgeInsets.all(4),
      opacity: isDark ? 0.08 : 0.6,
      color: isDark ? null : Colors.white.withValues(alpha: 0.8),
      borderRadius: 24,
      border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.5), width: 1.5),
      child: TextField(
        controller: _noteController,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: "How did your meditation go?",
          hintStyle: TextStyle(color: subTextColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    final user = AuthService().currentUser;
    if (user == null) {
      CustomPopup.show(
        context: context,
        title: 'Authentication Required',
        message: 'Please log in to save activities',
        primaryColor: Colors.redAccent,
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final log = ActivityLog(
        id: '',
        userId: user.uid,
        type: 'meditation',
        value: _selectedFocus!,
        duration: _duration,
        notes: _noteController.text,
        createdAt: DateTime.now(),
      );

      await ActivityService.saveActivity(log);

      // Add a small delay to ensure the loading state is visible
      await Future.delayed(const Duration(milliseconds: 600));

      if (mounted) {
        CustomPopup.show(
          context: context,
          title: 'Success',
          message: 'Meditation Session Saved Successfully!',
          primaryColor: const Color(0xFF00D12E),
          onConfirm: () => Navigator.pop(context),
        );
      }
    } catch (e) {
      if (mounted) {
        CustomPopup.show(
          context: context,
          title: 'Error',
          message: 'Failed to save meditation log: $e',
          primaryColor: Colors.redAccent,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
