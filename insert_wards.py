
import json
import re
import os

wards_path = r'd:\flutter_projects\tanzania_locations\tanzania_geo_data\lib\src\data\wards.dart'
districts_path = r'd:\flutter_projects\tanzania_locations\tanzania_geo_data\lib\src\data\districts.dart'
streets_path = r'd:\flutter_projects\tanzania_locations\tanzania_geo_data\lib\src\data\streets.dart'
mapping_path = r'd:\flutter_projects\tanzania_locations\tanzania_geo_data\ward_district_mapping.json'
new_wards_path = wards_path + '.full'

# 1. Load existing districts
with open(districts_path, 'r', encoding='utf-8') as f:
    d_content = f.read()
    districts = sorted(list(set(re.findall(r"District\(name: '([^']+)'", d_content))))
    districts_lower = {d.lower(): d for d in districts}

# 2. Load JSON mapping
with open(mapping_path, 'r', encoding='utf-8') as f:
    json_mapping = json.load(f)

# 3. Find missing wards from streets.dart
with open(wards_path, 'r', encoding='utf-8') as f:
    w_content = f.read()
    existing_wards = set(re.findall(r"Ward\(name: '([^']+)'", w_content))

with open(streets_path, 'r', encoding='utf-8') as f:
    s_content = f.read()
    street_wards = set(re.findall(r"wardName: '([^']+)'", s_content))

missing = street_wards - existing_wards
print(f"Total missing wards to add: {len(missing)}")

# 4. Prepare new ward entries
new_entries = []
found_count = 0
not_found_count = 0

for m in sorted(list(missing)):
    if m in json_mapping:
        json_district = json_mapping[m]
        # Map JSON district to valid district in districts.dart
        # Try exact, then normalized
        target_district = None
        if json_district in districts:
            target_district = json_district
        else:
            norm_json = " ".join(json_district.split()).lower()
            if norm_json in districts_lower:
                target_district = districts_lower[norm_json]
            else:
                # Handle some common mismatches
                if "cbd" in norm_json: 
                    # Try name before cbd + Municipal/City
                    base = norm_json.replace("cbd", "").strip()
                    for d in districts:
                        if base in d.lower() and ("Municipal" in d or "City" in d):
                            target_district = d
                            break
        
        if target_district:
            new_entries.append(f"  Ward(name: '{m}', districtName: '{target_district}'),")
            found_count += 1
        else:
            not_found_count += 1
    else:
        not_found_count += 1

print(f"Mappable wards found in JSON: {found_count}")
print(f"Wards still missing mapping: {not_found_count}")

# 5. Append to wards.dart (before the closing ];)
if new_entries:
    # Find the position of the last ];
    last_bracket_idx = w_content.rfind("];")
    if last_bracket_idx != -1:
        updated_content = w_content[:last_bracket_idx] + "\n".join(new_entries) + "\n" + w_content[last_bracket_idx:]
        with open(new_wards_path, 'w', encoding='utf-8') as f:
            f.write(updated_content)
        print(f"Successfully added {len(new_entries)} wards to {new_wards_path}")
    else:
        print("Error: Could not find end of list in wards.dart")
else:
    print("No new wards to add.")
