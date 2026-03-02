import 'package:flutter/material.dart';
import '../utils/custom_popup.dart';

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

  final List<Map<String, dynamic>> _workoutTypes = [
    {'label': 'Cardio', 'icon': Icons.bolt_outlined},
    {'label': 'Strength', 'icon': Icons.fitness_center},
    {'label': 'Yoga', 'icon': Icons.self_improvement},
    {'label': 'Sports', 'icon': Icons.emoji_events_outlined},
    {'label': 'HIIT', 'icon': Icons.local_fire_department_outlined},
    {'label': 'Swimming', 'icon': Icons.waves},
  ];

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
                      _buildSectionTitle('Workout Type'),
                      const SizedBox(height: 16),
                      _buildTypeGrid(),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Duration'),
                      const SizedBox(height: 16),
                      _buildDurationStepper(),
                      const SizedBox(height: 24),
                      _buildSectionIntensity(),
                      const SizedBox(height: 16),
                      _buildIntensitySlider(),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Notes (Optional)'),
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
                'Log Workout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Track your exercise session',
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
              'Assets/onboarding_image_2.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Center(
                child: Icon(
                  Icons.fitness_center,
                  color: Colors.white.withValues(alpha: 0.1),
                  size: 64,
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

  Widget _buildSectionIntensity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Intensity Level',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'How hard did you work? (1-10)',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: _workoutTypes.length,
      itemBuilder: (context, index) {
        final type = _workoutTypes[index];
        final isSelected = _selectedType == type['label'];
        return GestureDetector(
          onTap: () => setState(() => _selectedType = type['label']),
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
                  type['icon'],
                  color: isSelected ? const Color(0xFF8B5CF6) : Colors.white54,
                  size: 28,
                ),
                const SizedBox(height: 8),
                Text(
                  type['label'],
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

  Widget _buildIntensitySlider() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16131A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(10, (index) {
              final active = index < _intensity;
              Color color = Colors.white.withValues(alpha: 0.05);
              if (active) {
                if (index < 3) {
                  color = const Color(0xFF00D12E); // Green
                } else if (index < 6) {
                  color = const Color(0xFFF98E2F); // Orange
                } else {
                  color = Colors.redAccent; // Red
                }
              }
              return Expanded(
                child: Container(
                  height: 30,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_intensity.toInt()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ' / 10',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Slider(
            value: _intensity,
            min: 1,
            max: 10,
            divisions: 9,
            activeColor: const Color(0xFF8B5CF6),
            onChanged: (val) => setState(() => _intensity = val),
          ),
        ],
      ),
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
        decoration: InputDecoration(
          hintText: "e.g., 5K run, felt great!",
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    final bool isReady = _selectedType != null || _noteController.text.isNotEmpty;

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
            : const Text('Save Workout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isSaving = false);
      CustomPopup.show(
        context: context,
        title: 'Success',
        message: 'Workout Saved Successfully!',
        primaryColor: const Color(0xFF00D12E),
        onConfirm: () => Navigator.pop(context),
      );
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}
