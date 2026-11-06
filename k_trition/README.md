# K-Trition Flutter app

K-Trition is a Flutter nutrition tracker for Kalamazoo College students, backed by a persistent local SQLite database through Drift.

## What works

- Browse **300 everyday foods** across five categories, or search and scroll through matches.
- Select a food, enter edible grams, and calculate calories from its USDA baseline.
- Save meals by Breakfast, Lunch, Dinner or Snack; track water in **US fluid ounces**.
- Set dated calorie/water goals and view daily progress and day/week/month history.
- Delete logged entries. Logs and goals persist locally between sessions.

The repository also supports multi-food meals, edits and macronutrient totals. Editing controls, a macro summary, and a settings screen remain UI work. There is no sign-in, server or cloud sync.

## Run the app

Install Flutter and Chrome, open a terminal in this `k_trition` folder, and run:

```sh
flutter pub get
flutter run -d chrome --web-port=7357
```

Open the URL printed by Flutter (normally `http://localhost:7357`). Keep the same host and port when testing browser database storage: browser storage is separated by origin.

To run on another platform, use `flutter devices` to see available targets and replace `chrome` in the run command with the desired device ID. Android and iOS builds require their platform toolchains. On Windows, use PowerShell or Command Prompt; in a shell where the Flutter command is not on `PATH`, run the Flutter SDK's `bin/flutter` command instead.

## Check the project

Run these commands from this folder:

```sh
python3 -m unittest discover -s tool -p 'test_clean_food_catalog.py'
flutter analyze
flutter test
flutter build web
```

The tests cover category browsing, search/scrolling, logging, goals, dates, and database persistence. The optional [browser database smoke check](docs/TEAM_WORKFLOW.md#optional-browser-database-check) exercises the real web database separately from the dashboard.

## Project guides

- [Current features and next steps](docs/MVP.md)
- [Database guide](docs/DATABASE_GUIDE.md)
- [Team Git workflow](docs/TEAM_WORKFLOW.md)
- [Core 300 catalog maintenance](tool/FOOD_CLEANUP.md)
