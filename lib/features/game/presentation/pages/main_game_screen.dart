import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/features/game/domain/models/mental_health_state.dart';
import 'package:my_flutter_app/features/game/presentation/providers/game_state_provider.dart';
import 'package:my_flutter_app/features/game/presentation/widgets/heart_visualization.dart';

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
                      const SizedBox(height: 40),
                      _buildMoodSelector(context),
                      const SizedBox(height: 24),
                      _buildStreakAndXP(context, gameState),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good afternoon,',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              Text(
                'Summer Yuri',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // TODO: Show menu with Stats and Settings
            },
            icon: const Icon(Icons.more_horiz_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildHeartProgress(BuildContext context, MentalHealthState state) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            // TODO: Show mood logging dialog
          },
          child: HeartVisualization(
            state: state,
            size: 280,
          ),
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

  Widget _buildMoodSelector(BuildContext context) {
    return Column(
      children: [
        Text(
          'How do you feel today?',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildMoodOption('😊', 'Good', AppTheme.successColor),
              _buildMoodOption('😄', 'Joyful', AppTheme.primaryColor),
              _buildMoodOption('😢', 'Sad', AppTheme.secondaryColor),
              _buildMoodOption('😴', 'Bored', AppTheme.accentColor),
              _buildMoodOption('😠', 'Angry', AppTheme.errorColor),
            ].map((widget) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: widget,
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStreakAndXP(BuildContext context, MentalHealthState state) {
    return Column(
      children: [
        // Streak Counter
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.2),
                duration: const Duration(seconds: 1),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Icon(
                      Icons.local_fire_department_rounded,
                      color: AppTheme.primaryColor,
                      size: 24,
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              Text(
                '${state.streakDays} Day Streak!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // XP Progress
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
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
                        '${state.xpPoints} XP',
                        style: TextStyle(
                          color: AppTheme.xpColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Level ${state.level}',
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
                  value: state.levelProgress,
                  backgroundColor: AppTheme.cardColor,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.xpColor),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${state.nextLevelXP - state.xpPoints} XP until next level',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoodOption(String emoji, String label, Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              // TODO: Handle mood selection
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: color.withOpacity(0.2),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '+10 XP',
                  style: TextStyle(
                    color: AppTheme.xpColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 