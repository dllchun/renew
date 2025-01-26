import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/features/game/domain/models/mental_health_state.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/main.dart'; // Add this import for navigatorKey

final gameStateProvider =
    StateNotifierProvider<GameStateNotifier, MentalHealthState>((ref) {
  return GameStateNotifier(
    MentalHealthState(
      percentage: 0.4,
      level: 1,
      xpPoints: 30,
      streakDays: 0, // Start with 0 streak days
      dailyXP: 0, // Start with 0 daily XP
      todaysMoods: [],
    ),
  );
});

class GameStateNotifier extends StateNotifier<MentalHealthState> {
  GameStateNotifier(MentalHealthState initialState) : super(initialState);

  void addXP(int amount) {
    final newTotalXP = state.xpPoints + amount;
    final newDailyXP = state.dailyXP + amount;
    final currentLevel = state.level;
    final wasLevelUp = newTotalXP >= state.nextLevelXP;

    if (wasLevelUp) {
      state = state.copyWith(
        xpPoints: newTotalXP - state.nextLevelXP,
        dailyXP: newDailyXP, // Keep track of daily XP
        level: currentLevel + 1,
      );

      // Show level up notification
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.stars, color: Colors.yellow),
              const SizedBox(width: 8),
              Text(
                'Level Up! You reached Level ${currentLevel + 1}',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: AppTheme.successColor,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      state = state.copyWith(
        xpPoints: newTotalXP,
        dailyXP: newDailyXP, // Keep track of daily XP
      );

      // Show XP gained notification
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.add_circle, color: Colors.yellow),
              const SizedBox(width: 8),
              Text(
                '+$amount XP',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: AppTheme.primaryColor.withOpacity(0.9),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void updatePercentage(double amount) {
    final newPercentage = (state.percentage + amount).clamp(0.0, 1.0);
    state = state.copyWith(percentage: newPercentage);
  }

  void addStreak() {
    final newStreakDays = state.streakDays + 1;
    state = state.copyWith(streakDays: newStreakDays);

    // Show streak notification with bonus XP
    final streakBonus = newStreakDays * 5; // 5 XP per streak day
    addXP(streakBonus);

    // Show streak milestone notification
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.local_fire_department, color: Colors.orange),
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$newStreakDays Day Streak! 🔥',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '+$streakBonus XP Streak Bonus!',
                  style: TextStyle(
                    color: Colors.orange[100],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.deepOrange.withOpacity(0.9),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void resetStreak() {
    if (state.streakDays > 0) {
      state = state.copyWith(streakDays: 0);

      // Show streak lost notification
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.water_drop, color: Colors.blue[200]),
              const SizedBox(width: 8),
              const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Streak Reset',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Complete tasks today to start a new streak!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: Colors.blueGrey.withOpacity(0.9),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void updateCategoryProgress(String category, double progress) {
    final newProgress = Map<String, double>.from(state.categoryProgress);
    newProgress[category] = (newProgress[category] ?? 0.0) + progress;
    state = state.copyWith(categoryProgress: newProgress);
  }

  void unlockAchievement(String achievementId) {
    if (!state.unlockedAchievements.contains(achievementId)) {
      final newAchievements = List<String>.from(state.unlockedAchievements)
        ..add(achievementId);
      state = state.copyWith(unlockedAchievements: newAchievements);
    }
  }

  void checkDailyReset() {
    final now = DateTime.now();
    final lastCheckIn = state.lastCheckIn;
    final difference = now.difference(lastCheckIn);

    if (difference.inDays >= 1) {
      // If it's exactly one day since last check-in, increment streak
      if (difference.inDays == 1 && state.tasksCompletedToday > 0) {
        addStreak();
      } else {
        // If more than one day has passed, reset streak
        resetStreak();
      }

      // Reset daily tasks and XP
      resetDailyTasks();
      resetJourneyTasks();
      state = state.copyWith(
        lastCheckIn: now,
        dailyXP: 0, // Reset daily XP
        tasksCompletedToday: 0,
      );
    }
  }

  // New methods for mood tracking
  void updateMood(String mood, int xpReward) {
    if (!state.canRecordMood()) {
      // If we can't record a mood yet, just return
      return;
    }

    final now = DateTime.now();
    final xpToAward = state.calculateMoodXP();

    // Create new mood entry
    final newMood = MoodEntry(
      mood: mood,
      timestamp: now,
      xpEarned: xpToAward,
    );

    // Add XP for logging mood
    addXP(xpToAward);

    // Update moods list
    final updatedMoods = List<MoodEntry>.from(state.todaysMoods)..add(newMood);

    // Check for streak
    final lastCheckIn = state.lastCheckIn;
    final difference = now.difference(lastCheckIn);

    if (difference.inDays >= 1) {
      if (difference.inDays == 1) {
        addStreak();
      } else {
        resetStreak();
      }
    }

    // Update state
    state = state.copyWith(
      lastCheckIn: now,
      todaysMoods: updatedMoods,
    );
  }

  // Helper method to check if we can record mood
  bool canRecordMood() => state.canRecordMood();

  // Get remaining time until next mood entry
  Duration? getTimeUntilNextMood() {
    if (state.todaysMoods.isEmpty) return null;

    final lastMood = state.todaysMoods.last;
    final now = DateTime.now();
    final nextPossibleEntry = lastMood.timestamp.add(const Duration(hours: 2));

    if (now.isBefore(nextPossibleEntry)) {
      return nextPossibleEntry.difference(now);
    }
    return null;
  }

  void addProgress(double amount) {
    updatePercentage(amount);
  }

  // Task management methods
  void completeTask(String taskId) {
    final tasks = List<Task>.from(state.dailyTasks);
    final taskIndex = tasks.indexWhere((task) => task.id == taskId);

    if (taskIndex != -1 && !tasks[taskIndex].isCompleted) {
      final task = tasks[taskIndex];
      tasks[taskIndex] = task.copyWith(
        isCompleted: true,
        timestamp: DateTime.now(),
      );

      // Add XP for completing the task
      addXP(task.xpReward);

      // Update category progress
      updateCategoryProgress(task.category, 0.1);

      // Map daily tasks to journey tasks
      final journeyTaskId = switch (taskId) {
        'meditation' => 'mindful_breathing_1',
        'movement' => 'physical_stretch_1',
        'gratitude' => 'emotional_gratitude_1',
        _ => '',
      };

      if (journeyTaskId.isNotEmpty) {
        // Update the corresponding journey task
        final updatedJourneyTasks = state.journeyTasks.map((jTask) {
          if (jTask.id == journeyTaskId) {
            return jTask.copyWith(
              isCompleted: true,
              completedAt: DateTime.now(),
            );
          }
          return jTask;
        }).toList();

        // Update state with completed task
        state = state.copyWith(
          dailyTasks: tasks,
          journeyTasks: updatedJourneyTasks,
          tasksCompletedToday: state.tasksCompletedToday + 1,
        );
      } else {
        // Update state with just the daily task
        state = state.copyWith(
          dailyTasks: tasks,
          tasksCompletedToday: state.tasksCompletedToday + 1,
        );
      }

      // Check if we should unlock more tasks
      _checkTaskProgression();
    }
  }

  bool isTaskCompleted(String taskId) {
    return state.dailyTasks
        .any((task) => task.id == taskId && task.isCompleted);
  }

  void resetDailyTasks() {
    final now = DateTime.now();
    final lastTask = state.dailyTasks.lastWhere(
      (task) => task.isCompleted,
      orElse: () => state.dailyTasks.first,
    );

    if (lastTask.timestamp.day != now.day) {
      // Reset tasks for new day
      final newTasks = state.dailyTasks
          .map(
            (task) => task.copyWith(isCompleted: false),
          )
          .toList();

      state = state.copyWith(dailyTasks: newTasks);
    }
  }

  void startJourneyTask(JourneyTask task) {
    final now = DateTime.now();

    // Update task completion and check if all tasks are done
    var updatedTasks = state.journeyTasks.map((t) {
      if (t.id == task.id) {
        return t.copyWith(
          isCompleted: true,
          completedAt: now,
        );
      }
      return t;
    }).toList();

    // Check if this completes all tasks for today
    final allTasksCompleted =
        updatedTasks.where((t) => t.isUnlocked).every((t) => t.isCompleted);

    if (allTasksCompleted) {
      // Add streak when all tasks are completed
      addStreak();
    }

    // Rest of the existing code...
    final taskType = switch (task.difficulty) {
      TaskDifficulty.beginner => 'quick_win',
      TaskDifficulty.intermediate => 'growth',
      TaskDifficulty.advanced => 'deep_practice'
    };

    final heartChange = state.calculateHeartChange(taskType, task.category);
    final recoveryBonus = state.getRecoveryBonus();
    final totalChange = heartChange + recoveryBonus;

    updatePercentage(totalChange);
    addXP(task.xpReward);
    updateCategoryProgress(task.category, 0.1);

    // Update state
    state = state.copyWith(
      journeyTasks: updatedTasks,
      lastTaskCompletionHour: now.hour,
      tasksCompletedToday: state.tasksCompletedToday + 1,
    );
  }

  void _checkTaskProgression() {
    // Count all completed daily tasks
    final completedDailyTasks =
        state.dailyTasks.where((task) => task.isCompleted).length;

    // If user has completed 3 daily tasks, unlock intermediate
    if (completedDailyTasks >= 3) {
      final updatedTasks = state.journeyTasks.map((task) {
        if (!task.isUnlocked &&
            task.difficulty == TaskDifficulty.intermediate) {
          // Show unlock notification
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.lock_open, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text(
                    'Growth Tasks Unlocked! 🎉',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: AppTheme.successColor.withOpacity(0.9),
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return task.copyWith(isUnlocked: true);
        }
        return task;
      }).toList();

      state = state.copyWith(journeyTasks: updatedTasks);
    }

    // If user has completed all intermediate tasks, unlock advanced
    final completedIntermediateTasks = state.journeyTasks
        .where(
          (task) =>
              task.difficulty == TaskDifficulty.intermediate &&
              task.isCompleted,
        )
        .length;

    final totalIntermediateTasks = state.journeyTasks
        .where(
          (task) => task.difficulty == TaskDifficulty.intermediate,
        )
        .length;

    if (completedIntermediateTasks == totalIntermediateTasks &&
        completedIntermediateTasks > 0) {
      final updatedTasks = state.journeyTasks.map((task) {
        if (!task.isUnlocked && task.difficulty == TaskDifficulty.advanced) {
          return task.copyWith(isUnlocked: true);
        }
        return task;
      }).toList();

      state = state.copyWith(journeyTasks: updatedTasks);
    }
  }

  void resetJourneyTasks() {
    final now = DateTime.now();
    final lastCompletedTask =
        state.journeyTasks.where((task) => task.isCompleted).lastOrNull;

    // Only reset if there's a completed task and it's from a previous day
    if (lastCompletedTask != null &&
        lastCompletedTask.completedAt?.day != now.day) {
      final updatedTasks = state.journeyTasks.map((task) {
        // Keep the unlock status but reset completion
        return task.copyWith(
          isCompleted: false,
          completedAt: null,
        );
      }).toList();

      state = state.copyWith(journeyTasks: updatedTasks);
    }
  }
}
