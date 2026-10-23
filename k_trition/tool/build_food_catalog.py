"""Build the local 5,000–10,000-food MVP from USDA SR Legacy/Foundation CSVs.
python3 tool/build_food_catalog.py /path/to/FoodData_Central_csv_2026-04-30
No source download or Python installation is required to run the Flutter app.
"""
import csv,json,math,sys,collections
from pathlib import Path
root=Path(__file__).resolve().parents[1];source=Path(sys.argv[1])
choices={str(c['fdc_id']):c for c in json.loads((root/'tool/food_choices.json').read_text())}
# Basic-food categories only: excludes baby food, beverages/alcohol, sweets,
# restaurants, fast food, prepared entrees, snacks and branded breakfast cereals.
core_categories={'1','2','4','5','9','10','11','12','13','15','16','17','20'}
def rows(name):
    with (source/(name+'.csv')).open(encoding='utf-8-sig',newline='') as f:yield from csv.DictReader(f)
categories={r['id']:r['description'] for r in rows('food_category')}
selected={}
for r in rows('food'):
    if r['data_type'] not in {'sr_legacy_food','foundation_food'} or r['food_category_id'] not in core_categories:continue
    # Some culinary extracts contain alcohol despite being basic ingredients.
    if any(word in r['description'].lower() for word in ['alcoholic beverage','beer,','wine,','liqueur','whiskey','vodka','rum,']):continue
    choice=choices.get(r['fdc_id'])
    selected[r['fdc_id']]={'fdc_id':int(r['fdc_id']),'name':choice['name'] if choice else r['description'],'category':categories[r['food_category_id']],'source_name':r['description'],'data_type':r['data_type'],'published':r['publication_date'],'is_common':bool(choice),'nutrients':{}}
print('Scanning nutrients for',len(selected),'core food records',flush=True)
wanted={'1003':'protein_per_g','1004':'fat_per_g','1005':'carbs_per_g','1008':'kcal_1008','2048':'kcal_2048','2047':'kcal_2047'}
units={r['id']:r['unit_name'].upper() for r in rows('nutrient')}
for nid in wanted:assert units[nid]==('KCAL' if nid in ['1008','2048','2047'] else 'G')
for r in rows('food_nutrient'):
    if r['fdc_id'] not in selected or r['nutrient_id'] not in wanted or not r['amount']:continue
    value=float(r['amount'])
    if math.isfinite(value) and value>=0:
        n=selected[r['fdc_id']]['nutrients'];key=wanted[r['nutrient_id']]
        if key in n:raise ValueError('Duplicate nutrient requires review: '+r['fdc_id'])
        n[key]=value/100
foods=[];missing=[]
for food in selected.values():
    n=food.pop('nutrients');energy=next((k for k in ['kcal_1008','kcal_2048','kcal_2047'] if k in n),None)
    if energy is None or not all(k in n for k in ['protein_per_g','carbs_per_g','fat_per_g']):missing.append(food['fdc_id']);continue
    food.update(kcal_per_g=n[energy],protein_per_g=n['protein_per_g'],carbs_per_g=n['carbs_per_g'],fat_per_g=n['fat_per_g'],energy_nutrient_id=int(energy.split('_')[1]))
    foods.append(food)
foods.sort(key=lambda f:(f['name'].lower(),f['fdc_id']))
assert 5000<=len(foods)<=10000, 'Review catalog scope before shipping'
report={'source':source.name,'foods':len(foods),'common_foods':sum(f['is_common'] for f in foods),'excluded_missing_required_nutrients':len(missing),'by_type':dict(collections.Counter(f['data_type'] for f in foods)),'by_category':dict(collections.Counter(f['category'] for f in foods)),'notes':['Source categories focus on basic foods; some category members include preparation/ingredients and retain their full source descriptions.','No branded or survey records, baby food, beverages/alcohol, sweets, restaurant/fast-food or snack categories.','Required missing values are excluded, never guessed or converted to zero.','Nutrients normalized from per 100 g; energy priority 1008 then 2048 then 2047 (kcal only).','Source IDs/variants retained; common-food aliases select individual representative records, not averages.']}
payload={'catalog_version':1,'source':source.name,'foods':foods}
out=root/'assets/data';out.mkdir(parents=True,exist_ok=True)
(out/'foods.json').write_text(json.dumps(payload,separators=(',',':')))
(out/'import_report.json').write_text(json.dumps(report,indent=2))
with (out/'foods_preview.csv').open('w',newline='') as f:
    w=csv.DictWriter(f,fieldnames=list(foods[0]));w.writeheader();w.writerows(foods)
print(json.dumps(report,indent=2),flush=True)
