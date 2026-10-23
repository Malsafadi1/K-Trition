# Local SQLite data layer

Start with [the database/UI integration guide](../../docs/DATABASE_GUIDE.md).

- 5,084 USDA SR Legacy/Foundation foods, plus a 44-food common-choice filter
- Food search, quantity-based calories/macros, meal/water CRUD, dated goals
- Live daily progress streams and persistent SQLite storage
- No Firebase, login, cloud project, or UI integration yet

Teammates should use `NutritionRepository.open()` once and pass the repository to their future screens. The current starter UI remains unchanged.
