import 'region.dart';
import 'district.dart';
import 'ward.dart';
import 'street.dart';

/// A class that holds categorized search results for Tanzania geo data.
class SearchResults {
  /// Regions matching the search query
  final List<Region> regions;

  /// Districts matching the search query
  final List<District> districts;

  /// Wards matching the search query
  final List<Ward> wards;

  /// Streets matching the search query
  final List<Street> streets;

  const SearchResults({
    this.regions = const [],
    this.districts = const [],
    this.wards = const [],
    this.streets = const [],
  });

  /// Returns true if all result lists are empty
  bool get isEmpty =>
      regions.isEmpty && districts.isEmpty && wards.isEmpty && streets.isEmpty;

  /// Returns the total number of results across all categories
  int get totalCount =>
      regions.length + districts.length + wards.length + streets.length;

  @override
  String toString() {
    return 'SearchResults(regions: ${regions.length}, districts: ${districts.length}, wards: ${wards.length}, streets: ${streets.length})';
  }
}
