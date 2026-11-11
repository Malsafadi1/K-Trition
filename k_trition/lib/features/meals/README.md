# Meal tracking

The current dashboard adds individual food entries and lets users label each as Breakfast, Lunch, Dinner, or Snack. It shows calorie totals and history, and entries can be deleted. A serving size and calorie value can be entered, but both are optional; calories are not calculated from the serving size. The prototype keeps entries in memory only, so they do not survive an app restart.

The database layer supports meals containing one or more food portions, saves nutrient values with each portion, and provides create, edit, query, and delete operations. The dashboard is not using that API yet. See the [database guide](../../docs/DATABASE_GUIDE.md).
