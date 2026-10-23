# Local database: UI integration guide

**Chosen backend: SQLite through Drift. No Firebase accounts, server, API keys, or cloud connection are needed.** The starter UI is unchanged; this is the data layer your teammates connect to their screens.

## Catalog scope

The committed catalog has **5,084 foods** from the provided USDA FoodData Central `FoodData_Central_csv_2026-04-30` CSV download:

- 4,744 SR Legacy foods and 340 Foundation foods.
- 44 plain-named common choices, available with `commonOnly: true`.
- Core categories: produce, meats, poultry, fish, dairy/eggs, legumes, grains/pasta, nuts/seeds, fats/oils, and herbs/spices.
- Excludes branded and survey records, baby-food, beverage/alcohol, prepared-entree, snack, sweets, fast-food and restaurant categories.
- Some source category members include preparation/other ingredients; their full USDA descriptions remain available. This is a category-filtered basic-food catalog, not a claim that every record is chemically single-ingredient.
- Original USDA IDs, descriptions, data types, publication dates and the chosen energy nutrient ID are retained in `assets/data/foods.json` and `foods_preview.csv` for review.
- 89 records missing calories or a required macro were excluded. Missing values were not guessed or converted to zero.

Amounts are normalized from USDA per-100-g values to per gram. Protein 1003, fat 1004 and carbohydrate 1005 use grams; energy uses kcal with priority 1008 → 2048 → 2047, never added together. Dietary “calories” means kcal. The importer verifies source units and rejects duplicate nutrient measurements requiring review.

The common-choice aliases use one representative USDA record each, not averages of different cuts or recipes. The full catalog retains distinct source variants and preparation details. Do not merge raw and cooked food values just to shorten names.

## Files

| File | Role |
| --- | --- |
| `lib/data/schema.drift` | Human-readable SQL tables and relationships |
| `lib/data/database.dart` | Native/web SQLite connection and versioned catalog seeding |
| `lib/data/database.g.dart` | Committed generated code; do not edit manually |
| `lib/data/nutrition_repository.dart` | Public API for UI code |
| `lib/data/models.dart` | Portions, nutrition totals, daily progress and date helpers |
| `assets/data/foods.json` | Bundled public catalog; the app imports it locally |
| `assets/data/foods_preview.csv` | Spreadsheet-friendly review export |
| `assets/data/import_report.json` | Import counts, categories and exclusions |
| `tool/food_choices.json` | Common aliases; only IDs in eligible categories are used |
| `tool/build_food_catalog.py` | Reproducible source importer; not required by teammates to run the app |
| `web/sqlite3.wasm`, `web/drift_worker.js` | Matching Drift 2.35.3 browser runtime files |

## Tables and units

| Table | Important fields |
| --- | --- |
| foods | fdc_id, name, category, source_name, kcal/protein/carbs/fat_per_g, is_listed, is_common |
| meals | id, name, meal_type, logged_at |
| meal_items | id, meal_id, food_id, food_name, grams, saved per-gram nutrients |
| water_entries | id, ounces, logged_at |
| goals | effective_date, calories, water_ounces |
| catalog_state | Imported catalog version (internal) |

Food quantities are **edible grams** matching the listed preparation. Water is stored/displayed in **US fluid ounces**, not weight ounces. Timestamps are epoch **milliseconds**; use `DateTime.fromMillisecondsSinceEpoch(value)` for display. Goals use a local `YYYY-MM-DD` effective date. Null goals mean the user has not set a target yet.

A meal can contain multiple meal items. Deleting a meal cascades to its items. Saves/edits are transactional: failure leaves the original entry intact. Food nutrition is snapshotted into each meal item; existing food snapshots are preserved during edits even if catalog nutrition later changes. Adding a new food uses its current catalog values.

## Open once, pass to screens later

```dart
import 'package:flutter/widgets.dart';
import 'package:k_trition/data/nutrition_repository.dart';

WidgetsFlutterBinding.ensureInitialized();
final repository = await NutritionRepository.open();
// Pass this ONE repository to the future screens or your app's state provider.
// Show loading/error states while opening. Close it when its owner is disposed:
// await repository.close();
```

Do not open a new database on every widget build. This code is intentionally **not called by main.dart yet**. The existing app still opens the MVP roadmap.

## Food selection and quantity previews

