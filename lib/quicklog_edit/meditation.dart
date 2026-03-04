import 'package:flutter/material.dart';
import '../utils/custom_popup.dart';
import '../utils/premium_background.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  int _minutes = 10;
  String _selectedFocus = 'Breath';
  bool _isSaving = false;

  final List<String> _focusOptions = ['Breath', 'Mindfulness', 'Zen', 'Focus', 'Calm'];

  @override
  Widget build(BuildContext context) {
    return PremiumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      const Text('Duration (minutes)', style: TextStyle(color: Colors.white70, fontSize: 16)),
                      const SizedBox(height: 12),
                      _buildDurationSlider(),
                      const SizedBox(height: 32),
                      const Text('Focus Area', style: TextStyle(color: Colors.white70, fontSize: 16)),
                      const SizedBox(height: 16),
                      _buildFocusChips(),
                      const SizedBox(height: 60),
                      _buildSaveButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
          const Text('Meditation', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDurationSlider() {
    return Column(
      children: [
        Slider(
          value: _minutes.toDouble(),
          min: 1,
          max: 60,
          activeColor: const Color(0xFF8B5CF6),
          inactiveColor: Colors.white10,
          onChanged: (val) => setState(() => _minutes = val.toInt()),
        ),
        Text('$_minutes min', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildFocusChips() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _focusOptions.map((opt) {
        final isSelected = _selectedFocus == opt;
        return GestureDetector(
          onTap: () => setState(() => _selectedFocus = opt),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF8B5CF6).withValues(alpha: 0.2) : const Color(0xFF16131A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? const Color(0xFF8B5CF6) : Colors.white10),
            ),
            child: Text(opt, style: TextStyle(color: isSelected ? Colors.white : Colors.white60, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _handleSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF98E2F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _isSaving
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Log Meditation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
        title: 'Peace Found',
        message: 'Your meditation has been recorded.',
        primaryColor: const Color(0xFF00D12E),
        onConfirm: () => Navigator.pop(context),
      );
    }
  }
}
