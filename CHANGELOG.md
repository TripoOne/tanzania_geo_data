## 1.0.0

* **Major Update**: Comprehensive national geo-data merge (Mainland + Zanzibar).
* **Enhanced Coverage**: Now contains 31 regions, 170 districts, 4,296 wards, and 16,684 streets.
* **Postcode Integration**: Added `postCode` fields for all regions, districts, and wards.
* **API Expansion**: New search methods in `GeoService`:
    - `getRegionByPostCode()`
    - `getDistrictsByPostCode()`
    - `getWardsByPostCode()`
* **Naming Standardization**: Cleaned and standardized all location names (e.g., standardized `CBD` suffixes).
* **Performance**: Optimized data structures and hierarchical consistency.

## 0.0.1

* Initial release of `tanzania_geo_data`.
* Comprehensive data for Regions, Districts, Wards, and Streets in Tanzania.
* Hierarchical search and retrieval methods.
