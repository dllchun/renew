import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';

class SideMenu extends ConsumerWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: AppTheme.backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 16),
                  _buildMenuSection(
                    title: 'Growth Garden',
                    icon: Icons.local_florist,
                    color: AppTheme.successColor,
                    children: [
                      _buildMenuItem(
                        'My Garden',
                        Icons.yard_outlined,
                        onTap: () {
                          // TODO: Navigate to garden view
                        },
                      ),
                      _buildMenuItem(
                        'Plant Collection',
                        Icons.grass_outlined,
                        onTap: () {
                          // TODO: Show plant collection
                        },
                      ),
                    ],
                  ),
                  _buildMenuSection(
                    title: 'Achievements',
                    icon: Icons.emoji_events,
                    color: AppTheme.xpColor,
                    children: [
                      _buildMenuItem(
                        'Progress',
                        Icons.trending_up,
                        onTap: () {
                          // TODO: Show achievements progress
                        },
                      ),
                      _buildMenuItem(
                        'Rewards',
                        Icons.card_giftcard,
                        onTap: () {
                          // TODO: Show rewards
                        },
                      ),
                      _buildMenuItem(
                        'Collectibles',
                        Icons.stars,
                        onTap: () {
                          // TODO: Show collectibles
                        },
                      ),
                    ],
                  ),
                  _buildMenuSection(
                    title: 'Community',
                    icon: Icons.people,
                    color: AppTheme.energyColor,
                    children: [
                      _buildMenuItem(
                        'Challenges',
                        Icons.flag,
                        onTap: () {
                          // TODO: Show community challenges
                        },
                      ),
                      _buildMenuItem(
                        'Support Circle',
                        Icons.favorite_border,
                        onTap: () {
                          // TODO: Show support circle
                        },
                      ),
                    ],
                  ),
                  _buildMenuSection(
                    title: 'Statistics',
                    icon: Icons.insights,
                    color: AppTheme.primaryColor,
                    children: [
                      _buildMenuItem(
                        'Mood Patterns',
                        Icons.show_chart,
                        onTap: () {
                          // TODO: Show mood patterns
                        },
                      ),
                      _buildMenuItem(
                        'Activity Impact',
                        Icons.assessment,
                        onTap: () {
                          // TODO: Show activity impact
                        },
                      ),
                      _buildMenuItem(
                        'Weekly Report',
                        Icons.calendar_today,
                        onTap: () {
                          // TODO: Show weekly report
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  _buildMenuItem(
                    'Settings',
                    Icons.settings,
                    onTap: () {
                      // TODO: Navigate to settings
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.primaryColor.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            child: Icon(
              Icons.person_outline,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Journey',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Level 1 Explorer',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMenuItem(
    String title,
    IconData icon, {
    VoidCallback? onTap,
    bool isLocked = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(
        icon,
        color:
            isLocked ? AppTheme.textSecondaryColor : AppTheme.textPrimaryColor,
        size: 20,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLocked
              ? AppTheme.textSecondaryColor
              : AppTheme.textPrimaryColor,
        ),
      ),
      trailing: isLocked
          ? Icon(
              Icons.lock,
              color: AppTheme.textSecondaryColor,
              size: 16,
            )
          : null,
      onTap: isLocked ? null : onTap,
    );
  }
}
