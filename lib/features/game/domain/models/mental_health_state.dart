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

class MoodEntry {
  final String mood;
  final DateTime timestamp;
  final int xpEarned;

  const MoodEntry({
    required this.mood,
    required this.timestamp,
    required this.xpEarned,
  });
}

class Task {
  final String id;
  final String title;
  final String category;
  final int xpReward;
  final bool isCompleted;
  final DateTime timestamp;

  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.xpReward,
    this.isCompleted = false,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Task copyWith({
    String? id,
    String? title,
    String? category,
    int? xpReward,
    bool? isCompleted,
    DateTime? timestamp,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      xpReward: xpReward ?? this.xpReward,
      isCompleted: isCompleted ?? this.isCompleted,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

enum TaskDifficulty {
  beginner, // 30-second tasks
  intermediate, // 1-minute activities
  advanced // 3-5 minute exercises
}

class JourneyTask {
  final String id;
  final String title;
  final String description;
  final String category;
  final TaskDifficulty difficulty;
  final int durationSeconds;
  final int xpReward;
  final bool isUnlocked;
  final bool isCompleted;
  final DateTime? completedAt;

  const JourneyTask({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.durationSeconds,
    required this.xpReward,
    this.isUnlocked = false,
    this.isCompleted = false,
    this.completedAt,
  });

  JourneyTask copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    TaskDifficulty? difficulty,
    int? durationSeconds,
    int? xpReward,
    bool? isUnlocked,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return JourneyTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      xpReward: xpReward ?? this.xpReward,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

class MentalHealthState {
  final double percentage;
  final int xpPoints;
  final int dailyXP;
  final int level;
  final int streakDays;
  late final DateTime lastCheckIn;
  final List<String> unlockedAchievements;
  late final Map<String, double> categoryProgress;
  late final List<MoodEntry> todaysMoods;
  late final List<Task> dailyTasks;
  final List<JourneyTask> journeyTasks;
  final int lastTaskCompletionHour;
  final int tasksCompletedToday;
  late Map<String, int> categoryTasksToday;

  MentalHealthState({
    this.percentage = 0.0,
    this.xpPoints = 0,
    this.dailyXP = 0,
    this.level = 1,
    this.streakDays = 0,
    DateTime? lastCheckIn,
    List<String>? unlockedAchievements,
    Map<String, double>? categoryProgress,
    List<MoodEntry>? todaysMoods,
    List<Task>? dailyTasks,
    List<JourneyTask>? journeyTasks,
    this.lastTaskCompletionHour = 0,
    this.tasksCompletedToday = 0,
    Map<String, int>? categoryTasksToday,
  })  : unlockedAchievements = unlockedAchievements ?? const [],
        journeyTasks = journeyTasks ??
            [
              // Mindfulness Tasks
              JourneyTask(
                id: 'mindful_breathing_1',
                title: 'Quick Breath',
                description: 'Take 3 deep breaths',
                category: 'mindfulness',
                difficulty: TaskDifficulty.beginner,
                durationSeconds: 30,
                xpReward: 10,
                isUnlocked: true,
              ),
              JourneyTask(
                id: 'mindful_breathing_2',
                title: 'Breathing Exercise',
                description: '1-minute guided breathing',
                category: 'mindfulness',
                difficulty: TaskDifficulty.intermediate,
                durationSeconds: 60,
                xpReward: 20,
              ),
              JourneyTask(
                id: 'mindful_meditation',
                title: 'Mini Meditation',
                description: '3-minute mindfulness session',
                category: 'mindfulness',
                difficulty: TaskDifficulty.advanced,
                durationSeconds: 180,
                xpReward: 40,
              ),
              // Physical Wellness Tasks
              JourneyTask(
                id: 'physical_stretch_1',
                title: 'Quick Stretch',
                description: 'Basic stretching routine',
                category: 'physical',
                difficulty: TaskDifficulty.beginner,
                durationSeconds: 30,
                xpReward: 10,
                isUnlocked: true,
              ),
              JourneyTask(
                id: 'physical_movement',
                title: 'Movement Break',
                description: '1-minute physical activity',
                category: 'physical',
                difficulty: TaskDifficulty.intermediate,
                durationSeconds: 60,
                xpReward: 20,
              ),
              // Emotional Balance Tasks
              JourneyTask(
                id: 'emotional_gratitude_1',
                title: 'Quick Gratitude',
                description: 'Write one thing you\'re grateful for',
                category: 'emotional',
                difficulty: TaskDifficulty.beginner,
                durationSeconds: 30,
                xpReward: 10,
                isUnlocked: true,
              ),
              JourneyTask(
                id: 'emotional_reflection',
                title: 'Mood Reflection',
                description: 'Reflect on your emotions',
                category: 'emotional',
                difficulty: TaskDifficulty.intermediate,
                durationSeconds: 60,
                xpReward: 20,
              ),
            ] {
    this.lastCheckIn = lastCheckIn ?? DateTime.now();
    this.categoryProgress = categoryProgress ??
        {
          'mind': 0.0,
          'body': 0.0,
          'soul': 0.0,
        };
    this.todaysMoods = todaysMoods ?? [];
    this.dailyTasks = dailyTasks ??
        [
          Task(
            id: 'mood_check',
            title: 'Daily Mood Check',
            category: 'mind',
            xpReward: 10,
          ),
          Task(
            id: 'meditation',
            title: 'Quick Meditation',
            category: 'mind',
            xpReward: 20,
          ),
          Task(
            id: 'gratitude',
            title: 'Gratitude Note',
            category: 'soul',
            xpReward: 15,
          ),
          Task(
            id: 'movement',
            title: 'Quick Movement',
            category: 'body',
            xpReward: 10,
          ),
          Task(
            id: 'streak',
            title: 'Maintain Streak',
            category: 'mind',
            xpReward: 5,
          ),
        ];
    this.categoryTasksToday = categoryTasksToday ?? {};
  }

  MentalHealthLevel get currentLevel =>
      MentalHealthLevel.fromPercentage(percentage);

  Color get heartColor {
    return Color.lerp(
          const Color(0xFF6B7280), // Empty heart color
          const Color(0xFFFF6B6B), // Full heart color
          percentage,
        ) ??
        const Color(0xFF6B7280);
  }

  int get nextLevelXP => (level * 100) + (level * 50);

  double get levelProgress => xpPoints / nextLevelXP;

  bool get canLevelUp => xpPoints >= nextLevelXP;

  bool canRecordMood() {
    if (todaysMoods.isEmpty) return true;

    final lastMood = todaysMoods.last;
    final now = DateTime.now();
    return now.difference(lastMood.timestamp).inHours >= 2;
  }

  int calculateMoodXP() {
    if (todaysMoods.isEmpty) return 10;
    return 5;
  }

  int get completedTaskCount =>
      dailyTasks.where((task) => task.isCompleted).length;
  int get totalTaskCount => dailyTasks.length;

  double calculateHeartChange(String taskType, String category) {
    double baseChange = switch (taskType) {
      'quick_win' => 0.02,
      'growth' => 0.04,
      'deep_practice' => 0.07,
      _ => 0.02
    };

    final now = DateTime.now();
    if (now.hour - lastTaskCompletionHour <= 2) {
      baseChange *= 1.2;
    }

    final uniqueCategories = categoryTasksToday.keys.length;
    if (uniqueCategories >= 2) {
      baseChange *= 1.1;
    }

    if (now.hour >= 6 && now.hour <= 10) {
      baseChange *= 1.15;
    }

    baseChange += (streakDays * 0.01);

    return baseChange;
  }

  double getRecoveryBonus() {
    if (percentage < 0.3) {
      return 0.05;
    }
    return 0.0;
  }

  MentalHealthState copyWith({
    double? percentage,
    int? xpPoints,
    int? dailyXP,
    int? level,
    int? streakDays,
    DateTime? lastCheckIn,
    List<String>? unlockedAchievements,
    Map<String, double>? categoryProgress,
    List<MoodEntry>? todaysMoods,
    List<Task>? dailyTasks,
    List<JourneyTask>? journeyTasks,
    int? lastTaskCompletionHour,
    int? tasksCompletedToday,
    Map<String, int>? categoryTasksToday,
  }) {
    return MentalHealthState(
      percentage: percentage ?? this.percentage,
      xpPoints: xpPoints ?? this.xpPoints,
      dailyXP: dailyXP ?? this.dailyXP,
      level: level ?? this.level,
      streakDays: streakDays ?? this.streakDays,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      categoryProgress: categoryProgress ?? this.categoryProgress,
      todaysMoods: todaysMoods ?? this.todaysMoods,
      dailyTasks: dailyTasks ?? this.dailyTasks,
      journeyTasks: journeyTasks ?? this.journeyTasks,
      lastTaskCompletionHour:
          lastTaskCompletionHour ?? this.lastTaskCompletionHour,
      tasksCompletedToday: tasksCompletedToday ?? this.tasksCompletedToday,
      categoryTasksToday: categoryTasksToday ?? this.categoryTasksToday,
    );
  }

  List<MoodEntry> getTodaysMoods() {
    final now = DateTime.now();
    return todaysMoods.where((entry) {
      return entry.timestamp.year == now.year &&
          entry.timestamp.month == now.month &&
          entry.timestamp.day == now.day;
    }).toList();
  }

  List<JourneyTask> getTasksByDifficulty(TaskDifficulty difficulty) {
    return journeyTasks.where((task) => task.difficulty == difficulty).toList();
  }

  List<JourneyTask> getTasksByCategory(String category) {
    return journeyTasks.where((task) => task.category == category).toList();
  }

  List<JourneyTask> getUnlockedTasks() {
    return journeyTasks.where((task) => task.isUnlocked).toList();
  }

  // Task unlocking getters
  bool get areIntermediateTasksUnlocked {
    final beginnerTasks = journeyTasks
        .where((task) => task.difficulty == TaskDifficulty.beginner);
    final completedBeginnerTasks =
        beginnerTasks.where((task) => task.isCompleted);
    return completedBeginnerTasks.length >= 3;
  }

  bool get areAdvancedTasksUnlocked {
    final intermediateTasks = journeyTasks
        .where((task) => task.difficulty == TaskDifficulty.intermediate);
    final completedIntermediateTasks =
        intermediateTasks.where((task) => task.isCompleted);
    return completedIntermediateTasks.length >= intermediateTasks.length;
  }
}
