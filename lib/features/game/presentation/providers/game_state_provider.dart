import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/features/game/domain/models/mental_health_state.dart';

final gameStateProvider = StateNotifierProvider<GameStateNotifier, MentalHealthState>((ref) {
  return GameStateNotifier(
    MentalHealthState(
      percentage: 0.4, // Set to 40% for testing
      level: 1,
      xpPoints: 30,
      streakDays: 3,
    ),
  );
});

class GameStateNotifier extends StateNotifier<MentalHealthState> {
  GameStateNotifier(MentalHealthState initialState) : super(initialState);

  void addXP(int amount) {
    final newXP = state.xpPoints + amount;
    final currentLevel = state.level;
    
    if (newXP >= state.nextLevelXP) {
      state = state.copyWith(
        xpPoints: newXP - state.nextLevelXP,
        level: currentLevel + 1,
      );
    } else {
      state = state.copyWith(xpPoints: newXP);
    }
  }

  void updatePercentage(double amount) {
    final newPercentage = (state.percentage + amount).clamp(0.0, 1.0);
    state = state.copyWith(percentage: newPercentage);
  }

  void addStreak() {
    state = state.copyWith(streakDays: state.streakDays + 1);
  }

  void resetStreak() {
    state = state.copyWith(streakDays: 0);
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
      if (difference.inDays == 1) {
        addStreak();
      } else {
        resetStreak();
      }
      state = state.copyWith(lastCheckIn: now);
    }
  }
} 