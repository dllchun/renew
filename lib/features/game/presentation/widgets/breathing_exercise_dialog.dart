import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/features/game/presentation/providers/game_state_provider.dart';
import 'dart:async';

class BreathingExerciseDialog extends StatefulWidget {
  const BreathingExerciseDialog({super.key});

  @override
  State<BreathingExerciseDialog> createState() =>
      _BreathingExerciseDialogState();
}

class _BreathingExerciseDialogState extends State<BreathingExerciseDialog> {
  late Timer _timer;
  int _secondsRemaining = 120; // 2 minutes
  String _phase = 'inhale';
  int _currentCycle = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          // Update breathing phase every 4 seconds
          if (_secondsRemaining % 4 == 0) {
            _phase = _phase == 'inhale' ? 'exhale' : 'inhale';
            if (_phase == 'inhale') {
              _currentCycle++;
              HapticFeedback.mediumImpact();
            }
          }
        } else {
          _timer.cancel();
          _completeExercise();
        }
      });
    });
  }

  void _completeExercise() {
    Navigator.of(context).pop();
    final ref = context.findRootAncestorStateOfType<ConsumerState>()?.ref;
    if (ref != null) {
      ref.read(gameStateProvider.notifier).completeTask('meditation');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: AppTheme.successColor),
              const SizedBox(width: 8),
              const Text('Breathing exercise completed! +20 XP'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;

    return AlertDialog(
      backgroundColor: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          TweenAnimationBuilder<double>(
            tween: Tween(
              begin: _phase == 'inhale' ? 0.5 : 1.0,
              end: _phase == 'inhale' ? 1.0 : 0.5,
            ),
            duration: const Duration(seconds: 4),
            builder: (context, value, child) {
              return Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.energyColor.withOpacity(0.2),
                ),
                child: Transform.scale(
                  scale: value,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.energyColor,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            _phase == 'inhale' ? 'Breathe In' : 'Breathe Out',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            'Cycle $_currentCycle/15',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _timer.cancel();
            Navigator.of(context).pop();
          },
          child: Text(
            'End Early',
            style: TextStyle(color: AppTheme.errorColor),
          ),
        ),
      ],
    );
  }
}
