import 'package:flutter/material.dart';
import '../utils/custom_popup.dart';
import '../utils/quick_log_manager.dart';
import '../widgets/glass_card.dart';
import '../utils/theme_manager.dart';
import '../widgets/quick_log_base_layout.dart';

class EditQuickLogScreen extends StatefulWidget {
  const EditQuickLogScreen({super.key});

  @override
  State<EditQuickLogScreen> createState() => _EditQuickLogScreenState();
}

class _EditQuickLogScreenState extends State<EditQuickLogScreen> {
  final ThemeManager _themeManager = ThemeManager();

  @override
  Widget build(BuildContext context) {
    final isDark = _themeManager.isDarkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF16102B);
    final subTextColor = isDark ? Colors.white.withValues(alpha: 0.5) : const Color(0xFF16102B).withValues(alpha: 0.5);

    return ValueListenableBuilder<List<String>>(
      valueListenable: QuickLogManager.currentActionIds,
      builder: (context, currentIds, child) {
        return QuickLogScaffold(
          title: 'Edit Quick Log',
          subtitle: 'Customize your shortcuts',
          saveButton: QuickLogSaveButton(
            label: 'Save & Return to Dashboard',
            isReady: true,
            isSaving: false,
            onPressed: () {
              CustomPopup.show(
                context: context,
                title: 'Dashboard Updated',
                message: 'Your quick log shortcuts have been saved.',
                primaryColor: const Color(0xFF8B5CF6),
                onConfirm: () => Navigator.pop(context),
              );
            },
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTipBox(isDark, textColor, subTextColor),
              const SizedBox(height: 32),
              SectionHeader(
                title: 'CURRENT ACTIONS (${currentIds.length})',
                subtitle: 'Tap to remove from dashboard',
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              _buildCurrentActionsGrid(currentIds, isDark, textColor),
              const SizedBox(height: 32),
              SectionHeader(
                title: 'QUICK ADD TEMPLATES',
                subtitle: 'Tap to add to your dashboard',
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              _buildTemplatesGrid(currentIds, isDark, textColor),
              const SizedBox(height: 40),
              _buildNoteBox(isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTipBox(bool isDark, Color textColor, Color subTextColor) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      opacity: isDark ? 0.08 : 0.6,
      color: isDark ? null : Colors.white.withValues(alpha: 0.8),
      borderRadius: 24,
      border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.5), width: 1.5),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Customize your dashboard for faster logging. Add what matters most to your daily routine.',
              style: TextStyle(
                color: textColor.withValues(alpha: 0.7),
                fontSize: 13,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentActionsGrid(List<String> currentIds, bool isDark, Color textColor) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemCount: currentIds.length + 1,
      itemBuilder: (context, index) {
        if (index == currentIds.length) {
          return _buildAddNewCard(isDark, textColor);
        }
        final id = currentIds[index];
        final action = QuickLogManager.allActions[id]!;
        return _buildActionCard(action, true, isDark, textColor);
      },
    );
  }

  Widget _buildActionCard(QuickLogAction action, bool isCurrent, bool isDark, Color textColor) {
    return GestureDetector(
      onTap: () {
        if (isCurrent) {
          QuickLogManager.removeAction(action.id);
        } else {
          QuickLogManager.addAction(action.id);
        }
      },
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        opacity: isCurrent ? (isDark ? 0.15 : 0.8) : (isDark ? 0.04 : 0.3),
        color: isCurrent ? action.color.withValues(alpha: isDark ? 0.2 : 0.1) : (isDark ? null : Colors.white.withValues(alpha: 0.4)),
        borderRadius: 20,
        border: Border.all(
          color: isCurrent ? action.color : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.2)),
          width: 2,
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    action.icon,
                    color: isCurrent ? action.color : textColor.withValues(alpha: 0.4),
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action.name,
                    style: TextStyle(
                      color: isCurrent ? textColor : textColor.withValues(alpha: 0.6),
                      fontSize: 11,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Icon(
                isCurrent ? Icons.remove_circle_rounded : Icons.add_circle_rounded,
                color: isCurrent ? Colors.redAccent.withValues(alpha: 0.6) : const Color(0xFF8B5CF6),
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewCard(bool isDark, Color textColor) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      opacity: isDark ? 0.02 : 0.1,
      borderRadius: 20,
      border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.1), width: 1.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_rounded, color: textColor.withValues(alpha: 0.2), size: 32),
          const SizedBox(height: 4),
          Text(
            'ADD NEW',
            style: TextStyle(
              color: textColor.withValues(alpha: 0.2),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatesGrid(List<String> currentIds, bool isDark, Color textColor) {
    final availableTemplates = QuickLogManager.allActions.values
        .where((action) => !currentIds.contains(action.id))
        .toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemCount: availableTemplates.length,
      itemBuilder: (context, index) {
        final action = availableTemplates[index];
        return _buildActionCard(action, false, isDark, textColor);
      },
    );
  }

  Widget _buildNoteBox(bool isDark) {
    return Center(
      child: Text(
        'Changes are applied to your dashboard immediately',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isDark ? Colors.white.withValues(alpha: 0.3) : const Color(0xFF16102B).withValues(alpha: 0.4),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