```dart
final common = await repository.searchFoods(commonOnly: true, limit: 50);
final matches = await repository.searchFoods(query: 'chicken', limit: 25);
final nextPage = await repository.searchFoods(query: 'chicken', limit: 25, offset: 25);
final categories = await repository.getCategories();
final fruit = await repository.searchFoods(category: 'Fruits and Fruit Juices');
final food = await repository.getFood(171688); // Apple
final preview = repository.calculate(food, 150); // 78 calories
```

Search matches substrings without case sensitivity and has stable name/ID ordering. Maximum page size is 100. Do not render the entire 5,084-item catalog at once. A future UI can start with common foods, then offer full-catalog search. `watchFoods(...)` provides a stream with the same query parameters.

## Log, edit and delete

```dart
final mealId = await repository.saveMeal(
  name: 'Lunch', mealType: 'Lunch', loggedAt: DateTime.now(),
  portions: [MealPortion(foodId: 171477, grams: 150)], // Chicken breast
);
// Multiple MealPortion entries form a multi-food meal.
await repository.saveMeal(
  id: mealId, name: 'Updated lunch', mealType: 'Lunch',
  loggedAt: DateTime.now(),
  portions: [MealPortion(foodId: 171477, grams: 200)],
);
final meals = await repository.mealsForDay(DateTime.now());
final items = await repository.getMealItems(mealId);
await repository.deleteMeal(mealId);

final waterId = await repository.saveWater(ounces: 8, loggedAt: DateTime.now());
await repository.saveWater(id: waterId, ounces: 12, loggedAt: DateTime.now());
final water = await repository.waterForDay(DateTime.now());
await repository.deleteWater(waterId);

await repository.setGoals(
  calories: 2000, waterOunces: 64, effectiveDate: DateTime.now(),
); // Example values only: users should choose their own targets.
final progress = await repository.progressForDay(DateTime.now());
final history = await repository.progressForRange(
  DateTime(2026, 10, 1), DateTime(2026, 11, 1), // end is exclusive
);
```

Pass an existing ID to edit; a missing ID throws instead of silently recreating a deleted entry. Deleting a missing ID returns zero. Supported meal types: Breakfast, Lunch, Dinner, Snack. Catch exceptions in the future UI; await successful writes before showing success, and preserve input on failure.

## Live data and dates

```dart
final stream = repository.watchDailyProgress(selectedDate);
// Future UI: use StreamBuilder<DailyProgress>(stream: stream, ...).
// progress.nutrition.calories / protein / carbs / fat
// progress.waterOunces, calorieGoal, waterGoalOunces
```

`watchMeals(day)` and `watchWater(day)` also update after changes. Streams respond to edits/deletions and goal changes; totals are derived, not stored separately. Goal history uses the last effective date on or before the requested day. A new target does not rewrite earlier days.

Daily windows run from local midnight to the next local midnight, so daylight-saving days are handled as calendar days rather than fixed 24-hour intervals. The UI must pass the same selected date to all forms and lists and recreate its streams when the date changes or midnight arrives. Historical grouping follows the device's current timezone. `progressForRange` supports up to 366 calendar days, with an exclusive end.

## Persistence and ownership

Native platforms store SQLite in the app's application-support directory. Browsers use Drift's browser-local storage. Use a stable development origin, e.g. `flutter run -d chrome --web-port=7357`; a different port/host has separate storage. Private browsing, storage restrictions, clearing browser data or uninstalling the app may remove data. Browser-specific storage behavior should also be tested on the final deployment origin.

Each device has its own logs. GitHub shares the catalog and code, **not private user databases**. There is no account/cloud sync in this version.

## Schema and catalog changes

After changing SQL, run `dart run build_runner build` and commit both SQL and regenerated Dart. Once this schema has shipped, increment `schemaVersion` and write/test a migration for any schema change. Do not delete user data to fix a schema issue.

To rebuild the catalog, run `python3 tool/build_food_catalog.py /path/to/the/USDA/download`. Increment `catalog_version` when publishing a changed catalog. Import is transactional and skips already-imported versions. Removed choices are archived (`is_listed = false`), not deleted from existing logs; nutrient snapshots remain intact.

## Verify

```sh
flutter pub get
flutter analyze
flutter test
flutter build web
```

Tests cover source-backed nutrient math, full catalog and common filtering, date boundaries, CRUD/rollback, snapshot preservation, live stream updates, and reopening a file-backed SQLite database. The web runtime files follow the [official Drift setup](https://drift.simonbinder.eu/platforms/web/) and must be updated with Drift.
