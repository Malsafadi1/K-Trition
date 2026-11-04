# Local data layer

This folder contains K-Trition's local SQLite database and the `NutritionRepository` API that app screens can use. It is built with Drift and does not require Firebase, a sign-in, or an internet connection.

The repository and USDA food catalog are implemented and covered by tests. **The current dashboard does not use this data layer yet**; its prototype entries are stored only in memory and disappear when the app restarts.

Start with the [database guide](../../docs/DATABASE_GUIDE.md) for setup, supported operations, units, examples, and testing. Open the repository once for the app and share it with screens; do not create a new database for every widget build.
