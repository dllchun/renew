import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/core/providers/feedback_provider.dart';
import 'package:my_flutter_app/shared/models/menu_item.dart';
import 'package:my_flutter_app/shared/widgets/animated_nav_bar.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
