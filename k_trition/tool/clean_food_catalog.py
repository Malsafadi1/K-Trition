"""Build one simple listing per everyday food from explicit USDA baseline IDs.
Run from any directory: python3 tool/clean_food_catalog.py
The baseline source stays untouched; omitted variants are archived by the app.
"""
import collections
import csv
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def build(foods, choices):
    source = {f['fdc_id']: f for f in foods}
    result = []
    names, ids = set(), set()
    for choice in choices:
        name = choice['name'].strip()
        id = choice['fdc_id']
        if not name or name.casefold() in names or id in ids:
            raise ValueError(f'Duplicate/empty master food: {name} ({id})')
        names.add(name.casefold())
        ids.add(id)
        if 'recipe' in choice:
            recipe = choice['recipe']
            powder = source[recipe['powder_fdc_id']]
            total = recipe['powder_g'] + recipe['water_g']
            baseline = dict(powder, fdc_id=id, is_common=False,
                            source_name=f"Recipe: {recipe['powder_g']} g whey protein powder + {recipe['water_g']} g water",
                            data_type='recipe', recipe=recipe)
            for key in ['kcal_per_g', 'protein_per_g', 'carbs_per_g', 'fat_per_g']:
                baseline[key] = powder[key] * recipe['powder_g'] / total
        else:
            baseline = source[id]  # Missing baseline fails; never guess nutrients.
        category = choice['category']
        if category not in {'Proteins', 'Produce', 'Grains & Carbs', 'Dairy & Fats', 'Common Mixed/Prepared Items'}:
            raise ValueError(f'Unexpected category: {category}')
        result.append(dict(baseline, name=name, category=category,
                           default_serving_g=total if 'recipe' in choice else 100,
                           serving_unit='g'))
    return sorted(result, key=lambda f: f['name'].casefold())


def write_preview(path, foods):
    fields = ['fdc_id', 'name', 'category', 'source_name', 'kcal_per_g',
              'protein_per_g', 'carbs_per_g', 'fat_per_g', 'default_serving_g']
    with path.open('w', newline='') as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, extrasaction='ignore', lineterminator='\n')
        writer.writeheader()
        writer.writerows(foods)


def main():
    source = json.loads((ROOT / 'tool/core_food_baselines.json').read_text())
    choices = json.loads((ROOT / 'tool/simple_food_choices.json').read_text())
    foods = build(source['foods'], choices)
    if len(foods) != 300 or len(foods) > 350:
        raise ValueError('Core catalog must contain 300 foods, never more than 350')
    payload = {'catalog_version': 5, 'source': source['source'], 'foods': foods}
    # Only the active catalog is bundled; source baselines stay in tool/.
    out = ROOT / 'assets/data'
    (out / 'foods.json').write_text(json.dumps(payload, indent=2) + '\n')
    write_preview(out / 'foods_preview.csv', foods)
    report = {'catalog_version': 5, 'source_baselines': len(source['foods']),
              'master_foods': len(foods),
              'policy': 'One USDA baseline per food; whey shake is a documented powder-and-water recipe.',
              'categories': dict(collections.Counter(f['category'] for f in foods))}
    (out / 'catalog_report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
