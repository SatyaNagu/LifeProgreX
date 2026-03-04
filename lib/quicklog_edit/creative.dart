import 'package:flutter/material.dart';
import '../utils/custom_popup.dart';
import '../utils/premium_background.dart';

class CreativeScreen extends StatefulWidget {
  const CreativeScreen({super.key});

  @override
  State<CreativeScreen> createState() => _CreativeScreenState();
}

class _CreativeScreenState extends State<CreativeScreen> {
  final TextEditingController _activityController = TextEditingController();
  int _duration = 30;
  bool _isSaving = false;

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
                      const Text('Activity Name', style: TextStyle(color: Colors.white70, fontSize: 16)),
                      const SizedBox(height: 12),
                      _buildTextField(),
                      const SizedBox(height: 32),
                      const Text('Duration (minutes)', style: TextStyle(color: Colors.white70, fontSize: 16)),
                      const SizedBox(height: 12),
                      _buildDurationDisplay(),
                      _buildDurationSlider(),
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
          const Text('Creative Work', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: const Color(0xFF16131A), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
      child: TextField(
        controller: _activityController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(hintText: 'Painting, Writing, etc.', hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)), border: InputBorder.none),
      ),
    );
  }

  Widget _buildDurationDisplay() {
    return Center(
      child: Text('$_duration min', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDurationSlider() {
    return Slider(
      value: _duration.toDouble(),
      min: 5,
      max: 240,
      divisions: 47,
      activeColor: const Color(0xFF8B5CF6),
      inactiveColor: Colors.white10,
      onChanged: (v) => setState(() => _duration = v.toInt()),
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
            : const Text('Log Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (_activityController.text.isEmpty) {
      CustomPopup.show(context: context, title: 'Incomplete', message: 'What were you working on?', primaryColor: Colors.orange);
      return;
    }
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isSaving = false);
      CustomPopup.show(
        context: context,
        title: 'Inspired',
        message: 'Your creative progress is saved.',
        primaryColor: const Color(0xFF00D12E),
        onConfirm: () => Navigator.pop(context),
      );
    }
  }

  @override
  void dispose() {
    _activityController.dispose();
    super.dispose();
  }
}
