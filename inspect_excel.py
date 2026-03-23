
import pandas as pd

excel_path = r'd:\flutter_projects\tanzania_locations\tanzania_geo_data\lib\tanzaniageodata\tza_admgz_20181019.xlsx'
xl = pd.ExcelFile(excel_path)
print("Sheets:")
print(xl.sheet_names)

# Inspect the last sheet which usually contains the most granular data (Wards)
sheet_name = xl.sheet_names[-1]
print(f"\nInspecting sheet: {sheet_name}")
df = pd.read_excel(excel_path, sheet_name=sheet_name)
print("Columns:")
print(list(df.columns))
print("\nFirst 2 rows:")
print(df.head(2).to_string())
