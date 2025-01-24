import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../theme/app_theme.dart';
import 'animated_menu_item.dart';

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
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.mediumPadding,
            vertical: AppTheme.smallPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Expanded(
                child: AnimatedMenuItem(
                  label: item.label,
                  icon: item.icon,
                  activeIcon: item.activeIcon,
                  isSelected: selectedIndex == index,
                  color: item.color,
                  onTap: () => onItemSelected(index),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
} 