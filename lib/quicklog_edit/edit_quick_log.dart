import 'package:flutter/material.dart';
import '../utils/custom_popup.dart';
import '../utils/quick_log_manager.dart';

class EditQuickLogScreen extends StatefulWidget {
  const EditQuickLogScreen({super.key});

  @override
  State<EditQuickLogScreen> createState() => _EditQuickLogScreenState();
}

class _EditQuickLogScreenState extends State<EditQuickLogScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: QuickLogManager.currentActionIds,
      builder: (context, currentIds, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF0A0A0A),
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTipBox(),
                        const SizedBox(height: 32),
                        _buildSectionTitle('CURRENT ACTIONS (${currentIds.length})'),
                        const SizedBox(height: 16),
                        _buildCurrentActionsGrid(currentIds),
                        const SizedBox(height: 32),
                        _buildSectionTitle('QUICK ADD TEMPLATES'),
                        const SizedBox(height: 16),
                        _buildTemplatesGrid(currentIds),
                        const SizedBox(height: 40),
                        _buildSaveButton(),
                        const SizedBox(height: 20),
                        _buildNoteBox(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.08)),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Edit Quick Log', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              Text('Customize your shortcuts', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1437),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tip: Tap current actions to remove, or tap templates below to add them to your dashboard',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.2),
    );
  }

  Widget _buildCurrentActionsGrid(List<String> currentIds) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: currentIds.length + 1,
      itemBuilder: (context, index) {
        if (index == currentIds.length) {
          return _buildAddNewCard();
        }
        final id = currentIds[index];
        final action = QuickLogManager.allActions[id]!;
        return _buildActionCard(action, true);
      },
    );
  }

  Widget _buildActionCard(QuickLogAction action, bool isCurrent) {
    return GestureDetector(
      onTap: () {
        if (isCurrent) {
          QuickLogManager.removeAction(action.id);
        } else {
          QuickLogManager.addAction(action.id);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isCurrent ? action.color : const Color(0xFF16131A),
          borderRadius: BorderRadius.circular(20),
          border: isCurrent ? null : Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(action.icon, color: isCurrent ? Colors.white : Colors.white54, size: 28),
                  const SizedBox(height: 8),
                  Text(action.name, style: TextStyle(color: isCurrent ? Colors.white : Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Icon(
                isCurrent ? Icons.remove_circle : Icons.add_circle,
                color: isCurrent ? Colors.white60 : const Color(0xFF8B5CF6),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141121),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2D264D), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add, color: Color(0xFF8B5CF6), size: 28),
          const SizedBox(height: 8),
          Text('ADD NEW', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTemplatesGrid(List<String> currentIds) {
    final availableTemplates = QuickLogManager.allActions.values
        .where((action) => !currentIds.contains(action.id))
        .toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: availableTemplates.length,
      itemBuilder: (context, index) {
        final action = availableTemplates[index];
        return _buildActionCard(action, false);
      },
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
        boxShadow: [
          BoxShadow(color: const Color(0xFF8B5CF6).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          CustomPopup.show(
            context: context,
            title: 'Dashboard Updated',
            message: 'Your quick log shortcuts have been saved.',
            primaryColor: const Color(0xFF8B5CF6),
            onConfirm: () => Navigator.pop(context),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: const Text('Save & Return to Dashboard', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildNoteBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1410),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          'Note: Changes will be reflected on your dashboard immediately',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.orange.withValues(alpha: 0.7), fontSize: 12),
        ),
      ),
    );
  }
}
