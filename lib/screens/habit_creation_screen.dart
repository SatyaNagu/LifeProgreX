import 'package:flutter/material.dart';
import '../utils/theme_manager.dart';
import '../utils/premium_background.dart';
import '../services/firestore_service.dart';
import '../models/habit_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HabitCreationScreen extends StatefulWidget {
  const HabitCreationScreen({super.key});

  @override
  State<HabitCreationScreen> createState() => _HabitCreationScreenState();
}

class _HabitCreationScreenState extends State<HabitCreationScreen> {
  final ThemeManager _themeManager = ThemeManager();
  final FirestoreService _firestoreService = FirestoreService();
  
  final TextEditingController _titleController = TextEditingController();
  HabitCategory _selectedCategory = HabitCategory.health;
  bool _isLoading = false;

  Future<void> _handleSave() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a habit title!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("You must be logged in to create a habit.");
      }

      final newHabit = HabitModel(
        id: '', // Firestore auto-generates this ID
        userId: user.uid,
        title: title,
        category: _selectedCategory,
        createdAt: DateTime.now(),
        currentStreak: 0,
      );

      await _firestoreService.addHabit(newHabit);

      if (mounted) {
        setState(() => _isLoading = false);
        // Navigate back to the Dashboard
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 Successfully created "$title"!'),
            backgroundColor: const Color(0xFF10C655),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save habit: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeManager.isDarkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);

    return PremiumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Create Habit',
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Habit Title',
                style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'e.g., Run 5km daily',
                  hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
                  filled: true,
                  fillColor: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Category',
                style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<HabitCategory>(
                    value: _selectedCategory,
                    dropdownColor: isDark ? const Color(0xFF221A3D) : Colors.white,
                    style: TextStyle(color: textColor, fontSize: 16),
                    icon: Icon(Icons.arrow_drop_down, color: textColor),
                    isExpanded: true,
                    items: HabitCategory.values.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    },
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Save Habit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
