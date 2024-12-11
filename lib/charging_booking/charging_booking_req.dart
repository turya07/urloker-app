import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'charging_api_service.dart';
import 'charging_payment.dart';

class ApiService {
  static const String baseUrl = 'https://urlocker-api.onrender.com/api/v1';

  Future<BookingResponse> createBooking(BookingRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/charging/bookings'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return BookingResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create booking: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating booking: $e');
    }
  }

  // Fetch locations from the API
  Future<List<Location>> fetchLocations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/locations/public/all-locations'),
      );
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        print('Raw API response: $data'); // Debug log

        return data
            .where((location) {
          // Safely check for hasChargingStation
          return location['hasChargingStation'] == true;
        })
            .map((location) {
          try {
            return Location.fromJson(location);
          } catch (e) {
            print('Error parsing location: $location');
            print('Error details: $e');
            // Return null for invalid locations
            return null;
          }
        })
            .whereType<Location>() // Filter out null values
            .toList();
      } else {
        throw Exception('Failed to load locations: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching locations: $e');
      throw Exception('Failed to load locations: $e');
    }
  }
}

class Location {
  final String id;
  final String name;
  Location({required this.id, required this.name});
  factory Location.fromJson(Map<String, dynamic> json) {
    var id = json['id'];
    var name = json['name'];
    return Location(
      id: id?.toString() ?? '', // Convert to string or use empty string if null
      name: name?.toString() ?? '', // Convert to string or use empty string if null
    );
  }
}

class ChargingPoint extends StatefulWidget {
  @override
  _ChargingPointState createState() => _ChargingPointState();
}

class _ChargingPointState extends State<ChargingPoint> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();

  bool _isLoading = false;
  int _duration = 5;
  double get currentTotalPrice {
    return _duration == 5 ? 6.00 : 10.00;
  }

  List<Location> _locations = [];
  Location? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  // Load locations from the API
  Future<void> _loadLocations() async {
    try {
      final locations = await _apiService.fetchLocations();
      setState(() {
        _locations = locations;
      });
    } catch (e) {
      // Handle error (e.g., show error message)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error loading locations: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Charging Booking Point'),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _nameController,
                              label: 'Full Name',
                              icon: Icons.person_outline,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            _buildTextField(
                              controller: _emailController,
                              label: 'Email Address',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value?.isEmpty ?? true || !value!.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            _buildTextField(
                              controller: _phoneController,
                              label: 'Phone Number',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            _buildChargingStationDropdown(),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildDateTimePicker(
                              title: 'Date',
                              value: DateFormat('MMMM dd, yyyy').format(_selectedDate),
                              icon: Icons.calendar_today,
                              onTap: _selectDate,
                            ),
                            Divider(height: 24),
                            _buildDateTimePicker(
                              title: 'Start Time',
                              value: _startTime.format(context),
                              icon: Icons.access_time,
                              onTap: _selectTime,
                            ),
                            SizedBox(height: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Duration: $_duration minutes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                SliderTheme(
                                  data: SliderThemeData(
                                    activeTrackColor: Color(0xFF39C7B6),
                                    thumbColor: Color(0xFF6DEDE2),
                                    overlayColor: Color(0xFF6DEDE2).withOpacity(0.2),
                                    valueIndicatorColor:Color(0xFF07514A),
                                  ),
                                  child: Slider(
                                    value: _duration.toDouble(),
                                    min: 5,
                                    max: 10,
                                    divisions: 1,
                                    label: '$_duration min',
                                    onChanged: (double value) {
                                      setState(() {
                                        _duration = value.round();
                                      });
                                    },
                                  ),
                                ),
                                Text('Total Price: A\$${currentTotalPrice.toStringAsFixed(2)}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Color(0xFF07514A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                          ),
                        )
                            : Text(
                          'Confirm Booking',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4, bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF07514A),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  // Charging Station Dropdown
  Widget _buildChargingStationDropdown() {
    return _locations.isEmpty
        ? CircularProgressIndicator()
        : DropdownButton<Location>(
      value: _selectedLocation,
      hint: Text('Select Charging Station'),
      isExpanded: true,
      onChanged: (Location? newLocation) {
        setState(() {
          _selectedLocation = newLocation;
        });
      },
      items: _locations.map((Location location) {
        return DropdownMenuItem<Location>(
          value: location,
          child: Text(location.name),
        );
      }).toList(),
    );
  }

  Widget _buildDateTimePicker({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Keeping the existing methods unchanged
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 180)),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final startDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _startTime.hour,
        _startTime.minute,
      );

      final endDateTime = startDateTime.add(Duration(minutes: _duration));

      final request = BookingRequest(
        guest: Guest(
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
        ),
        location: '66e337f7e9b5ee8d3f30dba6',
        startDate: DateFormat('yyyy-MM-dd').format(startDateTime),
        startTime: DateFormat('HH:mm').format(startDateTime),
        endDate: DateFormat('yyyy-MM-dd').format(endDateTime),
        endTime: DateFormat('HH:mm').format(endDateTime),
        durationInMinutes: _duration,
        dropOffTime: startDateTime.toUtc().toIso8601String(),
        pickUpTime: endDateTime.toUtc().toIso8601String(),
        notes: 'Booking for $_duration minutes of charging.',
      );

      final response = await _apiService.createBooking(request);

      if (mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChargingPaymentScreen(amount: currentTotalPrice,),));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking successful! ID: ${response.data.bookingId}'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
