import json
import unittest
from clean_food_catalog import ROOT, build


class CleanupTest(unittest.TestCase):
    def setUp(self):
        self.source = json.loads((ROOT / 'tool/core_food_baselines.json').read_text())['foods']
        self.choices = json.loads((ROOT / 'tool/simple_food_choices.json').read_text())
        self.foods = build(self.source, self.choices)

    def test_every_food_has_one_short_unique_name(self):
        names = [f['name'].casefold() for f in self.foods]
        self.assertEqual(len(names), len(set(names)))
        self.assertTrue(all('(' not in n and len(n) <= 30 for n in names))
        for name in ['Apple', 'Beef steak', 'Chicken breast', 'Egg']:
            self.assertEqual(sum(f['name'] == name for f in self.foods), 1)
        self.assertEqual(sum(n == 'apple' for n in names), 1)  # Apple and Pineapple

    def test_all_baselines_retain_actual_source_nutrition(self):
        source = {f['fdc_id']: f for f in self.source}
        for food in self.foods:
            if food['fdc_id'] == 900000001:
                powder = source[173180]
                self.assertAlmostEqual(food['kcal_per_g'] * 270, powder['kcal_per_g'] * 30)
                continue
            for key in ['source_name', 'kcal_per_g', 'protein_per_g', 'carbs_per_g', 'fat_per_g']:
                self.assertEqual(food[key], source[food['fdc_id']][key])
        self.assertEqual(len({f['category'] for f in self.foods}), 5)
        self.assertEqual(len(self.foods), 300)

    def test_bundled_catalog_matches_rebuild(self):
        catalog = json.loads((ROOT / 'assets/data/foods.json').read_text())
        self.assertEqual(catalog['foods'], self.foods)
        self.assertEqual(catalog['catalog_version'], 5)

    def test_duplicate_choices_fail(self):
        with self.assertRaises(ValueError):
            build(self.source, self.choices + [self.choices[0]])


if __name__ == '__main__':
    unittest.main()
