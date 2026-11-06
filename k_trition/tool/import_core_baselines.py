"""Extract Core 300 baselines from a local official USDA CSV download.
Usage: python3 tool/import_core_baselines.py /path/to/FoodData_Central_csv_DATE
The app does not need this download; commit the small output JSON.
"""
import csv
import json
import math
import sys
from pathlib import Path
from clean_food_catalog import ROOT


def main():
    source = Path(sys.argv[1])
    choices = json.loads((ROOT / 'tool/simple_food_choices.json').read_text())
    wanted = {str(c['fdc_id']) for c in choices if 'recipe' not in c and c['fdc_id'] > 0}
    records = {}
    def rows(name):
        with (source / f'{name}.csv').open(encoding='utf-8-sig', newline='') as handle:
            yield from csv.DictReader(handle)
    for row in rows('food'):
        if row['fdc_id'] in wanted:
            if row['data_type'] not in {'sr_legacy_food', 'foundation_food'}:
                raise ValueError('Only SR Legacy or Foundation baselines allowed')
            records[row['fdc_id']] = dict(fdc_id=int(row['fdc_id']), name=row['description'],
                source_name=row['description'], category='Supplement',
                data_type=row['data_type'], published=row['publication_date'],
                is_common=False, nutrients={})
    nutrients = {'1003': 'protein_per_g', '1004': 'fat_per_g', '1005': 'carbs_per_g',
                 '1008': 'energy_1008', '2048': 'energy_2048', '2047': 'energy_2047'}
    units = {r['id']: r['unit_name'].upper() for r in rows('nutrient')}
    for id in nutrients:
        assert units[id] == ('G' if int(id) < 1008 else 'KCAL')
    print(f'Reading nutrients for {len(records)} baselines...', flush=True)
    for row in rows('food_nutrient'):
        if row['fdc_id'] not in records or row['nutrient_id'] not in nutrients or not row['amount']:
            continue
        value = float(row['amount'])
        if not math.isfinite(value) or value < 0:
            raise ValueError('Invalid nutrient')
        n = records[row['fdc_id']]['nutrients']
        key = nutrients[row['nutrient_id']]
        if key in n:
            raise ValueError('Duplicate nutrient requires review')
        n[key] = value / 100
    for food in records.values():
        n = food.pop('nutrients')
        energy = next((id for id in [1008, 2048, 2047] if f'energy_{id}' in n), None)
        if energy is None or any(k not in n for k in ['protein_per_g','fat_per_g','carbs_per_g']):
            raise ValueError(f'Missing required nutrients: {food["source_name"]}')
        food.update({k: n[k] for k in ['protein_per_g','fat_per_g','carbs_per_g']})
        food.update(kcal_per_g=n[f'energy_{energy}'], energy_nutrient_id=energy)
    assert len(records) == len(wanted)
    out = ROOT / 'tool/core_food_baselines.json'
    out.write_text(json.dumps({'source': source.name, 'foods': sorted(records.values(),key=lambda f:f['fdc_id'])},indent=2)+'\n')
    print(f'Wrote {len(records)} USDA baselines to {out.name}')


if __name__ == '__main__':
    main()
