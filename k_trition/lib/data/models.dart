DateTime localDay(DateTime date) {
  final d = date.toLocal();
  return DateTime(d.year, d.month, d.day);
}

DateTime nextDay(DateTime date) {
  final d = localDay(date);
  return DateTime(d.year, d.month, d.day + 1);
}

String dayKey(DateTime date) {
  final d = localDay(date);
  return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

void positive(double n, String label) {
  if (!n.isFinite || n <= 0 || n >= 1000000000) {
    throw ArgumentError(
      '$label must be positive, finite and less than one billion',
    );
  }
}

class MealPortion {
  MealPortion({required this.foodId, required this.grams}) {
    positive(grams, 'Grams');
  }
  final int foodId;
  final double grams;
}

class NutritionTotals {
  const NutritionTotals({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
  final double calories, protein, carbs, fat;
}

class DailyProgress {
  const DailyProgress({
    required this.day,
    required this.nutrition,
    required this.waterOunces,
    required this.calorieGoal,
    required this.waterGoalOunces,
  });
  final DateTime day;
  final NutritionTotals nutrition;
  final double waterOunces;

  /// No invented targets: null until the user sets an effective goal.
  final double? calorieGoal, waterGoalOunces;
  double? get calorieFraction =>
      calorieGoal == null ? null : nutrition.calories / calorieGoal!;
  double? get waterFraction =>
      waterGoalOunces == null ? null : waterOunces / waterGoalOunces!;
}
