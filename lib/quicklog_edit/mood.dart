import 'package:flutter/material.dart';
import '../utils/custom_popup.dart';

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

  final List<Map<String, dynamic>> _moods = [
    {'label': 'Terrible', 'emoji': '😢'},
    {'label': 'Bad', 'emoji': '😟'},
    {'label': 'Okay', 'emoji': '😐'},
    {'label': 'Good', 'emoji': '🙂'},
    {'label': 'Great', 'emoji': '😊'},
    {'label': 'Amazing', 'emoji': '🤩'},
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B113D),
              Color(0xFF050505),
              Color(0xFF140A05),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
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
                      _buildSectionTitle('Select Your Mood'),
                      const SizedBox(height: 16),
                      _buildMoodGrid(),
                      const SizedBox(height: 24),
                      _buildSectionTitle('What influenced your mood?'),
                      const SizedBox(height: 8),
                      Text(
                        'Select all that apply',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfluenceGrid(),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Add a Note (Optional)'),
                      const SizedBox(height: 8),
                      Text(
                        'Write about your day or feelings',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildNoteField(),
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
                'Log Mood',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'How are you feeling today?',
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
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'Assets/onboarding_image.png', // Fallback to an existing asset
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Center(
                child: Icon(
                  Icons.mood_outlined,
                  color: Colors.white.withValues(alpha: 0.1),
                  size: 64,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
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

  Widget _buildMoodGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: _moods.length,
      itemBuilder: (context, index) {
        final mood = _moods[index];
        final isSelected = _selectedMood == mood['label'];
        return GestureDetector(
          onTap: () => setState(() => _selectedMood = mood['label']),
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
                Text(
                  mood['emoji'],
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  mood['label'],
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: isSelected ? 1.0 : 0.6),
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfluenceGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: _influences.length,
      itemBuilder: (context, index) {
        final influence = _influences[index];
        final isSelected = _selectedInfluences.contains(influence['label']);
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
          child: Container(
            decoration: BoxDecoration(
              color: isSelected 
                  ? const Color(0xFFF98E2F).withValues(alpha: 0.2)
                  : const Color(0xFF16131A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFFF98E2F) : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  influence['icon'],
                  color: isSelected ? const Color(0xFFF98E2F) : Colors.white54,
                  size: 28,
                ),
                const SizedBox(height: 8),
                Text(
                  influence['label'],
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: isSelected ? 1.0 : 0.6),
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoteField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16131A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: TextField(
        controller: _noteController,
        style: const TextStyle(color: Colors.white),
        maxLines: 4,
        decoration: InputDecoration(
          hintText: "What's on your mind today?",
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    final bool isReady = _selectedMood != null || _selectedInfluences.isNotEmpty || _noteController.text.isNotEmpty;

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
          elevation: 0,
        ),
        child: _isSaving
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Save Mood Log',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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

    setState(() => _isSaving = true);

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isSaving = false);
      CustomPopup.show(
        context: context,
        title: 'Success',
        message: 'Mood Log Saved Successfully!',
        primaryColor: const Color(0xFF00D12E),
        onConfirm: () => Navigator.pop(context),
      );
    }
  }
}
