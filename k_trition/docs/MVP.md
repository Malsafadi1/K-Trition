# K-Trition MVP plan

All features below are planned. This scaffold intentionally leaves them for the group to implement and review.

- [ ] 1. Food database: name, preparation, calories, protein, carbohydrates, and fat per gram; source attribution.
- [ ] 2. Log a meal: date/time, meal type, and one or more food portions.
- [ ] 3. Calculate calories/macros: multiply each food's per-gram values by entered grams and sum portions.
- [ ] 4. Track water: log an amount in mL with date/time.
- [ ] 5. Set calorie/water goals: save daily goals in kcal and mL.
- [ ] 6. View daily progress: compare daily calories and water totals to goals; show macro totals.
- [ ] 7. Edit/delete previous entries: update or remove meal and water logs; recalculate totals.
- [ ] 8. Persistent local database: retain foods, logs, and goals after restart.

## Proposed local data model — review before coding

| Table | Suggested fields |
| --- | --- |
| foods | id, name, preparation, kcal_per_g, protein_g_per_g, carbs_g_per_g, fat_g_per_g, source |
| meals | id, name, meal_type, logged_at |
| meal_items | id, meal_id, food_id, quantity_g, snapshot of per-gram nutrition values |
| water_entries | id, amount_ml, logged_at |
| goals | id, calorie_goal_kcal, water_goal_ml, effective_date |

A meal may have multiple meal_items. Keep nutrition snapshots so catalog changes do not rewrite historical meals. Decide together how changed goals apply to earlier days.

## Calculation contract

`portion calories = quantity_g × kcal_per_g`

Use the same calculation for protein, carbs, and fat. Sum portions for meal totals, then sum meals for daily totals. If imported data is per 100 g, divide each value by 100 once during import. Preserve decimals internally; round only for display.

## Suggested order

Food data and database schema → meal logging and calculations → water logging → goals → daily progress → editing/deleting → persistence/restart verification.

Agree on database package and target platforms early; choose one that supports all platforms you intend to demonstrate. Validate positive, finite quantities and goals, handle missing food records, and define days using local dates consistently.

## Acceptance checks to add with implementation

- Known quantity produces the expected calories and all three macros.
- Multi-food meal totals correctly.
- Invalid input does not create an entry.
- Today's totals exclude earlier days.
- Editing/deleting changes totals correctly.
- Logs and goals survive an app restart.

Weight, height, workouts, and sleep are outside this MVP scope.
