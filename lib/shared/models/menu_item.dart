import 'package:flutter/material.dart';

class MenuItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Color color;
  final Widget page;

  const MenuItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.color,
    required this.page,
  });
}
