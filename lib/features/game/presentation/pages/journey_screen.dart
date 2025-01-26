import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/features/game/domain/models/mental_health_state.dart';
import 'package:my_flutter_app/features/game/presentation/providers/game_state_provider.dart';

class JourneyScreen extends ConsumerWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTaskSection(
                title: 'Quick Wins',
                description: 'Start with these simple tasks',
                tasks: gameState.journeyTasks
                    .where((task) => task.difficulty == TaskDifficulty.beginner)
                    .toList(),
                gameState: gameState,
                ref: ref,
              ),
              const SizedBox(height: 24),
              _buildTaskSection(
                title: 'Growth Tasks',
                description: 'Complete 3 Quick Wins to unlock',
                tasks: gameState.journeyTasks
                    .where((task) =>
                        task.difficulty == TaskDifficulty.intermediate)
                    .toList(),
                gameState: gameState,
                ref: ref,
                isLocked: !gameState.areIntermediateTasksUnlocked,
              ),
              const SizedBox(height: 24),
              _buildTaskSection(
                title: 'Advanced Challenges',
                description: 'Master Growth Tasks to unlock',
                tasks: gameState.journeyTasks
                    .where((task) => task.difficulty == TaskDifficulty.advanced)
                    .toList(),
                gameState: gameState,
                ref: ref,
                isLocked: !gameState.areAdvancedTasksUnlocked,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskSection({
    required String title,
    required String description,
    required List<JourneyTask> tasks,
    required MentalHealthState gameState,
    required WidgetRef ref,
    bool isLocked = false,
  }) {
    return Card(
      color: AppTheme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: AppTheme.textPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLocked)
                  Icon(
                    Icons.lock_outline,
                    color: AppTheme.textSecondaryColor,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (!isLocked) ...tasks.map((task) => _buildTaskItem(task)),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(JourneyTask task) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(
            task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
            color: task.isCompleted
                ? AppTheme.successColor
                : AppTheme.primaryColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontSize: 16,
                    decoration:
                        task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  task.description,
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '+${task.xpReward} XP',
              style: TextStyle(
                color: AppTheme.xpColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
