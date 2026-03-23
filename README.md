# Tanzania Geo Data

[![package - pub.dev](https://img.shields.io/pub/v/tanzania_geo_data.svg)](https://pub.dev/packages/tanzania_geo_data)
[![license - MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A comprehensive Flutter package for retrieving and searching Tanzanian geographic data, including Regions, Districts, Wards, and Streets. This package provides 100% national coverage, including Mainland and Zanzibar, with integrated postcodes and optimized search.

## Features

- **National Coverage**: Full mapping for all 31 Regions and 170 Districts of Tanzania.
- **Enhanced Data**: Includes 4,296 Wards and 16,684 Streets with high hierarchical integrity.
- **Postcode Integration**: Integrated `postCode` support for Regions, Districts, and Wards.
- **Clean Naming**: Standardized location names (e.g., `Kinondoni`, `Arusha CBD`).
- **Postcode Search**: Dedicated methods to retrieve locations by their official postcodes.
- **Lightweight & Efficient**: Static data structures for instant access and zero runtime dependencies.

## Data Coverage (v1.0.0)

| Category | Count | Status |
| :--- | :---: | :--- |
| **Regions** | 31 | 100% (Mainland + Zanzibar) |
| **Districts** | 170 | Fixed & Standardized |
| **Wards** | 4,296 | With official Postcodes |
| **Streets** | 16,684 | Detailed & Linked |

## Getting Started

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  tanzania_geo_data: ^1.0.0
```

Then run:
```bash
flutter pub get
```

## Usage

### 1. Initialize the Service
```dart
import 'package:tanzania_geo_data/tanzania_geo_data.dart';

final geoService = GeoService();
```

### 2. Basic Retrieval
```dart
// Get all regions
List<Region> regions = geoService.getRegions();

// Get districts in a region (e.g., 'Arusha')
List<District> districts = geoService.getDistrictsByRegion('Arusha');

// Get wards in a district (e.g., 'Kinondoni')
List<Ward> wards = geoService.getWardsByDistrict('Kinondoni');

// Get streets in a ward
List<Street> streets = geoService.getStreetsByWard('Kariakoo');
```

### 3. Postcode Lookups (New in v1.0.0)
```dart
// Find a region by postcode
Region? region = geoService.getRegionByPostCode('23'); // Arusha

// Find districts by postcode
List<District> districts = geoService.getDistrictsByPostCode('141'); // Kinondoni

// Find wards by postcode
List<Ward> wards = geoService.getWardsByPostCode('47101');
```

### 4. Categorized Search
```dart
SearchResults results = geoService.search('Dodoma');

print('Found ${results.regions.length} regions');
print('Found ${results.districts.length} districts');
```

## Example Application
Check out the [example](https://github.com/TripoOne/tanzania_geo_data/tree/main/example) directory for a complete Flutter application demonstrating cascaded selection and postcode search.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
