// Optional browser smoke check, separate from the starter UI.
// flutter run -d chrome -t tool/database_smoke_check.dart --web-port=7358
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:k_trition/data/nutrition_repository.dart';

Future<NutritionRepository> openCheck() => NutritionRepository.open(
  executor: driftDatabase(
    name: 'ktrition_database_check',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  ),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Separate name keeps the check away from the user's actual app database.
  var repo = await openCheck();
  int? id;
  try {
    final apple = await repo.getFood(171688);
    if ((repo.calculate(apple, 150).calories - 78).abs() > 0.001) {
      throw StateError('Incorrect nutrient calculation');
    }
    final common = await repo.searchFoods(commonOnly: true, limit: 100);
    if (common.length != 44) throw StateError('Incorrect common-food import');
    id = await repo.saveWater(ounces: 8, loggedAt: DateTime(2000, 1, 1));
    await repo.close();
    repo = await openCheck();
    if (!(await repo.waterForDay(DateTime(2000, 1, 1)))
        .any((w) => w.id == id && w.ounces == 8)) {
      throw StateError('Failed water readback');
    }
    // A real write and readback through the web SQLite connection, not a mock.
    debugPrint(
      'DATABASE_CHECK_PASSED: catalog, nutrient math, local CRUD and reopen persistence',
    );
  } finally {
    if (id != null) await repo.deleteWater(id);
    await repo.close();
  }
}
