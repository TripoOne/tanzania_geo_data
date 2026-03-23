import 'package:tanzania_geo_data/src/models/region.dart';
import 'package:tanzania_geo_data/src/models/district.dart';
import 'package:tanzania_geo_data/src/models/ward.dart';
import 'package:tanzania_geo_data/src/models/street.dart';
import 'package:tanzania_geo_data/src/models/search_results.dart';
import 'package:tanzania_geo_data/src/data/regions.dart';
import 'package:tanzania_geo_data/src/data/districts.dart';
import 'package:tanzania_geo_data/src/data/wards.dart';
import 'package:tanzania_geo_data/src/data/streets.dart';

class GeoService {
  /// Returns all regions in Tanzania
  List<Region> getRegions() {
    return tanzaniaRegions;
  }

  /// Returns all districts for a given region name
  List<District> getDistrictsByRegion(String regionName) {
    return tanzaniaDistricts
        .where((d) => d.regionName.toLowerCase() == regionName.toLowerCase())
        .toList();
  }

  /// Returns all wards for a given district name
  List<Ward> getWardsByDistrict(String districtName) {
    return tanzaniaWards
        .where((w) => w.districtName.toLowerCase() == districtName.toLowerCase())
        .toList();
  }

  /// Returns all wards for a given region name
  List<Ward> getWardsByRegion(String regionName) {
    final districts = getDistrictsByRegion(regionName).map((d) => d.name.toLowerCase()).toSet();
    return tanzaniaWards
        .where((w) => districts.contains(w.districtName.toLowerCase()))
        .toList();
  }

  /// Returns all streets for a given ward name
  List<Street> getStreetsByWard(String wardName) {
    return tanzaniaStreets
        .where((s) => s.wardName.toLowerCase() == wardName.toLowerCase())
        .toList();
  }

  /// Returns all streets for a given district name
  List<Street> getStreetsByDistrict(String districtName) {
    final wards = getWardsByDistrict(districtName).map((w) => w.name.toLowerCase()).toSet();
    return tanzaniaStreets
        .where((s) => wards.contains(s.wardName.toLowerCase()))
        .toList();
  }

  /// Searches for regions, districts, wards, or streets matching the query.
  /// Returns categorized [SearchResults].
  SearchResults search(String query) {
    final lowerQuery = query.toLowerCase();

    final regions = tanzaniaRegions
        .where((r) => r.name.toLowerCase().contains(lowerQuery))
        .toList();
    final districts = tanzaniaDistricts
        .where((d) => d.name.toLowerCase().contains(lowerQuery))
        .toList();
    final wards = tanzaniaWards
        .where((w) => w.name.toLowerCase().contains(lowerQuery))
        .toList();
    final streets = tanzaniaStreets
        .where((s) => s.name.toLowerCase().contains(lowerQuery))
        .toList();

    return SearchResults(
      regions: regions,
      districts: districts,
      wards: wards,
      streets: streets,
    );
  }

  /// Returns a region by its post code
  Region? getRegionByPostCode(String postCode) {
    try {
      return tanzaniaRegions.firstWhere(
        (r) => r.postCode == postCode,
      );
    } catch (_) {
      return null;
    }
  }

  /// Returns a list of districts by their post code
  List<District> getDistrictsByPostCode(String postCode) {
    return tanzaniaDistricts
        .where((d) => d.postCode == postCode)
        .toList();
  }

  /// Returns a list of wards by their post code
  List<Ward> getWardsByPostCode(String postCode) {
    return tanzaniaWards
        .where((w) => w.postCode == postCode)
        .toList();
  }
}
