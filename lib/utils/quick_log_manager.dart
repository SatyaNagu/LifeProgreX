import 'package:flutter/material.dart';
import '../quicklog_edit/mood.dart';
import '../quicklog_edit/workout.dart';
import '../quicklog_edit/reading.dart';
import '../quicklog_edit/skills.dart';
import '../quicklog_edit/water.dart';
import '../quicklog_edit/meditation.dart';
import '../quicklog_edit/journal.dart';
import '../quicklog_edit/nutrition.dart';
import '../quicklog_edit/sleep.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../quicklog_edit/creative.dart';
import '../quicklog_edit/music.dart';
import '../quicklog_edit/social.dart';

class QuickLogAction {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final Widget page;

  QuickLogAction({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.page,
  });
}

class QuickLogManager {
  static const String _prefsKey = 'quick_log_active_ids';

  static final Map<String, QuickLogAction> allActions = {
    'mood': QuickLogAction(id: 'mood', name: 'MOOD', icon: Icons.waves, color: const Color(0xFFFF2D95), page: const MoodScreen()),
    'workout': QuickLogAction(id: 'workout', name: 'WORKOUT', icon: Icons.fitness_center, color: const Color(0xFFFFBF00), page: const WorkoutScreen()),
    'reading': QuickLogAction(id: 'reading', name: 'READING', icon: Icons.book_outlined, color: const Color(0xFF00D9FF), page: const ReadingScreen()),
    'skill': QuickLogAction(id: 'skill', name: 'SKILL', icon: Icons.emoji_events_outlined, color: const Color(0xFFB24BF3), page: const SkillsScreen()),
    'water': QuickLogAction(id: 'water', name: 'WATER', icon: Icons.opacity, color: const Color(0xFF4FC3F7), page: const WaterScreen()),
    'meditation': QuickLogAction(id: 'meditation', name: 'MEDITATION', icon: Icons.accessibility_new, color: const Color(0xFF9FA8DA), page: const MeditationScreen()),
    'journal': QuickLogAction(id: 'journal', name: 'JOURNAL', icon: Icons.description_outlined, color: const Color(0xFFAED581), page: const JournalScreen()),
    'nutrition': QuickLogAction(id: 'nutrition', name: 'NUTRITION', icon: Icons.restaurant, color: const Color(0xFFFF8A65), page: const NutritionScreen()),
    'sleep': QuickLogAction(id: 'sleep', name: 'SLEEP', icon: Icons.bedtime_outlined, color: const Color(0xFF7986CB), page: const SleepScreen()),
    'creative': QuickLogAction(id: 'creative', name: 'CREATIVE', icon: Icons.grid_view_rounded, color: const Color(0xFFE040FB), page: const CreativeScreen()),
    'music': QuickLogAction(id: 'music', name: 'MUSIC', icon: Icons.music_note, color: const Color(0xFFF06292), page: const MusicScreen()),
    'social': QuickLogAction(id: 'social', name: 'SOCIAL', icon: Icons.people_outline, color: const Color(0xFF4DB6AC), page: const SocialScreen()),
  };

  static final ValueNotifier<List<String>> currentActionIds = ValueNotifier<List<String>>([
    'mood', 'workout', 'skill', 'reading', 'journal'
  ]);

  static Future<void> loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIds = prefs.getStringList(_prefsKey);
      if (savedIds != null && savedIds.isNotEmpty) {
        // Enforce skill instead of reading for Analytics display preference
        int readingIdx = savedIds.indexOf('reading');
        int skillIdx = savedIds.indexOf('skill');
        if (readingIdx != -1 && readingIdx < 3) {
          if (skillIdx != -1) {
            savedIds[readingIdx] = 'skill';
            savedIds[skillIdx] = 'reading';
          } else {
            savedIds[readingIdx] = 'skill';
          }
          await prefs.setStringList(_prefsKey, savedIds);
        }
        currentActionIds.value = savedIds;
      }
    } catch (e) {
      debugPrint('Error loading QuickLog preferences: $e');
    }
  }

  static Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_prefsKey, currentActionIds.value);
    } catch (e) {
      debugPrint('Error saving QuickLog preferences: $e');
    }
  }

  static void addAction(String id) {
    if (!currentActionIds.value.contains(id)) {
      currentActionIds.value = [...currentActionIds.value, id];
      _savePreferences();
    }
  }

  static void removeAction(String id) {
    currentActionIds.value = currentActionIds.value.where((element) => element != id).toList();
    _savePreferences();
  }

  static void reorder(int oldIndex, int newIndex) {
    final list = List<String>.from(currentActionIds.value);
    if (newIndex > oldIndex) newIndex -= 1;
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    currentActionIds.value = list;
    _savePreferences();
  }


}
