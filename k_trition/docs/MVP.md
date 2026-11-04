# Current features and next steps

This page separates the features available in the app screen from the capabilities implemented in the database. A feature in the database is not automatically available in the app: the dashboard and database still need to be connected.

## Available in the dashboard

- **Food logging:** Enter a food name, an optional serving size in grams, and an optional calorie value. Assign it to Breakfast, Lunch, Dinner, or Snack.
- **Water logging:** Enter an amount in US fluid ounces or choose a quick amount.
- **Daily overview:** See calorie and water totals against editable goals. Move between dates or choose one from the date picker.
- **History:** Browse food and water entries by day, week, or month.
- **Delete:** Remove food or water entries from the current in-memory list.

These are prototype interactions. Entries and goals exist only in app memory, so a restart clears them. The screen does not currently look up foods in the catalog, calculate nutrition from serving size, track protein/carbohydrates/fat, or save data to the local database. Settings are a placeholder.

## Available in the local database layer

The Drift/SQLite repository supports:

- A bundled catalog of 5,084 USDA foods, including 44 common choices, searchable by name and category.
- Nutrition calculations from food quantities in grams.
- Multi-food meal records, water records, and create/read/update/delete operations.
- Effective-dated calorie and water goals, daily progress, history queries, and live data streams.
- Local persistence on native platforms and in the browser.

The database API is implemented and tested, but `main.dart` does not open it and the dashboard does not call it. Read the [database guide](DATABASE_GUIDE.md) for details.

## Next integration steps

- [ ] Connect the app to one shared `NutritionRepository` and display loading/error states.
- [ ] Replace manual food entry with catalog search and serving-based nutrient calculations.
- [ ] Save food, water, and goal changes through the repository so they persist after restart.
- [ ] Show protein, carbohydrates, and fat, and use saved daily progress in the dashboard and history.
- [ ] Add editing for saved food and water entries.
- [ ] Test persistence on each supported platform and the final browser origin.
- [ ] Decide and implement the settings screen.

## Not included in this version

There are no accounts, Firebase configuration, server, or cloud sync. Each installation keeps its own local database. Weight, height, exercise, and sleep tracking are outside the current scope.
