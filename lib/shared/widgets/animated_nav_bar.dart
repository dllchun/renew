import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/shared/models/menu_item.dart';

class AnimatedNavBar extends StatelessWidget {
  final List<MenuItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const AnimatedNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: AppTheme.surfaceColor,
      selectedIndex: selectedIndex,
      onDestinationSelected: onItemSelected,
      destinations: [
        NavigationDestination(
          icon: Icon(items[0].icon),
          selectedIcon: Icon(items[0].activeIcon),
          label: items[0].label,
        ),
        NavigationDestination(
          icon: Icon(items[1].icon),
          selectedIcon: Icon(items[1].activeIcon),
          label: items[1].label,
        ),
      ],
    );
  }
}
