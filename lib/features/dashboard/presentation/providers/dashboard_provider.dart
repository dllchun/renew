import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/mental_health_balance.dart';

final dashboardProvider = StateNotifierProvider<DashboardNotifier, AsyncValue<MentalHealthBalance>>((ref) {
  return DashboardNotifier();
});

class DashboardNotifier extends StateNotifier<AsyncValue<MentalHealthBalance>> {
  DashboardNotifier() : super(const AsyncValue.loading()) {
    _initializeData();
  }

  Future<void> _initializeData() async {
    state = AsyncValue.data(
      MentalHealthBalance(
        points: 120,
        recentActivities: [
          BalanceActivity(
            name: '8 hours of sleep',
            points: 10,
            timestamp: DateTime.now().subtract(const Duration(hours: 8)),
            type: ActivityType.earning,
          ),
          BalanceActivity(
            name: 'Morning exercise',
            points: 15,
            timestamp: DateTime.now().subtract(const Duration(hours: 4)),
            type: ActivityType.earning,
          ),
          BalanceActivity(
            name: 'Skipped lunch',
            points: -5,
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            type: ActivityType.spending,
          ),
        ],
        weeklyPoints: List.generate(
          7,
          (index) => BalancePoint(
            date: DateTime.now().subtract(Duration(days: 6 - index)),
            points: 100 + (index * 5), // Dummy increasing trend
          ),
        ),
      ),
    );
  }

  Future<void> refreshBalance() async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(seconds: 1));
    _initializeData();
  }
} 