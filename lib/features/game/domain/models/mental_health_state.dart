import 'package:flutter/material.dart';

enum MentalHealthLevel {
  empty(0, 'Empty Heart', 0.0),
  beginner(1, 'Awakening Heart', 0.2),
  intermediate(2, 'Growing Heart', 0.4),
  advanced(3, 'Glowing Heart', 0.6),
  master(4, 'Radiant Heart', 0.8),
  enlightened(5, 'Enlightened Heart', 1.0);

  final int level;
  final String title;
  final double fillPercentage;

  const MentalHealthLevel(this.level, this.title, this.fillPercentage);

  static MentalHealthLevel fromPercentage(double percentage) {
    if (percentage >= 1.0) return enlightened;
    if (percentage >= 0.8) return master;
    if (percentage >= 0.6) return advanced;
    if (percentage >= 0.4) return intermediate;
    if (percentage >= 0.2) return beginner;
    return empty;
  }
}

class MentalHealthState {
  final double percentage;
  final int xpPoints;
  final int level;
  final int streakDays;
  final DateTime lastCheckIn;
  final List<String> unlockedAchievements;
  final Map<String, double> categoryProgress;

  MentalHealthState({
    this.percentage = 0.0,
    this.xpPoints = 0,
    this.level = 1,
    this.streakDays = 0,
    DateTime? lastCheckIn,
    List<String>? unlockedAchievements,
    Map<String, double>? categoryProgress,
  }) : 
    lastCheckIn = lastCheckIn ?? DateTime.now(),
    unlockedAchievements = unlockedAchievements ?? const [],
    categoryProgress = categoryProgress ?? {
      'mind': 0.0,
      'body': 0.0,
      'soul': 0.0,
    };

  MentalHealthLevel get currentLevel => MentalHealthLevel.fromPercentage(percentage);

  Color get heartColor {
    return Color.lerp(
      const Color(0xFF6B7280), // Empty heart color
      const Color(0xFFFF6B6B), // Full heart color
      percentage,
    ) ?? const Color(0xFF6B7280);
  }

  int get nextLevelXP => (level * 100) + (level * 50);
  
  double get levelProgress => xpPoints / nextLevelXP;

  bool get canLevelUp => xpPoints >= nextLevelXP;

  MentalHealthState copyWith({
    double? percentage,
    int? xpPoints,
    int? level,
    int? streakDays,
    DateTime? lastCheckIn,
    List<String>? unlockedAchievements,
    Map<String, double>? categoryProgress,
  }) {
    return MentalHealthState(
      percentage: percentage ?? this.percentage,
      xpPoints: xpPoints ?? this.xpPoints,
      level: level ?? this.level,
      streakDays: streakDays ?? this.streakDays,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      categoryProgress: categoryProgress ?? this.categoryProgress,
    );
  }
} 
