// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import '../localization/current_location.dart';
// import '../localization/location_model.dart';
// import '../localization/location_provider.dart';
// import 'air_bnb_booking.dart';
//
// class BNBSearch extends StatefulWidget {
//   @override
//   _BNBSearchState createState() => _BNBSearchState();
// }
//
// class _BNBSearchState extends State<BNBSearch> {
//   final TextEditingController _searchController = TextEditingController();
//   bool _hasSearched = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSavedLocations();
//   }
//
//   Future<void> _loadSavedLocations() async {
//     final provider = Provider.of<LocationProvider>(context, listen: false);
//     await provider.loadLocations();
//     await _saveLocations(provider.locations);
//   }
//
//   Future<void> _saveLocations(List<Location> locations) async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> locationList = locations.map((loc) => json.encode(loc.toJson())).toList();
//     await prefs.setStringList('saved_locations', locationList);
//   }
//
//   void _onSearchChanged() {
//     Provider.of<LocationProvider>(context, listen: false).filterLocations(_searchController.text);
//     setState(() {
//       _hasSearched = _searchController.text.isNotEmpty;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final locations = Provider.of<LocationProvider>(context).locations;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Search Locations', style: TextStyle(color: Color(0xFF07514A))),
//         backgroundColor: Color(0xFFAAEDDF),
//         centerTitle: true,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: Icon(Icons.location_on_outlined, color: Color(0xFF07514A)),
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 labelText: 'Search by city or state',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.search),
//               ),
//               onChanged: (value) => _onSearchChanged(),
//             ),
//           ),
//           Expanded(
//             child: !_hasSearched
//                 ? Center(child: LocationScreen())
//                 : locations.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//               itemCount: locations.length,
//               itemBuilder: (context, index) {
//                 final location = locations[index];
//                 return Card(
//                   child: ListTile(
//                     leading: location.pictures.isNotEmpty
//                         ? Image.network(location.pictures[0], width: 50, fit: BoxFit.cover)
//                         : Icon(Icons.image, size: 50),
//                     title: Text(location.name),
//                     subtitle: Text('${location.address.city}, ${location.address.state}'),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => BNBBookingPage(
//                            // selectedLocation: location,
//                             bookingId: location.id, // Add booking ID here
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//=============//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart'as http;
import '../localization/current_location.dart';
import '../localization/location_model.dart';
import '../localization/location_provider.dart';
import 'air_bnb_booking.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BNBSearch extends StatefulWidget {
  @override
  _BNBSearchState createState() => _BNBSearchState();
}

class _BNBSearchState extends State<BNBSearch> {
  List<dynamic> locations = [];
  List<dynamic> filteredLocations = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchLocations();
  }

  Future<void> fetchLocations() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://urlocker-api.onrender.com/api/v1/locations/public/all-locations'),
      );

      if (response.statusCode == 200) {
        setState(() {
          locations = json.decode(response.body);
          filteredLocations = locations;
        });
      } else {
        throw Exception('Failed to load locations');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterLocations(String query) {
    setState(() {
      filteredLocations = locations.where((location) {
        final address = location['address'] ?? {};
        final state = (address['state'] ?? '').toString().toLowerCase();
        final city = (address['city'] ?? '').toString().toLowerCase();
        final name = (location['name'] ?? '').toString().toLowerCase();
        final searchLower = query.toLowerCase();

        return state.contains(searchLower) ||
            city.contains(searchLower) ||
            name.contains(searchLower);
      }).toList();
    });
  }

  String formatTime(String? time) {
    if (time == null) return 'Not specified';
    return time;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Find Places',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search destinations',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: filterLocations,
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: filteredLocations.length,
              itemBuilder: (context, index) {
                final location = filteredLocations[index];
                final address = location['address'] ?? {};

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BNBBookingPage(
                          locationId: location['_id'],
                          bookingId: '',
                          selectedLocation: location,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            location['name'] ?? 'Unknown Location',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${address['city'] ?? ''}, ${address['state'] ?? ''}, ${address['country'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.green,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Open: ${formatTime(location['openTime'])}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(width: 16),
                              Icon(
                                Icons.access_time_filled,
                                size: 16,
                                color: Colors.red,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Close: ${formatTime(location['closeTime'])}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Helper class for handling location data
// class LocationData {
//   final String id;
//   final String name;
//   final Address address;
//   final double regularPrice;
//   final String priceCurrency;
//   final String description;
//
//   LocationData({
//     required this.id,
//     required this.name,
//     required this.address,
//     required this.regularPrice,
//     required this.priceCurrency,
//     required this.description,
//   });
//
//   factory LocationData.fromJson(Map<String, dynamic> json) {
//     return LocationData(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       address: Address.fromJson(json['address'] ?? {}),
//       regularPrice: (json['regularPrice'] ?? 0).toDouble(),
//       priceCurrency: json['priceCurrency'] ?? 'AUD',
//       description: json['description'] ?? '',
//     );
//   }
// }
//
// class Address {
//   final String street;
//   final String city;
//   final String state;
//   final String zipCode;
//   final String country;
//
//   Address({
//     required this.street,
//     required this.city,
//     required this.state,
//     required this.zipCode,
//     required this.country,
//   });
//
//   factory Address.fromJson(Map<String, dynamic> json) {
//     return Address(
//       street: json['street'] ?? '',
//       city: json['city'] ?? '',
//       state: json['state'] ?? '',
//       zipCode: json['zipCode'] ?? '',
//       country: json['country'] ?? '',
//     );
//   }
// }

  // @override
  // void dispose() {
  //   _searchController.dispose();
  //   super.dispose();
  // }
