import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/features/game/presentation/pages/main_game_screen.dart';
import 'package:my_flutter_app/features/game/presentation/pages/journey_screen.dart';
import 'package:my_flutter_app/features/game/presentation/screens/growth_garden_screen.dart';
import 'package:my_flutter_app/core/providers/feedback_provider.dart';
import 'package:my_flutter_app/shared/models/menu_item.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await container.read(feedbackProvider).initialize();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Mental Health Game',
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.8),
                    AppTheme.accentColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Mental Health Game',
                      style: TextStyle(
                        color: AppTheme.textPrimaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your Journey to Wellness',
                      style: TextStyle(
                        color: AppTheme.textPrimaryColor.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...drawerMenuItems
                .map((item) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        leading: Icon(item.icon, color: item.color, size: 24),
                        title: Text(
                          item.label,
                          style: TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          ref.read(feedbackProvider).tapFeedback();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => item.page),
                          );
                        },
                        tileColor: AppTheme.cardColor.withOpacity(0.3),
                        selectedTileColor:
                            AppTheme.primaryColor.withOpacity(0.1),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
      body: menuItems[_selectedIndex].page,
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppTheme.surfaceColor,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          ref.read(feedbackProvider).tapFeedback();
        },
        destinations: menuItems
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.activeIcon),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

final List<MenuItem> menuItems = [
  MenuItem(
    icon: Icons.favorite_outline,
    activeIcon: Icons.favorite_rounded,
    label: 'Today',
    color: AppTheme.primaryColor,
    page: const MainGameScreen(),
  ),
  MenuItem(
    icon: Icons.psychology_outlined,
    activeIcon: Icons.psychology_rounded,
    label: 'Journey',
    color: AppTheme.primaryColor,
    page: const JourneyScreen(),
  ),
];

final List<MenuItem> drawerMenuItems = [
  MenuItem(
    label: 'Growth Garden',
    icon: Icons.local_florist_outlined,
    activeIcon: Icons.local_florist_rounded,
    color: AppTheme.primaryColor,
    page: const GrowthGardenScreen(),
  ),
  MenuItem(
    label: 'Achievements',
    icon: Icons.emoji_events_outlined,
    activeIcon: Icons.emoji_events_rounded,
    color: AppTheme.accentColor,
    page: const Placeholder(), // TODO: Replace with AchievementsPage
  ),
  MenuItem(
    label: 'Statistics',
    icon: Icons.bar_chart_outlined,
    activeIcon: Icons.bar_chart_rounded,
    color: AppTheme.energyColor,
    page: const Placeholder(), // TODO: Replace with StatsPage
  ),
  MenuItem(
    label: 'Settings',
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings_rounded,
    color: AppTheme.textSecondaryColor,
    page: const Placeholder(), // TODO: Replace with SettingsPage
  ),
];
