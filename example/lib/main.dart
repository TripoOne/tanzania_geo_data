
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

  void _searchByPostCode(String code) {
    if (code.isEmpty) return;

    final district = _geoService.getDistrictsByPostCode(code);
    final ward = _geoService.getWardsByPostCode(code);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Postcode Results: $code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (district.isNotEmpty) ...[
              const Text('Districts:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...district.map((d) => Text('• ${d.name} (${d.regionName})')),
              const SizedBox(height: 8),
            ],
            if (ward.isNotEmpty) ...[
              const Text('Wards:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...ward.map((w) => Text('• ${w.name} (${w.districtName})')),
            ],
            if (district.isEmpty && ward.isEmpty) const Text('No locations found for this postcode.'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tanzania Geo Data v1.0.0'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.map), text: 'Cascaded Selection'),
              Tab(icon: Icon(Icons.pin_drop), text: 'Postcode Search'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCascadedPicker(),
            _buildPostCodeSearch(),
          ],
        ),
      ),
    );
  }

  Widget _buildCascadedPicker() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Select Region', border: OutlineInputBorder()),
            value: selectedRegion,
            items: regions.map((r) => DropdownMenuItem(value: r.name, child: Text(r.name))).toList(),
            onChanged: _onRegionChanged,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Select District', border: OutlineInputBorder()),
            value: selectedDistrict,
            items: districts.map((d) => DropdownMenuItem(value: d.name, child: Text(d.name))).toList(),
            onChanged: _onDistrictChanged,
            disabledHint: const Text('Select a region first'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Select Ward', border: OutlineInputBorder()),
            value: selectedWard,
            items: wards.map((w) => DropdownMenuItem(value: w.name, child: Text(w.name))).toList(),
            onChanged: _onWardChanged,
            disabledHint: const Text('Select a district first'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Select Street', border: OutlineInputBorder()),
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
                  'Selected: $selectedStreet, $selectedWard, $selectedDistrict, $selectedRegion',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPostCodeSearch() {
    final controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Enter a Tanzanian Postcode to find its District or Ward.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Postcode',
              hintText: 'e.g., 141, 47101',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            keyboardType: TextInputType.number,
            onSubmitted: _searchByPostCode,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _searchByPostCode(controller.text),
            child: const Text('Search Locations'),
          ),
          const Spacer(),
          const Text('Try "141" for Kinondoni or "23" for Arusha.'),
        ],
      ),
    );
  }
}
