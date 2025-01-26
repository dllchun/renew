import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/features/game/presentation/providers/game_state_provider.dart';
import 'dart:async';

class MovementExerciseDialog extends StatefulWidget {
  const MovementExerciseDialog({super.key});

  @override
  State<MovementExerciseDialog> createState() => _MovementExerciseDialogState();
}

class _MovementExerciseDialogState extends State<MovementExerciseDialog> {
  late Timer _timer;
  int _secondsRemaining = 30; // 30 seconds

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
      ref.read(gameStateProvider.notifier).completeTask('movement');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.directions_run_rounded, color: AppTheme.accentColor),
              const SizedBox(width: 8),
              const Text('Movement exercise completed! +10 XP'),
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
    return AlertDialog(
      backgroundColor: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${_secondsRemaining.toString().padLeft(2, '0')} seconds',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Text(
            'Keep moving!',
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
