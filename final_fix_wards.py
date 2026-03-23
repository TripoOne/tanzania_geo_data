
import pandas as pd
import re
import os

wards_path = r'd:\flutter_projects\tanzania_locations\tanzania_geo_data\lib\src\data\wards.dart'
districts_path = r'd:\flutter_projects\tanzania_locations\tanzania_geo_data\lib\src\data\districts.dart'
streets_path = r'd:\flutter_projects\tanzania_locations\tanzania_geo_data\lib\src\data\streets.dart'
excel_path = r'd:\flutter_projects\tanzania_locations\tanzania_geo_data\lib\tanzaniageodata\tza_admgz_20181019.xlsx'
new_wards_path = wards_path + '.full'

# 1. Load existing districts
with open(districts_path, 'r', encoding='utf-8') as f:
    d_content = f.read()
    districts = sorted(list(set(re.findall(r"District\(name: '([^']+)'", d_content))))
    districts_lower = {d.lower(): d for d in districts}

# 2. Load Excel mapping
print(f"Reading Excel from {excel_path}...")
sheet_name = 'tza_admbnda_adm3_20181019'
df = pd.read_excel(excel_path, sheet_name=sheet_name)

ward_col = 'ADM3_EN'
dist_col = 'ADM2_EN'

if ward_col not in df.columns or dist_col not in df.columns:
    print(f"Error: Could not find Ward ({ward_col}) or District ({dist_col}) columns. Columns: {df.columns.tolist()}")
    exit(1)

print(f"Using columns: {ward_col}, {dist_col} from sheet {sheet_name}")
# Some wards might have duplicate names in different districts, so we need a mapping that considers that if possible, 
# but for now, we'll use a simple name-to-name if that's all we have.
excel_mapping = df.set_index(ward_col)[dist_col].to_dict()

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
    # Try exact, then normalization for Excel mapping
    target_dist_raw = None
    if m in excel_mapping:
        target_dist_raw = excel_mapping[m]
    else:
        # Try simplified match
        m_norm = m.lower().strip()
        for k, v in excel_mapping.items():
            if str(k).lower().strip() == m_norm:
                target_dist_raw = v
                break
    
    if target_dist_raw:
        target_dist_raw = str(target_dist_raw).strip()
        # Map target_dist_raw to our districts.dart
        target_district = None
        if target_dist_raw in districts:
            target_district = target_dist_raw
        else:
            norm_raw = target_dist_raw.lower()
            if norm_raw in districts_lower:
                target_district = districts_lower[norm_raw]
            else:
                # Handle cases like "Arusha DC" vs "Arusha District Council"
                # Search for contains
                for d in districts:
                    if norm_raw in d.lower() or d.lower() in norm_raw:
                        target_district = d
                        break
        
        if target_district:
            new_entries.append(f"  Ward(name: '{m}', districtName: '{target_district}'),")
            found_count += 1
        else:
            not_found_count += 1
    else:
        not_found_count += 1

print(f"Mappable wards found in Excel: {found_count}")
print(f"Wards still missing mapping: {not_found_count}")

# 5. Build full content
if new_entries:
    # Find the position of the last ]; in the original file
    last_bracket_idx = w_content.rfind("];")
    if last_bracket_idx != -1:
        updated_content = w_content[:last_bracket_idx] + "\n".join(new_entries) + "\n" + w_content[last_bracket_idx:]
        with open(new_wards_path, 'w', encoding='utf-8') as f:
            f.write(updated_content)
        print(f"Successfully created {new_wards_path} with {len(new_entries)} additional wards.")
    else:
        print("Error: Could not find end of list in wards.dart")
else:
    print("No new wards to add.")
