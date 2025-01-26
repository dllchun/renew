import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/core/providers/feedback_provider.dart';
import 'package:my_flutter_app/features/game/presentation/providers/growth_garden_provider.dart';

class GrowthGardenScreen extends ConsumerWidget {
  const GrowthGardenScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gardenState = ref.watch(growthGardenProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: const Text('Growth Garden'),
              backgroundColor: AppTheme.surfaceColor,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildPlantCard(
                    context,
                    ref,
                    gardenState.plants[index],
                  ),
                  childCount: gardenState.plants.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantCard(BuildContext context, WidgetRef ref, Plant plant) {
    return GestureDetector(
      onTap: () {
        if (plant.isUnlocked) {
          ref.read(feedbackProvider).tapFeedback();
          _showPlantDetails(context, ref, plant);
        } else {
          ref.read(feedbackProvider).tapFeedback();
          _showUnlockRequirements(context, plant);
        }
      },
      child: Card(
        color: AppTheme.cardColor,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                plant.isUnlocked ? Icons.local_florist : Icons.lock,
                size: 48,
                color: plant.isUnlocked
                    ? AppTheme.primaryColor
                    : AppTheme.textSecondaryColor,
              ),
              const SizedBox(height: 12),
              Text(
                plant.isUnlocked ? plant.name : 'Locked',
                style: TextStyle(
                  color: plant.isUnlocked
                      ? AppTheme.textPrimaryColor
                      : AppTheme.textSecondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (plant.isUnlocked) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: plant.growth,
                  backgroundColor: AppTheme.backgroundColor,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(plant.growth * 100).toInt()}% Growth',
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showPlantDetails(BuildContext context, WidgetRef ref, Plant plant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(plant.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_florist, size: 64),
            const SizedBox(height: 16),
            Text(
              'Growth Progress: ${(plant.growth * 100).toInt()}%',
              style: TextStyle(color: AppTheme.textPrimaryColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete daily tasks to help your plant grow!',
              style: TextStyle(color: AppTheme.textSecondaryColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(growthGardenProvider.notifier).waterPlant(plant.id);
              ref.read(feedbackProvider).successFeedback();
              Navigator.pop(context);
            },
            child: const Text('Water Plant'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showUnlockRequirements(BuildContext context, Plant plant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Locked Plant Slot'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock, size: 64),
            const SizedBox(height: 16),
            Text(
              'Complete more daily tasks to unlock this plant slot!',
              style: TextStyle(color: AppTheme.textPrimaryColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Required: Level ${plant.requiredLevel}',
              style: TextStyle(color: AppTheme.textSecondaryColor),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
