import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/features/game/presentation/pages/main_game_screen.dart';
import 'package:my_flutter_app/features/game/presentation/pages/journey_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const MainGameScreen(),
    const JourneyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Mental Health Game',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your Journey to Wellness',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: AppTheme.textSecondaryColor),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to settings
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.help_outline, color: AppTheme.textSecondaryColor),
              title: const Text('Help'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to help
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.info_outline, color: AppTheme.textSecondaryColor),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to about
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppTheme.surfaceColor,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.favorite_outline,
                color: AppTheme.textSecondaryColor),
            selectedIcon:
                Icon(Icons.favorite_rounded, color: AppTheme.primaryColor),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_outlined,
                color: AppTheme.textSecondaryColor),
            selectedIcon:
                Icon(Icons.psychology_rounded, color: AppTheme.energyColor),
            label: 'Journey',
          ),
        ],
      ),
    );
  }
}
