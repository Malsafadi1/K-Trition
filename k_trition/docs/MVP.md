# K-Trition MVP

Backend: **local SQLite through Drift**, with 5,084 USDA SR Legacy/Foundation foods and a 44-food common-choice filter. The data layer is implemented; the starter UI remains unchanged and these end-to-end features should be checked off only after UI integration and review.

- [ ] Food selection: common choices, full catalog search and category filters
- [ ] Meal logging with one or more food portions
- [ ] Quantity-based calories and protein/carbs/fat
- [ ] Water tracking in US fluid ounces
- [ ] Effective-dated calorie and water goals
- [ ] Daily progress and history
- [ ] Edit/delete previous meal and water entries
- [ ] Verify persistence after restarting on each target platform

See [DATABASE_GUIDE.md](DATABASE_GUIDE.md) for API examples and units, and [TEAM_WORKFLOW.md](TEAM_WORKFLOW.md) for pushing, pulling and reviewing work.

The data API supports all the above: search, transactional CRUD, nutrient snapshots, live streams, daily/range totals, goals and local persistence. No Firebase, accounts, or cloud sync are used. Weight, height, workouts and sleep are outside this MVP scope.
