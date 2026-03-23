
import 'package:flutter/material.dart';
import 'package:tanzania_geo_data/tanzania_geo_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tanzania Geo Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LocationPickerPage(),
    );
  }
}

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final GeoService _geoService = GeoService();

  String? selectedRegion;
  String? selectedDistrict;
  String? selectedWard;
  String? selectedStreet;

  List<Region> regions = [];
  List<District> districts = [];
  List<Ward> wards = [];
  List<Street> streets = [];

  @override
  void initState() {
    super.initState();
    regions = _geoService.getRegions();
  }

  void _onRegionChanged(String? regionName) {
    setState(() {
      selectedRegion = regionName;
      selectedDistrict = null;
      selectedWard = null;
      selectedStreet = null;
      districts = regionName != null ? _geoService.getDistrictsByRegion(regionName) : [];
      wards = [];
      streets = [];
    });
  }

  void _onDistrictChanged(String? districtName) {
    setState(() {
      selectedDistrict = districtName;
      selectedWard = null;
      selectedStreet = null;
      wards = districtName != null ? _geoService.getWardsByDistrict(districtName) : [];
      streets = [];
    });
  }

  void _onWardChanged(String? wardName) {
    setState(() {
      selectedWard = wardName;
      selectedStreet = null;
      streets = wardName != null ? _geoService.getStreetsByWard(wardName) : [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tanzania Location Picker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Region Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Region'),
              value: selectedRegion,
              items: regions.map((r) => DropdownMenuItem(value: r.name, child: Text(r.name))).toList(),
              onChanged: _onRegionChanged,
            ),
            const SizedBox(height: 16),

            // District Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select District'),
              value: selectedDistrict,
              items: districts.map((d) => DropdownMenuItem(value: d.name, child: Text(d.name))).toList(),
              onChanged: _onDistrictChanged,
              disabledHint: const Text('Select a region first'),
            ),
            const SizedBox(height: 16),

            // Ward Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Ward'),
              value: selectedWard,
              items: wards.map((w) => DropdownMenuItem(value: w.name, child: Text(w.name))).toList(),
              onChanged: _onWardChanged,
              disabledHint: const Text('Select a district first'),
            ),
            const SizedBox(height: 16),

            // Street Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Street'),
              value: selectedStreet,
              items: streets.map((s) => DropdownMenuItem(value: s.name, child: Text(s.name))).toList(),
              onChanged: (val) => setState(() => selectedStreet = val),
              disabledHint: const Text('Select a ward first'),
            ),
            
            const Spacer(),
            if (selectedStreet != null)
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Selection: $selectedStreet, $selectedWard, $selectedDistrict, $selectedRegion',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
