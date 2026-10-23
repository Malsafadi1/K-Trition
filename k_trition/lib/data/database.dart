import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
part 'database.g.dart';

/// One database per app. Call initialize() before giving the repository to UI.
@DriftDatabase(include: {'schema.drift'})
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(
        executor ??
            driftDatabase(
              name: 'k_trition_local',
              native: const DriftNativeOptions(
                databaseDirectory: getApplicationSupportDirectory,
              ),
              web: DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.js'),
              ),
            ),
      );
  @override
  int get schemaVersion => 1;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (_) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
  Future<void>? _initializing;
  Future<void> initialize() => _initializing ??= _seed();
  Future<void> _seed() async {
    final catalog = jsonDecode(
      await rootBundle.loadString('assets/data/foods.json'),
    ) as Map<String, dynamic>;
    final version = catalog['catalog_version'] as int;
    final current = await customSelect(
      'SELECT version FROM catalog_state LIMIT 1',
    ).getSingleOrNull();
    if (current != null && current.read<int>('version') >= version) return;
    await transaction(() async {
      // Archive choices instead of deleting rows referenced by historical meals.
      await customStatement('UPDATE foods SET is_listed = 0');
      await batch((b) {
        for (final f in catalog['foods'] as List) {
          b.customStatement(
            'INSERT INTO foods VALUES (?,?,?,?,?,?,?,?,1,?) ON CONFLICT(fdc_id) DO UPDATE SET name=excluded.name,category=excluded.category,source_name=excluded.source_name,kcal_per_g=excluded.kcal_per_g,protein_per_g=excluded.protein_per_g,carbs_per_g=excluded.carbs_per_g,fat_per_g=excluded.fat_per_g,is_listed=1,is_common=excluded.is_common',
            [
              f['fdc_id'],
              f['name'],
              f['category'],
              f['source_name'],
              f['kcal_per_g'],
              f['protein_per_g'],
              f['carbs_per_g'],
              f['fat_per_g'],
              f['is_common'] == true ? 1 : 0,
            ],
          );
        }
      });
      await customStatement('DELETE FROM catalog_state');
      await customStatement('INSERT INTO catalog_state VALUES (?)', [version]);
    });
  }
}
