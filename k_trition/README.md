# K-Trition

Group Flutter nutrition tracker for Kalamazoo College students.

## Current state

A complete local SQLite/Drift data layer is ready for UI integration. The existing UI intentionally remains the MVP roadmap.

- 5,084 USDA SR Legacy/Foundation foods from core food categories
- 44 common choices with plain names, plus full paginated catalog search
- Quantity-based calories and macros; food weights in grams
- Meal/water CRUD, water in US fluid ounces, dated goals
- Live progress streams, history queries and persistent local storage
- No Firebase project, login, server, or cloud configuration needed

Start with [the database/UI guide](docs/DATABASE_GUIDE.md). Review source counts in `assets/data/import_report.json` or browse `assets/data/foods_preview.csv` in Excel.

## Run

Install Flutter (tested with 3.47.7), then from this directory:

```sh
flutter pub get
flutter run -d chrome --web-port=7357
```

In the original class workspace, use `../../flutter/bin/flutter` instead of `flutter`. Android and iOS require their respective toolchains. A fixed browser port keeps local data on the same origin.

## Check

```sh
flutter analyze
flutter test
flutter build web
```

The starter screen does not show database content yet. To test the database directly, run the tests or the optional browser smoke check in [TEAM_WORKFLOW.md](docs/TEAM_WORKFLOW.md).

## Team development

Use [the push/pull and conflict-reduction instructions](docs/TEAM_WORKFLOW.md). Work on separate feature branches and review pull requests. The database owner maintains SQL/generated files; UI teammates call NutritionRepository.

Commit the bundled public food catalog, SQL, generated database code and dependency lockfile. Do not commit personal live databases, credentials, build folders or the Flutter SDK. Every device has its own private local logs; code changes are shared through GitHub.
