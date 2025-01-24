import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/features/dashboard/domain/models/mental_health_balance.dart';

class ActivityListItem extends StatelessWidget {
  final BalanceActivity activity;

  const ActivityListItem({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getActivityColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getActivityIcon(),
              color: _getActivityColor(),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getTimeAgo(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _getPointsText(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _getActivityColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getActivityColor() {
    return activity.type == ActivityType.earning
        ? AppTheme.successColor
        : AppTheme.errorColor;
  }

  IconData _getActivityIcon() {
    return activity.type == ActivityType.earning
        ? Icons.add_circle_outline_rounded
        : Icons.remove_circle_outline_rounded;
  }

  String _getPointsText() {
    return activity.type == ActivityType.earning
        ? '+${activity.points}'
        : '${activity.points}';
  }

  String _getTimeAgo() {
    final difference = DateTime.now().difference(activity.timestamp);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
} 