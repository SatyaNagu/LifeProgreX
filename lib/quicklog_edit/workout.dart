import 'package:flutter/material.dart';
import '../utils/custom_popup.dart';
import '../services/activity_service.dart';
import '../models/activity_model.dart';
import '../auth_service.dart';
import '../widgets/glass_card.dart';
import '../utils/theme_manager.dart';
import '../widgets/quick_log_base_layout.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  String? _selectedType;
  int _duration = 30;
  double _intensity = 5;
  final TextEditingController _noteController = TextEditingController();
  bool _isSaving = false;
  final ThemeManager _themeManager = ThemeManager();

  final List<Map<String, dynamic>> _workoutTypes = [
    {'label': 'Cardio', 'icon': Icons.bolt_outlined},
    {'label': 'Strength', 'icon': Icons.fitness_center},
    {'label': 'Yoga', 'icon': Icons.self_improvement},
    {'label': 'Sports', 'icon': Icons.emoji_events_outlined},
    {'label': 'HIIT', 'icon': Icons.local_fire_department_outlined},
    {'label': 'Swimming', 'icon': Icons.waves},
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
      title: 'Log Workout',
      subtitle: 'Track your exercise session',
      topImage: Image.asset(
        'Assets/onboarding_image_2.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: isDark ? const Color(0xFF1A1A2E) : const Color(0xFFE5E7EB),
          child: Icon(Icons.fitness_center, color: isDark ? Colors.white24 : Colors.black26, size: 48),
        ),
      ),
      saveButton: QuickLogSaveButton(
        label: 'Save Workout Log',
        isReady: _selectedType != null || _noteController.text.isNotEmpty,
        isSaving: _isSaving,
        onPressed: _handleSave,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Workout Type', isDark: isDark),
          const SizedBox(height: 16),
          _buildTypeGrid(isDark, textColor),
          const SizedBox(height: 32),
          SectionHeader(title: 'Duration', subtitle: 'How long was your session?', isDark: isDark),
          const SizedBox(height: 16),
          _buildDurationStepper(isDark, textColor),
          const SizedBox(height: 32),
          SectionHeader(title: 'Intensity Level', subtitle: 'How hard did you work? (1-10)', isDark: isDark),
          const SizedBox(height: 16),
          _buildIntensitySlider(isDark, textColor, subTextColor),
          const SizedBox(height: 32),
          SectionHeader(title: 'Notes (Optional)', subtitle: 'e.g., 5K run, felt great!', isDark: isDark),
          const SizedBox(height: 16),
          _buildNoteField(isDark, textColor, subTextColor),
        ],
      ),
    );
  }

  Widget _buildTypeGrid(bool isDark, Color textColor) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      opacity: isDark ? 0.08 : 0.6,
      color: isDark ? null : Colors.white.withOpacity(0.8),
      borderRadius: 24,
      border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.5), width: 1.5),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.95,
        ),
        itemCount: _workoutTypes.length,
        itemBuilder: (context, index) {
          final type = _workoutTypes[index];
          final isSelected = _selectedType == type['label'];
          const accentColor = Color(0xFF8B5CF6);

          return GestureDetector(
            onTap: () => setState(() => _selectedType = type['label']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected 
                    ? accentColor.withOpacity(isDark ? 0.2 : 0.1)
                    : isDark ? Colors.white.withOpacity(0.04) : Colors.white.withOpacity(0.4),
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
                    type['icon'],
                    color: isSelected ? accentColor : textColor.withOpacity(0.4),
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    type['label'],
                    style: TextStyle(
                      color: isSelected ? (isDark ? accentColor.withOpacity(0.8) : textColor) : textColor.withOpacity(0.6),
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

  Widget _buildDurationStepper(bool isDark, Color textColor) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      opacity: isDark ? 0.08 : 0.6,
      color: isDark ? null : Colors.white.withOpacity(0.8),
      borderRadius: 24,
      border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.5), width: 1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepButton(Icons.remove, () {
            if (_duration > 5) setState(() => _duration -= 5);
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
                  color: textColor.withOpacity(0.5),
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
          color: const Color(0xFF8B5CF6).withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: const Color(0xFF8B5CF6), size: 24),
      ),
    );
  }

  Widget _buildIntensitySlider(bool isDark, Color textColor, Color subTextColor) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      opacity: isDark ? 0.08 : 0.6,
      color: isDark ? null : Colors.white.withOpacity(0.8),
      borderRadius: 24,
      border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.5), width: 1.5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(10, (index) {
              final active = index < _intensity;
              Color blockColor = isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05);
              
              if (active) {
                if (index < 3) {
                  blockColor = const Color(0xFF00D12E);
                } else if (index < 7) blockColor = const Color(0xFFF98E2F);
                else blockColor = const Color(0xFFFF4B4B);
              }

              return Expanded(
                child: Container(
                  height: 32,
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  decoration: BoxDecoration(
                    color: blockColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${_intensity.toInt()}',
                style: TextStyle(
                  color: textColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                ' / 10',
                style: TextStyle(
                  color: subTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              activeTrackColor: const Color(0xFF8B5CF6),
              inactiveTrackColor: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
              thumbColor: const Color(0xFF8B5CF6),
            ),
            child: Slider(
              value: _intensity,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (val) => setState(() => _intensity = val),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteField(bool isDark, Color textColor, Color subTextColor) {
    return GlassCard(
      padding: const EdgeInsets.all(4),
      opacity: isDark ? 0.08 : 0.6,
      color: isDark ? null : Colors.white.withOpacity(0.8),
      borderRadius: 24,
      border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.5), width: 1.5),
      child: TextField(
        controller: _noteController,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: "Add specific details about your workout",
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
    if (_selectedType == null) {
      CustomPopup.show(
        context: context,
        title: 'Selection Required',
        message: 'Please select a workout type',
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
        type: 'workout',
        value: _selectedType,
        duration: _duration,
        notes: _noteController.text,
        data: {'intensity': _intensity.toInt()},
        createdAt: DateTime.now(),
      );

      await ActivityService.saveActivity(log);

      // Add a small delay to ensure the loading state is visible
      await Future.delayed(const Duration(milliseconds: 600));

      if (mounted) {
        CustomPopup.show(
          context: context,
          title: 'Success',
          message: 'Workout Log Saved Successfully!',
          primaryColor: const Color(0xFF00D12E),
          onConfirm: () => Navigator.pop(context),
        );
      }
    } catch (e) {
      if (mounted) {
        CustomPopup.show(
          context: context,
          title: 'Error',
          message: 'Failed to save workout: $e',
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
