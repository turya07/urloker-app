import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'current_location.dart';
import 'location_details_page.dart';
import 'location_provider.dart';
import 'location_model.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLocations();
  }

  Future<void> _loadSavedLocations() async {
    final provider = Provider.of<LocationProvider>(context, listen: false);
    await provider.loadLocations();  // Load from API
    await _saveLocations(provider.locations);  // Save data to Shared Preferences
  }

  Future<void> _saveLocations(List<Location> locations) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> locationList = locations.map((loc) => json.encode(loc.toJson())).toList();
    await prefs.setStringList('saved_locations', locationList);
  }

  void _onSearchChanged() {
    Provider.of<LocationProvider>(context, listen: false).filterLocations(_searchController.text);
    setState(() {
      _hasSearched = _searchController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locations = Provider.of<LocationProvider>(context).locations;

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Locations',style: TextStyle(color: Color(0xFF07514A)),),
        backgroundColor: Color(0xFFAAEDDF),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(Icons.location_on_outlined,color: Color(0xFF07514A)),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by city or state',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => _onSearchChanged(),
            ),
          ),
          Expanded(
            child: !_hasSearched
                ? Center(child: LocationScreen(),)
                : locations.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                final location = locations[index];
                return Card(
                  child: ListTile(
                    leading: location.pictures.isNotEmpty
                        ? Image.network(location.pictures[0], width: 50, fit: BoxFit.cover)
                        : Icon(Icons.image, size: 50),
                    title: Text(location.name),
                    subtitle: Text('${location.address.city}, ${location.address.state}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InstantBookingPage(
                            locationId: location.id, // Pass the location ID here
                          ),
                        ),
                      );
                    },
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

//==============================================//



// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'current_location.dart';
// import 'location_details_page.dart';
// import 'location_provider.dart';
// import 'location_model.dart';
//
// class SearchPage extends StatefulWidget {
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//   final TextEditingController _searchController = TextEditingController();
//   bool _hasSearched = false;
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSavedLocations();
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _loadSavedLocations() async {
//     setState(() => _isLoading = true);
//     try {
//       final provider = Provider.of<LocationProvider>(context, listen: false);
//       await provider.loadLocations();
//       await _saveLocations(provider.locations);
//     } catch (e) {
//       // Handle error
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading locations: ${e.toString()}')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> _saveLocations(List<Location> locations) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       List<String> locationList = locations
//           .where((loc) => loc.address.canStoreKeys) // Only save locations with canStoreKeys = true
//           .map((loc) => json.encode(loc.toJson()))
//           .toList();
//       await prefs.setStringList('saved_locations', locationList);
//     } catch (e) {
//       print('Error saving locations: $e');
//     }
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
//         title: Text(
//           'Search Locations',
//           style: TextStyle(color: Color(0xFF07514A)),
//         ),
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
//             child: _isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : !_hasSearched
//                 ? Center(child: LocationScreen())
//                 : locations.isEmpty
//                 ? Center(
//               child: Text('No locations found with key storage capability'),
//             )
//                 : ListView.builder(
//               itemCount: locations.length,
//               itemBuilder: (context, index) {
//                 final location = locations[index];
//                 return Card(
//                   margin: EdgeInsets.symmetric(
//                     horizontal: 8.0,
//                     vertical: 4.0,
//                   ),
//                   child: ListTile(
//                     leading: location.pictures.isNotEmpty
//                         ? Image.network(
//                       location.pictures[0],
//                       width: 50,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Icon(Icons.image, size: 50);
//                       },
//                     )
//                         : Icon(Icons.image, size: 50),
//                     title: Text(
//                       location.name,
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('${location.address.city}, ${location.address.state}'),
//                         Text(
//                           '${location.priceCurrency} ${location.regularPrice.toStringAsFixed(2)}',
//                           style: TextStyle(color: Color(0xFF07514A)),
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => InstantBookingPage(),
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