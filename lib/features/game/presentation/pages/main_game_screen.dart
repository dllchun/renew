import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/features/game/domain/models/mental_health_state.dart';
import 'package:my_flutter_app/features/game/presentation/providers/game_state_provider.dart';
import 'package:my_flutter_app/features/game/presentation/widgets/heart_visualization.dart';
import 'package:my_flutter_app/features/game/presentation/widgets/breathing_exercise_dialog.dart';
import 'package:my_flutter_app/features/game/presentation/widgets/movement_exercise_dialog.dart';
import 'dart:async';

class MainGameScreen extends ConsumerWidget {
  const MainGameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      _buildHeartProgress(context, gameState),
                      const SizedBox(height: 24),
                      _buildDailyOverview(context, gameState),
                      const SizedBox(height: 24),
                      _buildMoodGrid(context, ref, gameState),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // TODO: Show notifications
            },
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildHeartProgress(BuildContext context, MentalHealthState state) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Heart Visual
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
              },
              child: HeartVisualization(
                state: state,
                size: 280,
              ),
            ),
            // Streak Badge
            if (state.streakDays > 0)
              Positioned(
                top: -45,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade400,
                          Colors.deepOrange.shade600
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${state.streakDays} Day${state.streakDays == 1 ? '' : 's'} Streak!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Your progress this week',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          'Level ${state.level}: Fill your heart to level up!',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
        ),
      ],
    );
  }

  void _showBreathingExercise(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const BreathingExerciseDialog(),
    );
  }

  Widget _buildDailyOverview(BuildContext context, MentalHealthState state) {
    return Consumer(builder: (context, ref, _) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.today_rounded,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  "Today's Overview",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Completion Status
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: AppTheme.successColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${state.completedTaskCount}/${state.totalTaskCount} Tasks',
                        style: TextStyle(
                          color: AppTheme.successColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.xpColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: AppTheme.xpColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '+${state.xpPoints} XP Today',
                        style: TextStyle(
                          color: AppTheme.xpColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
            ),
            const SizedBox(height: 8),
            // Breathing Exercise
            _buildQuickActionCard(
              context,
              icon: Icons.self_improvement_rounded,
              color: AppTheme.energyColor,
              title: 'Quick Meditation',
              subtitle: '2-minute breathing exercise',
              onTap: () => _showBreathingExercise(context, ref),
            ),
            const SizedBox(height: 8),
            // Gratitude Note
            _buildQuickActionCard(
              context,
              icon: Icons.favorite_rounded,
              color: AppTheme.primaryColor,
              title: 'Gratitude Note',
              subtitle: '1-minute reflection',
              onTap: () => _showGratitudeDialog(context, ref),
            ),
            const SizedBox(height: 8),
            // Physical Movement
            _buildQuickActionCard(
              context,
              icon: Icons.directions_run_rounded,
              color: AppTheme.accentColor,
              title: 'Quick Movement',
              subtitle: '30-second stretch',
              onTap: () => _showMovementExercise(context, ref),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              backgroundColor: color.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            child: Text(
              'Start',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showGratitudeDialog(BuildContext context, WidgetRef ref) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              Icons.favorite_rounded,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 8),
            const Text('Daily Gratitude'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What are you grateful for today?',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Write your gratitude note...',
                hintStyle: TextStyle(
                    color: AppTheme.textSecondaryColor.withOpacity(0.5)),
                filled: true,
                fillColor: AppTheme.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondaryColor),
            ),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                ref.read(gameStateProvider.notifier).completeTask('gratitude');
                Navigator.pop(context);
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              'Save',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showMovementExercise(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const MovementExerciseDialog(),
    );
  }

  Widget _buildMoodGrid(
      BuildContext context, WidgetRef ref, MentalHealthState gameState) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How do you feel today?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMoodOption('😊', 'Good', AppTheme.successColor),
                _buildMoodOption('😄', 'Joyful', AppTheme.primaryColor),
                _buildMoodOption('😢', 'Sad', AppTheme.warningColor),
                _buildMoodOption('😴', 'Bored', AppTheme.accentColor),
                _buildMoodOption('😠', 'Angry', AppTheme.errorColor),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // XP Progress
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: AppTheme.xpColor,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${gameState.xpPoints} XP',
                          style: TextStyle(
                            color: AppTheme.xpColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Level ${gameState.level}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: gameState.levelProgress,
                    backgroundColor: AppTheme.cardColor,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.xpColor),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${gameState.nextLevelXP - gameState.xpPoints} XP until next level',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodOption(String emoji, String label, Color color) {
    return Consumer(builder: (context, ref, _) {
      final gameStateNotifier = ref.read(gameStateProvider.notifier);
      final canRecord = gameStateNotifier.canRecordMood();
      final timeUntilNext = gameStateNotifier.getTimeUntilNextMood();
      final xpReward = ref.read(gameStateProvider).calculateMoodXP();

      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: GestureDetector(
                  onTap: canRecord
                      ? () {
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Text(emoji),
                                  const SizedBox(width: 8),
                                  Text('Mood recorded: $label'),
                                  const Spacer(),
                                  const Icon(Icons.check_circle,
                                      color: Colors.white),
                                ],
                              ),
                              backgroundColor: color.withOpacity(0.8),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          ref
                              .read(gameStateProvider.notifier)
                              .updateMood(label, xpReward);
                          ref
                              .read(gameStateProvider.notifier)
                              .addProgress(0.05);
                          ref
                              .read(gameStateProvider.notifier)
                              .completeTask('mood_check');
                        }
                      : () {
                          if (timeUntilNext != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Next mood check-in available in ${timeUntilNext.inMinutes} minutes',
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                  child: Opacity(
                    opacity: canRecord ? 1.0 : 0.5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: color.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          label,
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: AppTheme.xpColor,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '+$xpReward XP',
                              style: TextStyle(
                                color: AppTheme.xpColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
