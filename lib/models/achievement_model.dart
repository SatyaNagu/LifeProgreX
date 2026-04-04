import 'package:flutter/material.dart';

enum AchievementCategory {
  streak,
  habit,
  mood,
  workout,
  reading,
  skill,
  goal,
  analytics,
  combo,
  milestone,
  special,
}

enum AchievementRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
  mythic,
  divine,
  hidden,
}

class AchievementDefinition {
  final String id;
  final String badge;
  final String name;
  final String requirement;
  final AchievementCategory category;
  final AchievementRarity rarity;
  final int points;
  final int targetValue; // Multiplier for progress calculation

  const AchievementDefinition({
    required this.id,
    required this.badge,
    required this.name,
    required this.requirement,
    required this.category,
    required this.rarity,
    required this.points,
    required this.targetValue,
  });

  String get rarityLabel {
    switch (rarity) {
      case AchievementRarity.common: return 'COMMON';
      case AchievementRarity.uncommon: return 'UNCOMMON';
      case AchievementRarity.rare: return 'RARE';
      case AchievementRarity.epic: return 'EPIC';
      case AchievementRarity.legendary: return 'LEGENDARY';
      case AchievementRarity.mythic: return 'MYTHIC';
      case AchievementRarity.divine: return 'DIVINE';
      case AchievementRarity.hidden: return 'HIDDEN';
    }
  }

  Color get rarityColor {
    switch (rarity) {
      case AchievementRarity.common: return Colors.grey;
      case AchievementRarity.uncommon: return Colors.green;
      case AchievementRarity.rare: return Colors.blue;
      case AchievementRarity.epic: return Colors.purple;
      case AchievementRarity.legendary: return Colors.orange;
      case AchievementRarity.mythic: return Colors.red;
      case AchievementRarity.divine: return Colors.amber;
      case AchievementRarity.hidden: return Colors.black54;
    }
  }
}

