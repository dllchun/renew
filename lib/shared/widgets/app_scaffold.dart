import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_item.dart';
import 'animated_nav_bar.dart';

final selectedPageIndexProvider = StateProvider<int>((ref) => 0);

class AppScaffold extends ConsumerWidget {
  final List<MenuItem> items;

  const AppScaffold({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedPageIndexProvider);

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: items[selectedIndex].page,
      ),
      bottomNavigationBar: AnimatedNavBar(
        items: items,
        selectedIndex: selectedIndex,
        onItemSelected: (index) {
          ref.read(selectedPageIndexProvider.notifier).state = index;
        },
      ),
    );
  }
} 