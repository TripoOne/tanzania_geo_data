
import json
import re
import difflib

wards_path = r'd:\flutter_projects\tanzania_locations\tanzania_geo_data\lib\src\data\wards.dart'
districts_path = r'd:\flutter_projects\tanzania_locations\tanzania_geo_data\lib\src\data\districts.dart'
streets_path = r'd:\flutter_projects\tanzania_locations\tanzania_geo_data\lib\src\data\streets.dart'
all_location_path = r'd:\flutter_projects\tanzania_locations\tanzania_geo_data\lib\tanzaniageodata\all_location.json'
new_wards_path = wards_path + '.full2'

# 1. Load existing districts
with open(districts_path, 'r', encoding='utf-8') as f:
    d_content = f.read()
    districts = sorted(list(set(re.findall(r"District\(name: '([^']+)'", d_content))))
    districts_lower = {d.lower(): d for d in districts}

# 2. Load all_location.json into a searchable mapping
print("Loading all_location.json...")
with open(all_location_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

json_mapping = {} # ward_name_lower -> district_name
regions = data.get("regions", {})
for rn, rd in regions.items():
    dists = rd.get("districts", {})
    for dn, dd in dists.items():
        clean_dn = " ".join(dn.replace('\n', ' ').split())
        # Map clean_dn to our districts if possible
        target_dn = districts_lower.get(clean_dn.lower())
        if not target_dn:
            # Try fuzzy/manual for some known ones
            if "cbd" in clean_dn.lower():
                base = clean_dn.lower().replace("cbd", "").strip()
                for d in districts:
                    if base in d.lower() and ("Municipal" in d or "City" in d):
                        target_dn = d
                        break
        
        if not target_dn: target_dn = clean_dn # fallback

        wards = dd.get("wards", {})
        for wn in wards.keys():
            if wn == "ward_post_code": continue
            json_mapping[wn.lower()] = target_dn

# 3. Find missing wards from streets.dart
with open(wards_path, 'r', encoding='utf-8') as f:
    w_content = f.read()
    existing_wards = set(re.findall(r"Ward\(name: '([^']+)'", w_content))

with open(streets_path, 'r', encoding='utf-8') as f:
    s_content = f.read()
    street_wards = set(re.findall(r"wardName: '([^']+)'", s_content))

missing = street_wards - existing_wards
print(f"Remaining missing wards: {len(missing)}")

# 4. Fuzzy Match
new_entries = []
found_count = 0

json_ward_names = list(json_mapping.keys())

for m in sorted(list(missing)):
    m_lower = m.lower()
    match = None
    
    # Simple match
    if m_lower in json_mapping:
        match = m_lower
    else:
        # Fuzzy match
        matches = difflib.get_close_matches(m_lower, json_ward_names, n=1, cutoff=0.8)
        if matches:
            match = matches[0]
    
    if match:
        target_district = json_mapping[match]
        # Final safety check on district
        if target_district.lower() in districts_lower:
            target_district = districts_lower[target_district.lower()]
            new_entries.append(f"  Ward(name: '{m}', districtName: '{target_district}'),")
            found_count += 1

print(f"Fuzzy matcheable wards found: {found_count}")

# 5. Append
if new_entries:
    last_bracket_idx = w_content.rfind("];")
    if last_bracket_idx != -1:
        updated_content = w_content[:last_bracket_idx] + "\n".join(new_entries) + "\n" + w_content[last_bracket_idx:]
        with open(new_wards_path, 'w', encoding='utf-8') as f:
            f.write(updated_content)
        print(f"Successfully created {new_wards_path} with {len(new_entries)} additional wards.")
