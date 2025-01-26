import 'package:flutter_riverpod/flutter_riverpod.dart';

class Plant {
  final int id;
  final String name;
  final double growth;
  final bool isUnlocked;
  final int requiredLevel;

  const Plant({
    required this.id,
    required this.name,
    required this.growth,
    required this.isUnlocked,
    required this.requiredLevel,
  });

  Plant copyWith({
    String? name,
    double? growth,
    bool? isUnlocked,
    int? requiredLevel,
  }) {
    return Plant(
      id: id,
      name: name ?? this.name,
      growth: growth ?? this.growth,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      requiredLevel: requiredLevel ?? this.requiredLevel,
    );
  }
}

class GrowthGardenState {
  final List<Plant> plants;

  const GrowthGardenState({required this.plants});

  GrowthGardenState copyWith({List<Plant>? plants}) {
    return GrowthGardenState(plants: plants ?? this.plants);
  }
}

class GrowthGardenNotifier extends StateNotifier<GrowthGardenState> {
  GrowthGardenNotifier() : super(GrowthGardenState(plants: _initialPlants));

  static final List<Plant> _initialPlants = List.generate(
    6,
    (index) => Plant(
      id: index,
      name: 'Plant ${index + 1}',
      growth: index < 2 ? 0.3 : 0.0,
      isUnlocked: index < 2,
      requiredLevel: index * 2 + 5,
    ),
  );

  void waterPlant(int plantId) {
    final updatedPlants = state.plants.map((plant) {
      if (plant.id == plantId && plant.isUnlocked) {
        return plant.copyWith(
          growth: (plant.growth + 0.1).clamp(0.0, 1.0),
        );
      }
      return plant;
    }).toList();

    state = state.copyWith(plants: updatedPlants);
  }

  void unlockPlant(int plantId) {
    final updatedPlants = state.plants.map((plant) {
      if (plant.id == plantId && !plant.isUnlocked) {
        return plant.copyWith(isUnlocked: true);
      }
      return plant;
    }).toList();

    state = state.copyWith(plants: updatedPlants);
  }

  void updatePlantGrowth(int plantId, double growth) {
    final updatedPlants = state.plants.map((plant) {
      if (plant.id == plantId && plant.isUnlocked) {
        return plant.copyWith(growth: growth.clamp(0.0, 1.0));
      }
      return plant;
    }).toList();

    state = state.copyWith(plants: updatedPlants);
  }
}

final growthGardenProvider =
    StateNotifierProvider<GrowthGardenNotifier, GrowthGardenState>((ref) {
  return GrowthGardenNotifier();
});
