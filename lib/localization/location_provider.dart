import 'package:flutter/material.dart';
import 'location_service.dart';
import 'location_model.dart';

class LocationProvider with ChangeNotifier {
  List<Location> _locations = [];
  List<Location> get locations => _locations;

  Future<void> loadLocations() async {
    try {
      List<dynamic> locationData = await LocationService().fetchLocations();
      _locations = locationData.map((json) => Location.fromJson(json)).toList();
      notifyListeners();
    } catch (error) {
      print('Error fetching locations: $error');
    }
  }

  void filterLocations(String query) {
    _locations = _locations
        .where((location) =>
    location.address.city.toLowerCase().contains(query.toLowerCase()) ||
        location.address.state.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }
}

//====================================//

// import 'package:flutter/material.dart';
// import 'location_service.dart';
// import 'location_model.dart';
//
// class LocationProvider with ChangeNotifier {
//   List<Location> _allLocations = []; // Store all locations
//   List<Location> _filteredLocations = []; // Store filtered locations
//
//   // Getter for filtered locations
//   List<Location> get locations => _filteredLocations;
//
//   Future<void> loadLocations() async {
//     try {
//       List<dynamic> locationData = await LocationService().fetchLocations();
//
//       // Store all locations
//       _allLocations = locationData.map((json) => Location.fromJson(json)).toList();
//
//       // Initially filter to show only locations with canStoreKeys = true
//       _filteredLocations = _allLocations.where((location) =>
//       location.address.canStoreKeys == true
//       ).toList();
//
//       notifyListeners();
//     } catch (error) {
//       print('Error fetching locations: $error');
//       // You might want to rethrow the error or handle it differently
//       _allLocations = [];
//       _filteredLocations = [];
//       notifyListeners();
//     }
//   }
//
//   void filterLocations(String query) {
//     if (query.isEmpty) {
//       // If no search query, show all locations with canStoreKeys = true
//       _filteredLocations = _allLocations.where((location) =>
//       location.address.canStoreKeys == true
//       ).toList();
//     } else {
//       // Filter by both search query AND canStoreKeys
//       _filteredLocations = _allLocations.where((location) =>
//       location.address.canStoreKeys == true && // Must have canStoreKeys = true
//           (location.address.city.toLowerCase().contains(query.toLowerCase()) ||
//               location.address.state.toLowerCase().contains(query.toLowerCase()))
//       ).toList();
//     }
//     notifyListeners();
//   }
//
//   // Optional: Add a method to get the count of available locations
//   int get locationCount => _filteredLocations.length;
//
//   // Optional: Add a method to clear filters
//   void clearFilters() {
//     _filteredLocations = _allLocations.where((location) =>
//     location.address.canStoreKeys == true
//     ).toList();
//     notifyListeners();
//   }
// }