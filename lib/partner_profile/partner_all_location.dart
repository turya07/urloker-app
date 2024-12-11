import 'package:flutter/material.dart';
import 'package:flutter_stripe_tutorial/partner_profile/partner_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Location {
  final String id;
  final String name;
  final String description;
  final double regularPrice;
  final String priceCurrency;
  final String openTime;
  final String closeTime;
  final List pictures;
  final Address address;
  final int capacity;
  final bool canStoreKeys;
  final double keyStoragePricePerHour;

  Location({
    required this.id,
    required this.name,
    required this.description,
    required this.regularPrice,
    required this.priceCurrency,
    required this.openTime,
    required this.closeTime,
    required this.pictures,
    required this.address,
    required this.capacity,
    required this.canStoreKeys,
    required this.keyStoragePricePerHour,
  });

  factory Location.fromJson(Map json) {
    return Location(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      regularPrice: json['regularPrice'].toDouble(),
      priceCurrency: json['priceCurrency'],
      openTime: json['openTime'],
      closeTime: json['closeTime'],
      pictures: List.from(json['pictures']),
      address: Address.fromJson(json['address']),
      capacity: json['capacity'],
      canStoreKeys: json['canStoreKeys'],
      keyStoragePricePerHour: json['keyStoragePricePerHour'].toDouble(),
    );
  }
}

class Address {
  final String street;
  final String city;
  final String state;
  final String country;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
  });

  factory Address.fromJson(Map json) {
    return Address(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
    );
  }
}
class AuthManager {
  static const String TOKEN_KEY = 'auth_token';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(TOKEN_KEY, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(TOKEN_KEY);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(TOKEN_KEY);
  }
}
class PartnerLocationsScreen extends StatefulWidget {
  const PartnerLocationsScreen({super.key});

  @override
  State<PartnerLocationsScreen> createState() => _PartnerLocationsScreenState();
}

class _PartnerLocationsScreenState extends State<PartnerLocationsScreen> {
  List<Location> _locations = [];
  List<Location> _filteredLocations = [];
  bool _isLoading = true;
  String _errorMessage = '';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchLocations();
    _searchController.addListener(_filterLocations);
  }

  void _filterLocations() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLocations = _locations.where((location) {
        return location.name.toLowerCase().contains(query) ||
            location.address.street.toLowerCase().contains(query) ||
            location.address.city.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _fetchLocations() async {
    try {
      final token = await AuthManager.getToken();

      if (token == null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => PartnerLoginPage()),
              (Route<dynamic> route) => false,
        );
        return;
      }

      final response = await http.get(
        Uri.parse('https://urlocker-api.onrender.com/api/v1/locations/my-locations'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _locations = data.map((json) => Location.fromJson(json)).toList();
          _filteredLocations = _locations;
          _isLoading = false;
        });
      } else if (response.statusCode == 401) {
        await AuthManager.removeToken();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => PartnerLoginPage()),
              (Route<dynamic> route) => false,
        );
      } else {
        setState(() {
          _errorMessage = 'Failed to load locations';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  String _formatTime(String time) {
    try {
      final timeFormat = DateFormat('HH:mm');
      final dateTime = timeFormat.parse(time);
      return DateFormat('h:mm a').format(dateTime);
    } catch (e) {
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = '';
                  });
                  _fetchLocations();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search locations...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchLocations,
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: _filteredLocations.length,
          itemBuilder: (context, index) {
            final location = _filteredLocations[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Carousel
                  if (location.pictures.isNotEmpty)
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(location.pictures[0]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                location.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${location.priceCurrency} \$${location.regularPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          location.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${location.address.street}, ${location.address.city}, ${location.address.state}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${_formatTime(location.openTime)} - ${_formatTime(location.closeTime)}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.people, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Capacity: ${location.capacity}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        if (location.canStoreKeys) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.key, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'Key Storage: ${location.priceCurrency} ${location.keyStoragePricePerHour}/hour',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}