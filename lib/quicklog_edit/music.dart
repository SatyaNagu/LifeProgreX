import 'package:flutter/material.dart';
import '../utils/custom_popup.dart';
import '../utils/premium_background.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final TextEditingController _musicController = TextEditingController();
  String _impact = 'Energy';
  bool _isSaving = false;

  final List<String> _impacts = ['Energy', 'Relax', 'Mood Boost', 'Focus'];

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
                      const Text('What are you listening to?', style: TextStyle(color: Colors.white70, fontSize: 16)),
                      const SizedBox(height: 12),
                      _buildTextField(),
                      const SizedBox(height: 32),
                      const Text('How does it affect you?', style: TextStyle(color: Colors.white70, fontSize: 16)),
                      const SizedBox(height: 16),
                      _buildImpactChips(),
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
          const Text('Music', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: const Color(0xFF16131A), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
      child: TextField(
        controller: _musicController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(hintText: 'Song / Album / Genre', hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)), border: InputBorder.none),
      ),
    );
  }

  Widget _buildImpactChips() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _impacts.map((opt) {
        final isSelected = _impact == opt;
        return GestureDetector(
          onTap: () => setState(() => _impact = opt),
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
            : const Text('Log Music', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
        title: 'Vibrating',
        message: 'Music session logged.',
        primaryColor: const Color(0xFF00D12E),
        onConfirm: () => Navigator.pop(context),
      );
    }
  }

  @override
  void dispose() {
    _musicController.dispose();
    super.dispose();
  }
}
