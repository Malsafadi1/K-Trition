# K-Trition Flutter app

K-Trition is a nutrition-tracking app for Kalamazoo College students. This repository contains a working Flutter dashboard prototype and a separate local nutrition database layer.

## What works in the app

- Add a food entry by typing its name, serving size in grams (optional), and calories (optional). Choose Breakfast, Lunch, Dinner, or Snack.
- Add water in US fluid ounces, using a quick amount or a custom amount.
- View daily calorie and water totals, set daily goals, and browse entries by day, week, or month.
- Delete food and water entries.

**Important:** The current dashboard keeps entries and goals in memory. They are lost when the app restarts. Food names and calories are entered manually; the screen does not yet search the bundled food catalog or show macronutrients. Settings are not implemented.

The project also includes a separate SQLite database layer, powered by Drift, with a USDA food catalog, nutrient calculations, meal and water operations, dated goals, and persistent local storage. The dashboard does not use this database yet. See the [database guide](docs/DATABASE_GUIDE.md) for what the data layer supports and how to use it.

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
flutter analyze
flutter test
flutter build web
```

The tests cover the dashboard prototype and the database layer. The optional [browser database smoke check](docs/TEAM_WORKFLOW.md#optional-browser-database-check) exercises the real web database separately from the dashboard.

## Project guides

- [Current features and next steps](docs/MVP.md)
- [Database guide](docs/DATABASE_GUIDE.md)
- [Team Git workflow](docs/TEAM_WORKFLOW.md)
- [Firebase status](docs/FIREBASE_SETUP.md)
