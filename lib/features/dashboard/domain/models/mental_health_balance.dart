class MentalHealthBalance {
  final int points;
  final List<BalanceActivity> recentActivities;
  final List<BalancePoint> weeklyPoints;

  const MentalHealthBalance({
    required this.points,
    required this.recentActivities,
    required this.weeklyPoints,
  });
}

class BalanceActivity {
  final String name;
  final int points;
  final DateTime timestamp;
  final ActivityType type;

  const BalanceActivity({
    required this.name,
    required this.points,
    required this.timestamp,
    required this.type,
  });
}

class BalancePoint {
  final DateTime date;
  final int points;

  const BalancePoint({
    required this.date,
    required this.points,
  });
}

enum ActivityType {
  earning,
  spending;

  bool get isEarning => this == ActivityType.earning;
} 