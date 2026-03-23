import 'package:flutter_test/flutter_test.dart';
import 'package:tanzania_geo_data/tanzania_geo_data.dart';

void main() {
  final geoService = GeoService();

  test('getRegions returns regions including Arusha and Dar es Salaam', () {
    final regions = geoService.getRegions();
    expect(regions, isNotEmpty);
    expect(regions.any((r) => r.name == 'Arusha'), isTrue);
    expect(regions.any((r) => r.name == 'Dar es Salaam'), isTrue);
  });

  test('getDistrictsByRegion returns districts for Arusha', () {
    final districts = geoService.getDistrictsByRegion('Arusha');
    expect(districts, isNotEmpty);
    expect(districts.any((d) => d.name == 'Arusha City'), isTrue);
  });

  test('getWardsByDistrict returns wards for Arusha City', () {
    // Note: I need to verify a correct district name from the data
    // Arusha City exists in districts.json
    final wards = geoService.getWardsByDistrict('Arusha City');
    // Using a ward that likely exists or just checking for non-empty
    expect(wards, isNotEmpty);
  });

  test('search finds Tanzania regions and districts', () {
    final results = geoService.search('Dar');
    expect(results.isEmpty, isFalse);
    expect(results.regions.any((r) => r.name == 'Dar es Salaam'), isTrue);
  });

  test('getStreetsByWard returns streets for a known ward', () {
    final streets = geoService.getStreetsByWard('Mkundi');
    expect(streets, isNotEmpty);
    expect(streets.any((s) => s.name == 'Nakachindu'), isTrue);
  });

  test('getWardsByRegion returns wards for a given region', () {
    final wards = geoService.getWardsByRegion('Mtwara');
    expect(wards, isNotEmpty);
    // Chawi is in Mtwara District, which is in Mtwara region
    expect(wards.any((w) => w.name == 'Chawi'), isTrue);
  });

  test('getStreetsByDistrict returns streets for a given district', () {
    final streets = geoService.getStreetsByDistrict('Mtwara District');
    expect(streets, isNotEmpty);
    // Mkomo is in Chawi ward, which is in Mtwara District
    expect(streets.any((s) => s.name == 'Mkomo'), isTrue);
  });
}
