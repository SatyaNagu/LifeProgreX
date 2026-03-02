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
  static final Map<String, QuickLogAction> allActions = {
    'mood': QuickLogAction(id: 'mood', name: 'MOOD', icon: Icons.waves, color: const Color(0xFFF98E2F), page: const MoodScreen()),
    'workout': QuickLogAction(id: 'workout', name: 'WORKOUT', icon: Icons.fitness_center, color: const Color(0xFFF98E2F), page: const WorkoutScreen()),
    'reading': QuickLogAction(id: 'reading', name: 'READING', icon: Icons.book_outlined, color: const Color(0xFFF98E2F), page: const ReadingScreen()),
    'skill': QuickLogAction(id: 'skill', name: 'SKILL', icon: Icons.emoji_events_outlined, color: const Color(0xFFF98E2F), page: const SkillsScreen()),
    'water': QuickLogAction(id: 'water', name: 'WATER', icon: Icons.opacity, color: const Color(0xFFF98E2F), page: const WaterScreen()),
    'meditation': QuickLogAction(id: 'meditation', name: 'MEDITATION', icon: Icons.accessibility_new, color: const Color(0xFFF98E2F), page: const MeditationScreen()),
    'journal': QuickLogAction(id: 'journal', name: 'JOURNAL', icon: Icons.description_outlined, color: const Color(0xFFF98E2F), page: const JournalScreen()),
    'nutrition': QuickLogAction(id: 'nutrition', name: 'NUTRITION', icon: Icons.restaurant, color: const Color(0xFFF98E2F), page: const NutritionScreen()),
    'sleep': QuickLogAction(id: 'sleep', name: 'SLEEP', icon: Icons.bedtime_outlined, color: const Color(0xFFF98E2F), page: const SleepScreen()),
    'creative': QuickLogAction(id: 'creative', name: 'CREATIVE', icon: Icons.grid_view_rounded, color: const Color(0xFFF98E2F), page: const CreativeScreen()),
    'music': QuickLogAction(id: 'music', name: 'MUSIC', icon: Icons.music_note, color: const Color(0xFFF98E2F), page: const MusicScreen()),
    'social': QuickLogAction(id: 'social', name: 'SOCIAL', icon: Icons.people_outline, color: const Color(0xFFF98E2F), page: const SocialScreen()),
  };

  static final ValueNotifier<List<String>> currentActionIds = ValueNotifier<List<String>>([
    'mood', 'workout', 'reading', 'skill', 'journal'
  ]);

  static void addAction(String id) {
    if (!currentActionIds.value.contains(id)) {
      currentActionIds.value = [...currentActionIds.value, id];
    }
  }

  static void removeAction(String id) {
    currentActionIds.value = currentActionIds.value.where((element) => element != id).toList();
  }

  static void reorder(int oldIndex, int newIndex) {
    final list = List<String>.from(currentActionIds.value);
    if (newIndex > oldIndex) newIndex -= 1;
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    currentActionIds.value = list;
  }
}
