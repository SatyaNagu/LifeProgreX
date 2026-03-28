import 'package:flutter/material.dart';
import '../utils/custom_popup.dart';
import '../services/activity_service.dart';
import '../models/activity_model.dart';
import '../auth_service.dart';
import '../widgets/glass_card.dart';
import '../utils/theme_manager.dart';
import '../widgets/quick_log_base_layout.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  String? _selectedMood;
  final List<String> _selectedInfluences = [];
  final TextEditingController _noteController = TextEditingController();
  bool _isSaving = false;
  final ThemeManager _themeManager = ThemeManager();

  final List<Map<String, dynamic>> _moods = [
    {'label': 'Terrible', 'emoji': '😫', 'color': const Color(0xFFFF4B4B)},
    {'label': 'Bad', 'emoji': '🙁', 'color': const Color(0xFFFF944B)},
    {'label': 'Okay', 'emoji': '😐', 'color': const Color(0xFFFFD14B)},
    {'label': 'Good', 'emoji': '🙂', 'color': const Color(0xFFA5F364)},
    {'label': 'Great', 'emoji': '😊', 'color': const Color(0xFF64F3D1)},
    {'label': 'Amazing', 'emoji': '😁', 'color': const Color(0xFF64A5F3)},
  ];

  final List<Map<String, dynamic>> _influences = [
    {'label': 'Sleep', 'icon': Icons.dark_mode_outlined},
    {'label': 'Exercise', 'icon': Icons.fitness_center},
    {'label': 'Social', 'icon': Icons.people_outline},
    {'label': 'Work', 'icon': Icons.work_outline},
    {'label': 'Health', 'icon': Icons.favorite_border},
    {'label': 'Family', 'icon': Icons.home_outlined},
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
      title: 'Log Mood',
      subtitle: 'How are you feeling today?',
      topImage: Image.asset(
        'Assets/onboarding_image_2.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: isDark ? const Color(0xFF1A1A2E) : const Color(0xFFE5E7EB),
          child: Icon(Icons.image_outlined, color: isDark ? Colors.white24 : Colors.black26, size: 48),
        ),
      ),
      saveButton: QuickLogSaveButton(
        label: 'Save Mood Log',
        isReady: _selectedMood != null || _selectedInfluences.isNotEmpty || _noteController.text.isNotEmpty,
        isSaving: _isSaving,
        onPressed: _handleSave,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Select Your Mood', isDark: isDark),
          const SizedBox(height: 16),
          _buildMoodGrid(isDark, textColor),
          const SizedBox(height: 32),
          const SectionHeader(title: 'What influenced your mood?', subtitle: 'Select all that apply'),
          const SizedBox(height: 16),
          _buildInfluenceGrid(isDark, textColor),
          const SizedBox(height: 32),
          const SectionHeader(title: 'Add a Note (Optional)', subtitle: 'Write about your day or feelings'),
          const SizedBox(height: 16),
          _buildNoteField(isDark, textColor, subTextColor),
        ],
      ),
    );
  }

  Widget _buildMoodGrid(bool isDark, Color textColor) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      opacity: isDark ? 0.08 : 0.6,
      color: isDark ? null : Colors.white.withValues(alpha: 0.8),
      blur: 20,
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
        itemCount: _moods.length,
        itemBuilder: (context, index) {
          final mood = _moods[index];
          final isSelected = _selectedMood == mood['label'];
          final accentColor = mood['color'] as Color;

          return GestureDetector(
            onTap: () => setState(() => _selectedMood = mood['label']),
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
                boxShadow: isSelected && !isDark ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ] : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    mood['emoji'],
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mood['label'],
                    style: TextStyle(
                      color: isSelected ? (isDark ? accentColor : textColor) : textColor.withValues(alpha: 0.6),
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

  Widget _buildInfluenceGrid(bool isDark, Color textColor) {
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
        itemCount: _influences.length,
        itemBuilder: (context, index) {
          final influence = _influences[index];
          final isSelected = _selectedInfluences.contains(influence['label']);
          const accentColor = Color(0xFF8B5CF6);

          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedInfluences.remove(influence['label']);
                } else {
                  _selectedInfluences.add(influence['label']);
                }
              });
            },
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
                    influence['icon'],
                    color: isSelected ? accentColor : textColor.withValues(alpha: 0.4),
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    influence['label'],
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
        maxLines: 4,
        decoration: InputDecoration(
          hintText: "What's on your mind today?",
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
    if (_selectedMood == null) {
      CustomPopup.show(
        context: context,
        title: 'Selection Required',
        message: 'Please select a mood',
        primaryColor: Colors.redAccent,
      );
      return;
    }

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
        type: 'mood',
        value: _selectedMood,
        notes: _noteController.text,
        data: {
          'influences': _selectedInfluences,
          'emoji': _moods.firstWhere((m) => m['label'] == _selectedMood)['emoji'],
        },
        createdAt: DateTime.now(),
      );

      await ActivityService.saveActivity(log);

      // Add a small delay to ensure the loading state is visible
      await Future.delayed(const Duration(milliseconds: 600));

      if (mounted) {
        CustomPopup.show(
          context: context,
          title: 'Success',
          message: 'Mood Log Saved Successfully!',
          primaryColor: const Color(0xFF00D12E),
          onConfirm: () => Navigator.pop(context),
        );
      }
    } catch (e) {
      if (mounted) {
        CustomPopup.show(
          context: context,
          title: 'Error',
          message: 'Failed to save mood log: $e',
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
