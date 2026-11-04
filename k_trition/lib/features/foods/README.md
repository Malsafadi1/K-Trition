# Food tracking

The current dashboard accepts a manually entered food name, an optional serving size in grams, and an optional calorie value. Entries can be assigned a meal type, viewed in daily and date-range history, and deleted. The screen does not currently search the food catalog or calculate nutrition from serving size. Entries are stored in memory only and are cleared when the app restarts.

The local database includes a searchable USDA food catalog and supports quantity-based calorie and macronutrient calculations. That API is not connected to the dashboard yet. See the [database guide](../../docs/DATABASE_GUIDE.md) for catalog details and examples.
