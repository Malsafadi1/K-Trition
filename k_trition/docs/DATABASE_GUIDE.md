# Local database guide

**Storage:** local SQLite through Drift. No Firebase account, server, API key, or cloud connection is needed.

The dashboard uses this database for food search, nutrition calculations, meal and water logs, goals, and history. Data stays on the device.

## Catalog scope

The active catalog contains **300 everyday choices**: 56 Proteins, 108 Produce, 39 Grains & Carbs, 58 Dairy & Fats, and 39 Common Mixed/Prepared Items (including drinks and seasonings). `commonOnly: true` selects a smaller, 42-food shortlist.

There is one simple listing per everyday food rather than cultivars, grades and trimming variants. Meaningful differences such as lean/regular ground beef and whole/skim milk remain. Each food uses one selected USDA SR Legacy/Foundation baseline; it is not an average or a guarantee about every brand or recipe. Names are simplified, and the original description remains in `source_name`.

The 299 exact USDA baselines are maintained in `tool/core_food_baselines.json`. The 300th item is a transparent whey shake recipe: 30 g powder + 240 g water, local ID **900000001** (not a USDA ID). Selecting it defaults to 270 g. Nutrition equals the powder contribution.

Nutrients are normalized from per 100 g to per gram. Protein 1003, fat 1004 and carbohydrate 1005 use grams; energy uses kcal with priority 1008 → 2048 → 2047, never added together. Missing nutrients fail import rather than becoming zero. Household portion weights are not guessed. Match edible grams to the baseline preparation shown by the app.

See [catalog maintenance](../tool/FOOD_CLEANUP.md) for rebuilding and source extraction.

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
| `assets/data/catalog_report.json` | Current counts and category distribution |
| `tool/simple_food_choices.json` | Simple names, categories, and explicit baseline IDs |
| `tool/core_food_baselines.json` | 299 source-backed baselines; not bundled in the app |
| `tool/clean_food_catalog.py` | Builds the active JSON, CSV and report |
| `tool/import_core_baselines.py` | Optional re-extraction from the official USDA CSV download |
| `web/sqlite3.wasm`, `web/drift_worker.js` | Matching Drift 2.35.3 browser runtime files |

## Tables and units

| Table | Important fields |
| --- | --- |
| foods | fdc_id, name, category, source_name, kcal/protein/carbs/fat_per_g, is_listed, is_common |
| meals | id, name, meal_type, logged_at |
| meal_items | id, meal_id, food_id, food_name, grams, saved per-gram nutrients |
| water_entries | id, ounces, logged_at |
| goals | effective_date, calories, water_ounces, optional protein/carbs/fat gram targets |
| catalog_state | Imported catalog version (internal) |

Food quantities are **edible grams** matching the listed preparation. Water is stored/displayed in **US fluid ounces**, not weight ounces. Timestamps are epoch **milliseconds**; use `DateTime.fromMillisecondsSinceEpoch(value)` for display. Goals use a local `YYYY-MM-DD` effective date. Null macro goals mean the user has not set a target yet.

A meal can contain multiple meal items. Deleting a meal cascades to its items. Saves/edits are transactional: failure leaves the original entry intact. Food nutrition is snapshotted into each meal item; existing food snapshots are preserved during edits even if catalog nutrition later changes. Adding a new food uses its current catalog values.

## Open once and share with the app

```dart
import 'package:flutter/widgets.dart';
import 'package:k_trition/data/nutrition_repository.dart';

WidgetsFlutterBinding.ensureInitialized();
final repository = await NutritionRepository.open();
// Share this repository with screens or your app's state provider.
// Show loading/error states while it opens. Close it when its owner is disposed:
// await repository.close();
```

Do not open a new database on every widget build. `main.dart` opens the repository once and passes it to the dashboard.

## Food selection and quantity previews

```dart
final common = await repository.searchFoods(commonOnly: true, limit: 50);
final matches = await repository.searchFoods(query: 'chicken', limit: 25);
final nextPage = await repository.searchFoods(query: 'chicken', limit: 25, offset: 25);
final categories = await repository.getCategories();
final fruit = await repository.searchFoods(category: 'Produce');
final food = await repository.getFood(171688); // Apple
final preview = repository.calculate(food, 150); // 78 calories
```

Search matches substrings without case sensitivity and has stable name/ID ordering. Maximum page size is 100. The dashboard browses by category and renders scrollable results. `watchFoods(...)` provides a stream with the same query parameters.

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
  calories: 2000,
  waterOunces: 64,
  proteinGrams: 140,
  carbsGrams: 250,
  fatGrams: 70,
  effectiveDate: DateTime.now(),
); // Example values only: users should choose their own targets.
final progress = await repository.progressForDay(DateTime.now());
final history = await repository.progressForRange(
  DateTime(2026, 10, 1), DateTime(2026, 11, 1), // end is exclusive
);
```

Pass an existing ID to edit; a missing ID throws instead of silently recreating a deleted entry. Deleting a missing ID returns zero. Supported meal types: Breakfast, Lunch, Dinner, Snack. In the UI, handle errors explicitly, wait for a write to succeed before showing success, and preserve the user's input if it fails.

## Live data and dates

```dart
final stream = repository.watchDailyProgress(selectedDate);
// Future UI: use StreamBuilder<DailyProgress>(stream: stream, ...).
// progress.nutrition.calories / protein / carbs / fat
// progress.waterOunces, calorieGoal, waterGoalOunces
// progress.proteinGoalGrams, carbsGoalGrams, fatGoalGrams
```

`watchMeals(day)` and `watchWater(day)` also update after changes. Streams respond to edits/deletions and goal changes; totals are derived, not stored separately. Goal history uses the last effective date on or before the requested day. A new target does not rewrite earlier days.

Daily windows run from local midnight to the next local midnight, so daylight-saving days are handled as calendar days rather than fixed 24-hour intervals. When integrating the repository, pass the same selected date to forms and lists and recreate streams when the date changes or midnight arrives. Historical grouping follows the device's current timezone. `progressForRange` supports up to 366 calendar days, with an exclusive end.

## Persistence and ownership

Native platforms store SQLite in the app's application-support directory. Browsers use Drift's browser-local storage. Use a stable development origin, e.g. `flutter run -d chrome --web-port=7357`; a different port/host has separate storage. Private browsing, storage restrictions, clearing browser data or uninstalling the app may remove data. Browser-specific storage behavior should also be tested on the final deployment origin.

Each device has its own logs. GitHub shares the catalog and code, **not private user databases**. There is no account/cloud sync in this version.

## Schema and catalog changes

After changing SQL, run `dart run build_runner build` and commit both SQL and regenerated Dart. Once this schema has shipped, increment `schemaVersion` and write/test a migration for any schema change. Do not delete user data to fix a schema issue.

To rebuild the catalog, run `python3 tool/clean_food_catalog.py`. Increment `catalog_version` when publishing a changed catalog. Import is transactional and skips already-imported versions. Removed choices are archived (`is_listed = false`), not deleted from existing logs; nutrient snapshots remain intact.

## Verify

```sh
flutter pub get
flutter analyze
flutter test
flutter build web
```

Tests cover source-backed nutrient math, full catalog and common filtering, date boundaries, CRUD/rollback, snapshot preservation, live stream updates, and reopening a file-backed SQLite database. The web runtime files follow the [official Drift setup](https://drift.simonbinder.eu/platforms/web/) and must be updated with Drift.
