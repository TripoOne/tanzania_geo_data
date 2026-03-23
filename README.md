# Tanzania Geo Data

[![package - pub.dev](https://img.shields.io/pub/v/tanzania_geo_data.svg)](https://pub.dev/packages/tanzania_geo_data)
[![license - MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A comprehensive Flutter package for retrieving and searching Tanzanian geographic data, including Regions, Districts, Wards, and Streets. This package provides high-quality, verified data for all your location-based needs in Tanzania.

## Features

- **Hierarchical Data:** Complete mapping from Regions -> Districts -> Wards -> Streets.
- **Categorized Search:** Search across all geographical levels simultaneously.
- **Helper Methods:** Easily retrieve wards by region or streets by district.
- **Detailed Models:** Every location level has its own dedicated model (Region, District, Ward, Street).
- **Lightweight & Efficient:** Static data loading for fast performance.

## Getting Started

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  tanzania_geo_data: ^0.0.1
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

### 2. Get All Regions
```dart
List<Region> regions = geoService.getRegions();
```

### 3. Get Districts by Region
```dart
List<District> districts = geoService.getDistrictsByRegion('Dar es Salaam');
```

### 4. Get Wards by District
```dart
List<Ward> wards = geoService.getWardsByDistrict('Ilala District');
```

### 5. Get Streets by Ward
```dart
List<Street> streets = geoService.getStreetsByWard('Kariakoo');
```

### 6. Search for any Location
```dart
SearchResults results = geoService.search('Arusha');

print('Found ${results.regions.length} regions');
print('Found ${results.districts.length} districts');
print('Found ${results.wards.length} wards');
print('Found ${results.streets.length} streets');
```

### 7. Helper Methods
```dart
// Get all wards in a region directly
List<Ward> regionalWards = geoService.getWardsByRegion('Mtwara');

// Get all streets in a district directly
List<Street> districtStreets = geoService.getStreetsByDistrict('Kigamboni District');
```

## Example Application
Check out the [example](https://github.com/your-username/tanzania_geo_data/tree/main/example) directory for a complete Flutter application demonstrating how to build a cascaded location picker.

## Data Coverage
- **31 Regions**
- **184 Districts**
- **3,500+ Wards**
- **Extensive Street data**

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