class UserAchievement {
  final String achievementId;
  final int currentValue;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  UserAchievement({
    required this.achievementId,
    this.currentValue = 0,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  factory UserAchievement.fromJson(Map<String, dynamic> json) {
    return UserAchievement(
      achievementId: json['achievementId'] ?? '',
      currentValue: json['currentValue'] ?? 0,
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null ? DateTime.parse(json['unlockedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'achievementId': achievementId,
      'currentValue': currentValue,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }
}

class AchievementConstants {
  static const List<AchievementDefinition> allAchievements = [
    // 1️⃣ STREAK ACHIEVEMENTS 🔥
    AchievementDefinition(
      id: 'streak_1',
      badge: '🔥',
      name: 'First Flame',
      requirement: 'Reach 1-day streak',
      category: AchievementCategory.streak,
      rarity: AchievementRarity.common,
      points: 10,
      targetValue: 1,
    ),
    AchievementDefinition(
      id: 'streak_7',
      badge: '🔥🔥',
      name: 'Week Warrior',
      requirement: 'Reach 7-day streak',
      category: AchievementCategory.streak,
      rarity: AchievementRarity.common,
      points: 25,
      targetValue: 7,
    ),
    AchievementDefinition(
      id: 'streak_14',
      badge: '🔥🔥🔥',
      name: 'Fortnight Fighter',
      requirement: 'Reach 14-day streak',
      category: AchievementCategory.streak,
      rarity: AchievementRarity.uncommon,
      points: 50,
      targetValue: 14,
    ),
    AchievementDefinition(
      id: 'streak_30',
      badge: '🌟',
      name: 'Monthly Master',
      requirement: 'Reach 30-day streak',
      category: AchievementCategory.streak,
      rarity: AchievementRarity.rare,
      points: 100,
      targetValue: 30,
    ),
    AchievementDefinition(
      id: 'streak_90',
      badge: '💎',
      name: 'Quarter Champion',
      requirement: 'Reach 90-day streak',
      category: AchievementCategory.streak,
      rarity: AchievementRarity.epic,
      points: 250,
      targetValue: 90,
    ),
    AchievementDefinition(
      id: 'streak_180',
      badge: '👑',
      name: 'Half-Year Hero',
      requirement: 'Reach 180-day streak',
      category: AchievementCategory.streak,
      rarity: AchievementRarity.legendary,
      points: 500,
      targetValue: 180,
    ),
    AchievementDefinition(
      id: 'streak_365',
      badge: '🏆',
      name: 'Annual Legend',
      requirement: 'Reach 365-day streak',
      category: AchievementCategory.streak,
      rarity: AchievementRarity.mythic,
      points: 1000,
      targetValue: 365,
    ),
    AchievementDefinition(
      id: 'streak_500',
      badge: '⚡',
      name: 'Unstoppable Force',
      requirement: 'Reach 500-day streak',
      category: AchievementCategory.streak,
      rarity: AchievementRarity.mythic,
      points: 2000,
      targetValue: 500,
    ),
    AchievementDefinition(
      id: 'streak_1000',
      badge: '🌈',
      name: 'Eternal Flame',
      requirement: 'Reach 1000-day streak',
      category: AchievementCategory.streak,
      rarity: AchievementRarity.divine,
      points: 5000,
      targetValue: 1000,
    ),

    // 2️⃣ HABIT ACHIEVEMENTS 🎯
    AchievementDefinition(
      id: 'habit_create_1',
      badge: '📝',
      name: 'Habit Starter',
      requirement: 'Create 1st habit',
      category: AchievementCategory.habit,
      rarity: AchievementRarity.common,
      points: 10,
      targetValue: 1,
    ),
    AchievementDefinition(
      id: 'habit_create_5',
      badge: '📚',
      name: 'Habit Builder',
      requirement: 'Create 5 habits',
      category: AchievementCategory.habit,
      rarity: AchievementRarity.common,
      points: 25,
      targetValue: 5,
    ),
    AchievementDefinition(
      id: 'habit_create_10',
      badge: '🏗️',
      name: 'Habit Architect',
      requirement: 'Create 10 habits',
      category: AchievementCategory.habit,
      rarity: AchievementRarity.uncommon,
      points: 50,
      targetValue: 10,
    ),
    AchievementDefinition(
      id: 'habit_create_25',
      badge: '🎨',
      name: 'Habit Designer',
      requirement: 'Create 25 habits',
      category: AchievementCategory.habit,
      rarity: AchievementRarity.rare,
      points: 150,
      targetValue: 25,
    ),
    AchievementDefinition(
      id: 'habit_create_50',
      badge: '🌟',
      name: 'Habit Master',
      requirement: 'Create 50 habits',
      category: AchievementCategory.habit,
      rarity: AchievementRarity.epic,
      points: 300,
      targetValue: 50,
    ),
    AchievementDefinition(
      id: 'habit_create_100',
      badge: '👑',
      name: 'Habit Legend',
      requirement: 'Create 100 habits',
      category: AchievementCategory.habit,
      rarity: AchievementRarity.legendary,
      points: 750,
      targetValue: 100,
    ),
    AchievementDefinition(
      id: 'habit_comp_1',
      badge: '✅',
      name: 'First Step',
      requirement: 'Complete 1 habit',
      category: AchievementCategory.habit,
      rarity: AchievementRarity.common,
      points: 5,
      targetValue: 1,
    ),
    AchievementDefinition(
      id: 'habit_comp_perfect_day',
      badge: '💯',
      name: 'Perfect Day',
      requirement: 'Complete all habits in one day',
      category: AchievementCategory.habit,
      rarity: AchievementRarity.uncommon,
      points: 50,
      targetValue: 1,
    ),
    AchievementDefinition(
      id: 'habit_total_100',
      badge: '💎',
      name: 'Century Club',
      requirement: 'Complete 100 total habits',
      category: AchievementCategory.habit,
      rarity: AchievementRarity.uncommon,
      points: 75,
      targetValue: 100,
    ),
    AchievementDefinition(
      id: 'habit_total_1000',
      badge: '🎯',
      name: 'Thousand Club',
      requirement: 'Complete 1000 total habits',
      category: AchievementCategory.habit,
      rarity: AchievementRarity.rare,
      points: 300,
      targetValue: 1000,
    ),
    AchievementDefinition(
      id: 'habit_total_10000',
      badge: '🏆',
      name: 'Ten Thousand',
      requirement: 'Complete 10,000 total habits',
      category: AchievementCategory.habit,
      rarity: AchievementRarity.legendary,
      points: 1500,
      targetValue: 10000,
    ),

    // 3️⃣ MOOD LOG ACHIEVEMENTS 💗
    AchievementDefinition(
      id: 'mood_1',
      badge: '😊',
      name: 'Mood Tracker',
      requirement: 'Log mood 1 time',
      category: AchievementCategory.mood,
      rarity: AchievementRarity.common,
      points: 5,
      targetValue: 1,
    ),
    AchievementDefinition(
      id: 'mood_7',
      badge: '📊',
      name: 'Emotion Explorer',
      requirement: 'Log mood 7 days',
      category: AchievementCategory.mood,
      rarity: AchievementRarity.common,
      points: 20,
      targetValue: 7,
    ),
    AchievementDefinition(
      id: 'mood_30',
      badge: '🌈',
      name: 'Feeling Familiar',
      requirement: 'Log mood 30 days',
      category: AchievementCategory.mood,
      rarity: AchievementRarity.uncommon,
      points: 50,
      targetValue: 30,
    ),
    AchievementDefinition(
      id: 'mood_100',
      badge: '💖',
      name: 'Mood Master',
      requirement: 'Log mood 100 days',
      category: AchievementCategory.mood,
      rarity: AchievementRarity.rare,
      points: 150,
      targetValue: 100,
    ),
    AchievementDefinition(
      id: 'mood_zen_7',
      badge: '🧘',
      name: 'Zen Streak',
      requirement: 'Log "Happy" 7 days in a row',
      category: AchievementCategory.mood,
      rarity: AchievementRarity.uncommon,
      points: 75,
      targetValue: 7,
    ),
    AchievementDefinition(
      id: 'mood_positivity_30',
      badge: '🌟',
      name: 'Positivity Champion',
      requirement: 'Log "Happy" 30 days in a row',
      category: AchievementCategory.mood,
      rarity: AchievementRarity.epic,
      points: 250,
      targetValue: 30,
    ),
    AchievementDefinition(
      id: 'mood_spectrum',
      badge: '🎭',
      name: 'Full Spectrum',
      requirement: 'Log all 5 mood types',
      category: AchievementCategory.mood,
      rarity: AchievementRarity.uncommon,
      points: 40,
      targetValue: 5,
    ),
    AchievementDefinition(
      id: 'mood_365',
      badge: '💎',
      name: 'Self-Aware Sage',
      requirement: 'Log mood 365 days',
      category: AchievementCategory.mood,
      rarity: AchievementRarity.legendary,
      points: 500,
      targetValue: 365,
    ),

    // 4️⃣ WORKOUT ACHIEVEMENTS 💪
    AchievementDefinition(
      id: 'workout_1',
      badge: '🏃',
      name: 'First Rep',
      requirement: 'Log 1st workout',
      category: AchievementCategory.workout,
      rarity: AchievementRarity.common,
      points: 5,
      targetValue: 1,
    ),
    AchievementDefinition(
      id: 'workout_10',
      badge: '💪',
      name: 'Gym Regular',
      requirement: 'Log 10 workouts',
      category: AchievementCategory.workout,
      rarity: AchievementRarity.common,
      points: 25,
      targetValue: 10,
    ),
    AchievementDefinition(
      id: 'workout_50',
      badge: '🔥',
      name: 'Fitness Freak',
      requirement: 'Log 50 workouts',
      category: AchievementCategory.workout,
      rarity: AchievementRarity.uncommon,
      points: 75,
      targetValue: 50,
    ),
    AchievementDefinition(
      id: 'workout_100',
      badge: '🏋️',
      name: 'Iron Will',
      requirement: 'Log 100 workouts',
      category: AchievementCategory.workout,
      rarity: AchievementRarity.rare,
      points: 200,
      targetValue: 100,
    ),
    AchievementDefinition(
      id: 'workout_250',
      badge: '⚡',
      name: 'Beast Mode',
      requirement: 'Log 250 workouts',
      category: AchievementCategory.workout,
      rarity: AchievementRarity.epic,
      points: 500,
      targetValue: 250,
    ),
    AchievementDefinition(
      id: 'workout_500',
      badge: '👑',
      name: 'Fitness King/Queen',
      requirement: 'Log 500 workouts',
      category: AchievementCategory.workout,
      rarity: AchievementRarity.legendary,
      points: 1000,
      targetValue: 500,
    ),

    // 5️⃣ READING ACHIEVEMENTS 📚
    AchievementDefinition(
      id: 'read_1',
      badge: '📖',
      name: 'First Page',
      requirement: 'Log 1st reading session',
      category: AchievementCategory.reading,
      rarity: AchievementRarity.common,
      points: 5,
      targetValue: 1,
    ),
    AchievementDefinition(
      id: 'read_10',
      badge: '📚',
      name: 'Casual Reader',
      requirement: 'Log 10 reading sessions',
      category: AchievementCategory.reading,
      rarity: AchievementRarity.common,
      points: 25,
      targetValue: 10,
    ),
    AchievementDefinition(
      id: 'read_50',
      badge: '📗',
      name: 'Book Lover',
      requirement: 'Log 50 reading sessions',
      category: AchievementCategory.reading,
      rarity: AchievementRarity.uncommon,
      points: 75,
      targetValue: 50,
    ),
    AchievementDefinition(
      id: 'read_100',
      badge: '📘',
      name: 'Bookworm',
      requirement: 'Log 100 reading sessions',
      category: AchievementCategory.reading,
      rarity: AchievementRarity.rare,
      points: 200,
      targetValue: 100,
    ),

    // 6️⃣ SKILL ACHIEVEMENTS 🏆
    AchievementDefinition(
      id: 'skill_1',
      badge: '🌱',
      name: 'Skill Seedling',
      requirement: 'Log 1st skill practice',
      category: AchievementCategory.skill,
      rarity: AchievementRarity.common,
      points: 5,
      targetValue: 1,
    ),
    AchievementDefinition(
      id: 'skill_10',
      badge: '🌿',
      name: 'Skill Sprout',
      requirement: 'Log 10 skill sessions',
      category: AchievementCategory.skill,
      rarity: AchievementRarity.common,
      points: 25,
      targetValue: 10,
    ),
    AchievementDefinition(
      id: 'skill_50',
      badge: '🌳',
      name: 'Skill Tree',
      requirement: 'Log 50 skill sessions',
      category: AchievementCategory.skill,
      rarity: AchievementRarity.uncommon,
      points: 75,
      targetValue: 50,
    ),

    // 7️⃣ GOAL ACHIEVEMENTS 🎯
    AchievementDefinition(
      id: 'goal_create_1',
      badge: '🎯',
      name: 'Goal Setter',
      requirement: 'Create 1st goal',
      category: AchievementCategory.goal,
      rarity: AchievementRarity.common,
      points: 10,
      targetValue: 1,
    ),
    AchievementDefinition(
      id: 'goal_comp_1',
      badge: '✅',
      name: 'Goal Achiever',
      requirement: 'Complete 1st goal',
      category: AchievementCategory.goal,
      rarity: AchievementRarity.common,
      points: 25,
      targetValue: 1,
    ),
    AchievementDefinition(
      id: 'goal_comp_10',
      badge: '💯',
      name: 'Completionist',
      requirement: 'Complete 10 goals',
      category: AchievementCategory.goal,
      rarity: AchievementRarity.uncommon,
      points: 100,
      targetValue: 10,
    ),
    AchievementDefinition(
      id: 'goal_comp_25',
      badge: '🏆',
      name: 'Goal Master',
      requirement: 'Complete 25 goals',
      category: AchievementCategory.goal,
      rarity: AchievementRarity.rare,
      points: 250,
      targetValue: 25,
    ),

    // 8️⃣ ANALYTICS & ENGAGEMENT 📊
    AchievementDefinition(
      id: 'analytics_1',
      badge: '📊',
      name: 'Stats Curious',
      requirement: 'View Analytics page 1 time',
      category: AchievementCategory.analytics,
      rarity: AchievementRarity.common,
      points: 5,
      targetValue: 1,
    ),
    AchievementDefinition(
      id: 'ai_1',
      badge: '🤖',
      name: 'AI Curious',
      requirement: 'Use AI Coach 1 time',
      category: AchievementCategory.analytics,
      rarity: AchievementRarity.common,
      points: 10,
      targetValue: 1,
    ),

    // 1️⃣0️⃣ MILESTONE ACHIEVEMENTS 💎
    AchievementDefinition(
      id: 'milestone_onboarding',
      badge: '🎉',
      name: 'Welcome Aboard',
      requirement: 'Complete onboarding',
      category: AchievementCategory.milestone,
      rarity: AchievementRarity.common,
      points: 10,
      targetValue: 1,
    ),
    AchievementDefinition(
      id: 'milestone_week_1',
      badge: '📅',
      name: 'One Week In',
      requirement: 'Use app for 7 days',
      category: AchievementCategory.milestone,
      rarity: AchievementRarity.common,
      points: 25,
      targetValue: 7,
    ),
    AchievementDefinition(
      id: 'milestone_month_1',
      badge: '🌟',
      name: 'First Month',
      requirement: 'Use app for 30 days',
      category: AchievementCategory.milestone,
      rarity: AchievementRarity.uncommon,
      points: 75,
      targetValue: 30,
    ),

    // 1️⃣1️⃣ SPECIAL & HIDDEN 🎭
    AchievementDefinition(
      id: 'hidden_konami',
      badge: '👾',
      name: 'Konami Code',
      requirement: 'Enter secret sequence in app',
      category: AchievementCategory.special,
      rarity: AchievementRarity.hidden,
      points: 500,
      targetValue: 1,
    ),
    AchievementDefinition(
      id: 'hidden_perfectionist',
      badge: '💯',
      name: 'Perfectionist',
      requirement: 'Achieve exactly 100% 10 days',
      category: AchievementCategory.special,
      rarity: AchievementRarity.hidden,
      points: 150,
      targetValue: 10,
    ),
  ];
}
