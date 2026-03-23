
import json
import re
import os

all_location_path = r'd:\flutter_projects\tanzania_locations\tanzania_geo_data\lib\tanzaniageodata\all_location.json'
output_mapping_path = r'd:\flutter_projects\tanzania_locations\tanzania_geo_data\ward_district_mapping.json'

with open(all_location_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

mapping = {}
regions = data.get("regions", {})
for region_name, region_data in regions.items():
    districts = region_data.get("districts", {})
    for district_name, district_data in districts.items():
        # Clean district name (remove \n and normalize)
        clean_district = " ".join(district_name.replace('\n', ' ').split())
        wards = district_data.get("wards", {})
        for ward_name in wards.keys():
            if ward_name == "ward_post_code": continue # skip the key if it's there
            mapping[ward_name] = clean_district

with open(output_mapping_path, 'w', encoding='utf-8') as f:
    json.dump(mapping, f, indent=4)

print(f"Extracted {len(mapping)} ward-to-district mappings to {output_mapping_path}")
