import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/features/dashboard/domain/models/mental_health_balance.dart';
import 'package:my_flutter_app/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:my_flutter_app/features/dashboard/presentation/widgets/activity_list_item.dart';
import 'package:my_flutter_app/features/dashboard/presentation/widgets/balance_chart.dart';
import 'package:my_flutter_app/features/dashboard/presentation/widgets/balance_card.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceState = ref.watch(dashboardProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(dashboardProvider.notifier).refreshBalance(),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Mental Health Balance',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  centerTitle: true,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: balanceState.when(
                    data: (balance) => _buildDashboardContent(context, balance),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                      child: Text('Error: $error'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(
      BuildContext context, MentalHealthBalance balance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BalanceCard(balance: balance),
        const SizedBox(height: 24),
        Text(
          'Weekly Progress',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        BalanceChart(weeklyPoints: balance.weeklyPoints),
        const SizedBox(height: 24),
        Text(
          'Recent Activities',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        ...balance.recentActivities.map(
          (activity) => ActivityListItem(activity: activity),
        ),
      ],
    );
  }
}
