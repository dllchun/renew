import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/models/mental_health_balance.dart';

class ActivityList extends StatelessWidget {
  final List<BalanceActivity> activities;

  const ActivityList({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activities',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppTheme.mediumSpacing),
          if (activities.isEmpty)
            Center(
              child: Text(
                'No activities yet',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final activity = activities[index];
                return _ActivityItem(activity: activity);
              },
            ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final BalanceActivity activity;

  const _ActivityItem({
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat.jm();
    final isEarning = activity.type.isEarning;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.smallPadding),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isEarning
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : theme.colorScheme.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
            ),
            child: Icon(
              isEarning ? Icons.add_circle : Icons.remove_circle,
              color: isEarning
                  ? theme.colorScheme.primary
                  : theme.colorScheme.error,
            ),
          ),
          const SizedBox(width: AppTheme.mediumSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.name,
                  style: theme.textTheme.bodyLarge,
                ),
                Text(
                  timeFormat.format(activity.timestamp),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isEarning ? '+' : ''}${activity.points}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: isEarning
                  ? theme.colorScheme.primary
                  : theme.colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
} 