# Local data layer

The dashboard uses this Drift/SQLite data layer for Core 300 food search, serving-based calories, meal/water logging, dated goals, and history. Data persists locally; no cloud account or API key is required.

Start with the [database guide](../../docs/DATABASE_GUIDE.md) for tables, units and repository examples, or the [catalog guide](../../tool/FOOD_CLEANUP.md) to change food choices. Share one repository per app; do not create a database on every widget build. Generated `database.g.dart` should be regenerated from `schema.drift`, never hand-edited.
