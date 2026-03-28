import 'package:flutter/material.dart';
import '../utils/custom_popup.dart';
import '../services/activity_service.dart';
import '../models/activity_model.dart';
import '../auth_service.dart';
import '../widgets/glass_card.dart';
import '../utils/theme_manager.dart';
import '../widgets/quick_log_base_layout.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  String? _selectedType;
  int _satisfaction = 3;
  final TextEditingController _noteController = TextEditingController();
  bool _isSaving = false;
  final ThemeManager _themeManager = ThemeManager();

  final List<Map<String, dynamic>> _interactionTypes = [
    {'label': 'Friends', 'icon': Icons.people_outline, 'color': Color(0xFF67B2FF)},
    {'label': 'Family', 'icon': Icons.home_outlined, 'color': Color(0xFFB267FF)},
    {'label': 'Work', 'icon': Icons.business_center_outlined, 'color': Color(0xFF67FFB2)},
    {'label': 'Partner', 'icon': Icons.favorite_border_rounded, 'color': Color(0xFFFF67B2)},
    {'label': 'Stranger', 'icon': Icons.person_search_outlined, 'color': Color(0xFFFFB267)},
    {'label': 'Group', 'icon': Icons.groups_outlined, 'color': Color(0xFF67B2FF)},
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
      title: 'Social Connection',
      subtitle: 'Who did you connect with today?',
      topImage: Image.asset(
        'Assets/onboarding_image_1.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: isDark ? const Color(0xFF1A1A2E) : const Color(0xFFE5E7EB),
          child: Icon(Icons.people_outline, color: isDark ? Colors.white24 : Colors.black26, size: 48),
        ),
      ),
      saveButton: QuickLogSaveButton(
        label: 'Save Interaction',
        isReady: _selectedType != null,
        isSaving: _isSaving,
        onPressed: _handleSave,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Interaction Type', subtitle: 'Who did you spend time with?', isDark: isDark),
          const SizedBox(height: 16),
          _buildTypeGrid(isDark, textColor),
          const SizedBox(height: 32),
          SectionHeader(title: 'Interaction Quality', subtitle: 'How did it make you feel?', isDark: isDark),
          const SizedBox(height: 16),
          _buildQualityHearts(isDark, textColor),
          const SizedBox(height: 32),
          SectionHeader(title: 'Notes (Optional)', subtitle: 'Briefly describe your interaction', isDark: isDark),
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
        itemCount: _interactionTypes.length,
        itemBuilder: (context, index) {
          final type = _interactionTypes[index];
          final isSelected = _selectedType == type['label'];
          final Color accentColor = type['color'];

          return GestureDetector(
            onTap: () => setState(() => _selectedType = type['label']),
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
                    type['icon'],
                    color: isSelected ? accentColor : textColor.withValues(alpha: 0.4),
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    type['label'],
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

  Widget _buildQualityHearts(bool isDark, Color textColor) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 20),
      opacity: isDark ? 0.08 : 0.6,
      color: isDark ? null : Colors.white.withValues(alpha: 0.8),
      borderRadius: 24,
      border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.5), width: 1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          final isSelected = index < _satisfaction;
          return GestureDetector(
            onTap: () => setState(() => _satisfaction = index + 1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                isSelected ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                color: isSelected ? const Color(0xFFFF67B2) : textColor.withValues(alpha: 0.2),
                size: 44,
              ),
            ),
          );
        }),
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
          hintText: "What did you do together?",
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
        type: 'social',
        value: _selectedType!,
        notes: _noteController.text,
        data: {'satisfaction': _satisfaction},
        createdAt: DateTime.now(),
      );

      await ActivityService.saveActivity(log);

      // Add a small delay to ensure the loading state is visible
      await Future.delayed(const Duration(milliseconds: 600));

      if (mounted) {
        CustomPopup.show(
          context: context,
          title: 'Success',
          message: 'Social interaction logged successfully!',
          primaryColor: const Color(0xFF00D12E),
          onConfirm: () => Navigator.pop(context),
        );
      }
    } catch (e) {
      if (mounted) {
        CustomPopup.show(
          context: context,
          title: 'Error',
          message: 'Failed to save social connection: $e',
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
