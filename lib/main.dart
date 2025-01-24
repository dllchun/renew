import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/features/game/presentation/pages/main_game_screen.dart';
import 'package:my_flutter_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:my_flutter_app/shared/models/menu_item.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Health Quest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.gameTheme,
      home: const OnboardingPage(),
    );
  }
}

final List<MenuItem> navigationItems = [
  MenuItem(
    label: 'Home',
    icon: Icons.favorite_outline,
    activeIcon: Icons.favorite_rounded,
    page: const MainGameScreen(),
  ),
  MenuItem(
    label: 'Quests',
    icon: Icons.stars_outlined,
    activeIcon: Icons.stars_rounded,
    color: AppTheme.questColor,
    page: const Placeholder(), // TODO: Replace with QuestPage
  ),
  MenuItem(
    label: 'Check-in',
    icon: Icons.psychology_outlined,
    activeIcon: Icons.psychology_rounded,
    color: AppTheme.energyColor,
    page: const Placeholder(), // TODO: Replace with DailyCheckInPage
  ),
  MenuItem(
    label: 'Trophies',
    icon: Icons.emoji_events_outlined,
    activeIcon: Icons.emoji_events_rounded,
    color: AppTheme.accentColor,
    page: const Placeholder(), // TODO: Replace with AchievementGalleryPage
  ),
];
