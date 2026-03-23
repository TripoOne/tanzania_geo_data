
import json
import sys

def find_ward(ward_to_find, json_path):
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    regions = data.get("regions", {})
    for region_name, region_data in regions.items():
        districts = region_data.get("districts", {})
        for district_name, district_data in districts.items():
            wards = district_data.get("wards", {})
            if ward_to_find in wards:
                return region_name, district_name
    return None, None

if __name__ == "__main__":
    path = r'd:\flutter_projects\tanzania_locations\tanzania_geo_data\lib\tanzaniageodata\all_location.json'
    ward = "Alaitolei"
    if len(sys.argv) > 1:
        ward = sys.argv[1]
    
    r, d = find_ward(ward, path)
    if r:
        print(f"Ward: {ward}")
        print(f"Region: {r}")
        print(f"District: {d}")
    else:
        print(f"Ward {ward} not found.")

