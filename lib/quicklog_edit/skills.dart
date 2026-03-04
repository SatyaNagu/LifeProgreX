import 'package:flutter/material.dart';
import '../utils/custom_popup.dart';
import '../utils/premium_background.dart';

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  String? _selectedCategory;
  int _duration = 30;
  final TextEditingController _skillController = TextEditingController();
  final TextEditingController _reflectionController = TextEditingController();
  bool _isSaving = false;

  final List<Map<String, dynamic>> _categories = [
    {'label': 'Coding', 'icon': Icons.code},
    {'label': 'Language', 'icon': Icons.language},
    {'label': 'Music', 'icon': Icons.headset_mic_outlined},
    {'label': 'Art', 'icon': Icons.palette_outlined},
    {'label': 'Writing', 'icon': Icons.create_outlined},
    {'label': 'Other', 'icon': Icons.more_horiz},
  ];

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
                      const SizedBox(height: 16),
                      _buildImagePlaceholder(),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Skill Name'),
                      const SizedBox(height: 16),
                      _buildInputField('e.g., Python, Spanish, Guitar...'),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Category'),
                      const SizedBox(height: 16),
                      _buildCategoryGrid(),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Practice Duration'),
                      const SizedBox(height: 16),
                      _buildDurationStepper(),
                      const SizedBox(height: 24),
                      _buildSectionTitle('What did you learn? (Optional)'),
                      const SizedBox(height: 4),
                      Text(
                        'Reflect on your progress',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildReflectionField(),
                      const SizedBox(height: 32),
                      _buildSaveButton(),
                      const SizedBox(height: 32),
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Log Skill Practice',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Track your learning journey',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1A29),
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          'Assets/onboarding_image_4.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Icon(
              Icons.psychology,
              color: Colors.white.withValues(alpha: 0.1),
              size: 64,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInputField(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF16131A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: _skillController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final cat = _categories[index];
        final isSelected = _selectedCategory == cat['label'];
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat['label']),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected 
                  ? const Color(0xFF8B5CF6).withValues(alpha: 0.2)
                  : const Color(0xFF16131A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFF8B5CF6) : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  cat['icon'],
                  color: isSelected ? const Color(0xFF8B5CF6) : Colors.white54,
                  size: 28,
                ),
                const SizedBox(height: 8),
                Text(
                  cat['label'],
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: isSelected ? 1.0 : 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDurationStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF16131A),
        borderRadius: BorderRadius.circular(16),
      ),
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'minutes',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12,
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
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF8B5CF6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildReflectionField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16131A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: TextField(
        controller: _reflectionController,
        style: const TextStyle(color: Colors.white),
        maxLines: 4,
        decoration: InputDecoration(
          hintText: "e.g., Learned async/await, practiced chords...",
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    final bool isReady = _skillController.text.isNotEmpty && _selectedCategory != null;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: (_isSaving || !isReady) ? null : _handleSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: isReady ? const Color(0xFFF98E2F) : const Color(0xFF555555),
          disabledBackgroundColor: const Color(0xFF333333),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isSaving
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Text('Save Skill Practice', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
        title: 'Success',
        message: 'Skill Practice Saved Successfully!',
        primaryColor: const Color(0xFF00D12E),
        onConfirm: () => Navigator.pop(context),
      );
    }
  }

  @override
  void dispose() {
    _skillController.dispose();
    _reflectionController.dispose();
    super.dispose();
  }
}
