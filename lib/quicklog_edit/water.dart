import 'package:flutter/material.dart';
import '../utils/custom_popup.dart';
import '../services/activity_service.dart';
import '../models/activity_model.dart';
import '../auth_service.dart';
import '../widgets/glass_card.dart';
import '../utils/theme_manager.dart';
import '../widgets/quick_log_base_layout.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  int _glasses = 0;
  final TextEditingController _noteController = TextEditingController();
  bool _isSaving = false;
  final ThemeManager _themeManager = ThemeManager();

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
      title: 'Water Intake',
      subtitle: 'Stay hydrated, stay healthy',
      topImage: Image.asset(
        'Assets/onboarding_image_3.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: isDark ? const Color(0xFF1A1A2E) : const Color(0xFFE5E7EB),
          child: Icon(Icons.water_drop_outlined, color: isDark ? Colors.white24 : Colors.black26, size: 48),
        ),
      ),
      saveButton: QuickLogSaveButton(
        label: 'Save Water Log',
        isReady: _glasses > 0,
        isSaving: _isSaving,
        onPressed: _handleSave,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Hydration', subtitle: 'How many glasses did you have?', isDark: isDark),
          const SizedBox(height: 16),
          _buildWaterStepper(isDark, textColor),
          const SizedBox(height: 32),
          SectionHeader(title: 'Notes (Optional)', subtitle: 'How are you feeling?', isDark: isDark),
          const SizedBox(height: 16),
          _buildNoteField(isDark, textColor, subTextColor),
        ],
      ),
    );
  }

  Widget _buildWaterStepper(bool isDark, Color textColor) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      opacity: isDark ? 0.08 : 0.6,
      color: isDark ? null : Colors.white.withValues(alpha: 0.8),
      borderRadius: 24,
      border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.5), width: 1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepButton(Icons.remove, () {
            if (_glasses > 0) setState(() => _glasses--);
          }),
          Column(
            children: [
              Icon(Icons.water_drop_rounded, color: const Color(0xFF67B2FF), size: 32),
              const SizedBox(height: 8),
              Text(
                '$_glasses',
                style: TextStyle(
                  color: textColor,
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              Text(
                'glasses',
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          _buildStepButton(Icons.add, () {
            setState(() => _glasses++);
          }),
        ],
      ),
    );
  }

  Widget _buildStepButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, color: const Color(0xFF8B5CF6), size: 28),
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
          hintText: "Track any specific details...",
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
        type: 'water',
        value: '$_glasses',
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
          message: 'Water log updated successfully!',
          primaryColor: const Color(0xFF00D12E),
          onConfirm: () => Navigator.pop(context),
        );
      }
    } catch (e) {
      if (mounted) {
        CustomPopup.show(
          context: context,
          title: 'Error',
          message: 'Failed to save water log: $e',
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
