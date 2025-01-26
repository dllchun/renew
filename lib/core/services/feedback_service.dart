import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class FeedbackService {
  static final FeedbackService _instance = FeedbackService._internal();
  factory FeedbackService() => _instance;
  FeedbackService._internal();

  final Map<String, AudioPlayer> _soundPlayers = {};
  bool _isSoundEnabled = true;
  bool _isHapticEnabled = true;

  final Map<String, String> _soundPresets = {
    'success': 'assets/sounds/success.mp3',
    'unlock': 'assets/sounds/unlock.mp3',
    'level_up': 'assets/sounds/level_up.mp3',
    'tap': 'assets/sounds/tap.mp3',
    'achievement': 'assets/sounds/achievement.mp3',
  };

  Future<void> initialize() async {
    if (_isSoundEnabled) {
      for (final entry in _soundPresets.entries) {
        final player = AudioPlayer();
        try {
          await player.setAsset(entry.value);
          _soundPlayers[entry.key] = player;
        } catch (e) {
          print('Failed to load sound asset: ${entry.value}');
          // Disable sound if assets can't be loaded
          _isSoundEnabled = false;
          break;
        }
      }
    }
  }

  Future<void> _playSound(String soundKey) async {
    if (_isSoundEnabled && _soundPlayers.containsKey(soundKey)) {
      try {
        final player = _soundPlayers[soundKey]!;
        await player.seek(Duration.zero);
        await player.play();
      } catch (e) {
        print('Failed to play sound: $soundKey');
      }
    }
  }

  Future<void> _hapticFeedback(HapticFeedbackType type) async {
    if (!_isHapticEnabled) return;

    switch (type) {
      case HapticFeedbackType.light:
        await HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.medium:
        await HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.heavy:
        await HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.success:
        await HapticFeedback.mediumImpact();
        break;
    }
  }

  Future<void> successFeedback() async {
    await _playSound('success');
    await _hapticFeedback(HapticFeedbackType.success);
  }

  Future<void> unlockFeedback() async {
    await _playSound('unlock');
    await _hapticFeedback(HapticFeedbackType.heavy);
  }

  Future<void> levelUpFeedback() async {
    await _playSound('level_up');
    await _hapticFeedback(HapticFeedbackType.heavy);
  }

  Future<void> tapFeedback() async {
    await _playSound('tap');
    await _hapticFeedback(HapticFeedbackType.light);
  }

  Future<void> achievementFeedback() async {
    await _playSound('achievement');
    await _hapticFeedback(HapticFeedbackType.medium);
  }

  void setSoundEnabled(bool enabled) {
    _isSoundEnabled = enabled;
  }

  void setHapticEnabled(bool enabled) {
    _isHapticEnabled = enabled;
  }

  Future<void> dispose() async {
    for (final player in _soundPlayers.values) {
      await player.dispose();
    }
    _soundPlayers.clear();
  }
}

enum HapticFeedbackType {
  light,
  medium,
  heavy,
  success,
}
