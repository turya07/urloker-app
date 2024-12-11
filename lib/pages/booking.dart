import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<Map<String, dynamic>> orders = [];
  List<Map<String, dynamic>> filteredOrders = [];
  bool isLoading = true;
  String? error;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchTokenAndOrders();
  }

  Future<void> fetchTokenAndOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null) {
        await fetchOrders(token);
      } else {
        setState(() {
          error = 'Authentication token not found. Please log in again.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error retrieving authentication token: $e';
        isLoading = false;
      });
    }
  }

  Future<void> fetchOrders(String token) async {
    try {
      final response = await http.get(
        Uri.parse('https://urlocker-api.onrender.com/api/v1/analytics/my-earnings/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        setState(() {
          if (decodedData is Map<String, dynamic> && decodedData.containsKey('months')) {
            final months = decodedData['months'] as List;
            orders = [];
            for (var month in months) {
              if (month['bookings'] != null && month['bookings'] is List) {
                for (var booking in month['bookings']) {
                  String formatDateTime(String? dateTimeString) {
                    if (dateTimeString == null || dateTimeString.isEmpty) {
                      return 'N/A';
                    }
                    try {
                      final parsedDate = DateTime.parse(dateTimeString);
                      return DateFormat('yyyy-MM-dd HH:mm').format(parsedDate.toLocal());
                    } catch (e) {
                      return 'N/A';
                    }
                  }

                  orders.add({
                    'locationName': booking['locationName'] ?? 'N/A',
                    'status': booking['status'] ?? 'N/A',
                    'month': month['month'] ?? 'N/A',
                    'monthStart': formatDateTime(month['monthStart']),
                    'monthEnd': formatDateTime(month['monthEnd']),
                    'totalLuggageCount': month['totalLuggageCount'] ?? 'N/A',
                    'pending': month['pending'] ?? 'N/A',
                    'earned': month['earned'] ?? 0.0,
                  });
                }
              }
            }
            filteredOrders = List.from(orders);
          } else {
            error = 'Unexpected data format';
          }
          isLoading = false;
        });
      }else {
        setState(() {
          error = 'Failed to load orders: ${response.statusCode}\nResponse: ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }

  void filterOrders(String query) {
    setState(() {
      searchQuery = query;
      filteredOrders = orders
          .where((order) =>
      order['month'].toString().toLowerCase().contains(query.toLowerCase()) ||
          order['locationName'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  error = null;
                });
                fetchTokenAndOrders();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by Month or Location',
                prefixIcon: Icon(Icons.search,color: Color(0xFF07514A)),
                border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF6DEDE2),width: 1,),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: filterOrders,
            ),
          ),
          Expanded(
            child: filteredOrders.isEmpty
                ? const Center(
              child: Text(
                'No matching orders found',
                style: TextStyle(fontSize: 16),
              ),
            )
                : RefreshIndicator(
              onRefresh: () async {
                final token = await SharedPreferences.getInstance().then((prefs) => prefs.getString('auth_token'));
                if (token != null) {
                  await fetchOrders(token);
                }
              },
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  return Card(
                    elevation: 6,
                    shadowColor: const Color(0xFF6DEDE2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  order['locationName'] ?? 'Location not available',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF07514A),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: order['status']?.toString().toLowerCase() == 'pending'
                                      ? Colors.red.shade100
                                      : order['status']?.toString().toLowerCase() == 'paid'
                                      ? Colors.green.shade100
                                      : Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  (order['status'] ?? 'Unknown').toString().toUpperCase(),
                                  style: TextStyle(
                                    color: order['status']?.toString().toLowerCase() == 'pending'
                                        ? Colors.red.shade800
                                        : order['status']?.toString().toLowerCase() == 'paid'
                                        ? Colors.green.shade800
                                        : Colors.red.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow('Month', order['month']?.toString() ?? 'N/A'),
                          _buildDetailRow('Month Start', order['monthStart']?.toString() ?? 'N/A'),
                          _buildDetailRow('Month End', order['monthEnd']?.toString() ?? 'N/A'),
                          _buildDetailRow('Total Luggage', order['totalLuggageCount']?.toString() ?? 'N/A'),
                          _buildDetailRow('Pending', order['pending']?.toString() ?? 'N/A'),
                          _buildDetailRow(
                            'Earned',
                            'AUD \$${(order['earned'] ?? 0.0).toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
