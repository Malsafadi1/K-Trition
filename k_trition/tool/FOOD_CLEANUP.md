# Core 300 food catalog

The active catalog contains exactly **300 foods**, below the hard maximum of 350.

| App category | Choices |
| --- | ---: |
| Proteins | 56 |
| Produce | 108 |
| Grains & Carbs | 39 |
| Dairy & Fats | 58 |
| Common Mixed/Prepared Items | 39 |

The requested approximate category counts totaled 450. This allocation keeps the overall Core 300 target and includes everyday foods without filling categories with cosmetic variants. The prepared category includes drinks, sauces and seasonings.

The food form supports browsing by category without typing, or filtering a category by name. Search results scroll. One Apple represents ordinary apples; cultivars, grades, trim specifications and cosmetic variants do not become extra listings. Meaningful distinctions such as lean/regular ground beef, whole/skim milk, and white/brown rice remain. Preparation and actual USDA descriptions are preserved for verification; raw and cooked weights are not interchangeable.

## Rebuild

```bash
python3 tool/clean_food_catalog.py
python3 -m unittest discover -s tool -p test_clean_food_catalog.py
```

`simple_food_choices.json` specifies each simple name, category and exact baseline ID. The builder reads the 299 selected USDA SR Legacy/Foundation baselines in `tool/core_food_baselines.json`. These include bread, pizza, coffee and protein powder. No credentials or source download are needed by teammates or the app.

To re-extract the baselines from the original official USDA CSV download:

```bash
python3 tool/import_core_baselines.py /path/to/FoodData_Central_csv_2026-04-30
```

The extractor validates nutrient units and required energy/protein/carbohydrate/fat values. Values are per gram, not per serving. Missing values fail rather than becoming zero. Source descriptions and IDs remain available, even when they contain technical or brand wording; display names remain generic. A selected source baseline is an estimate for that listing, not a claim that every brand/recipe is nutritionally identical.

## Whey shake

The shake is an explicit recipe: **30 g whey protein powder + 240 g water = 270 g**. Nutrition equals the powder's nutrients; water contributes none. Selecting it defaults to 270 g. The powder itself remains separately available for people mixing it with milk. Local recipe ID 900000001 is reserved for this record and is not a USDA FDC ID.

## App and history

The app loads `assets/data/foods.json`, catalog version 5. Read `assets/data/foods_preview.csv` to see the active 300 choices. Database upgrades archive omitted foods, preserve historical meal snapshots, and leave water/goals intact. Adding foods later requires incrementing the catalog version and rebuilding.

Prepared foods use generic USDA baselines. Servings are edible grams; the app does not guess weights for a pizza slice, bread slice, or restaurant portion. Weigh the portion or use a verified package weight.
