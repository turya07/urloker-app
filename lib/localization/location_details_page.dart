import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'payment_details.dart';

class InstantBookingPage extends StatefulWidget {
  final String locationId;

  const InstantBookingPage({Key? key, required this.locationId}) : super(key: key);

  @override
  _InstantBookingPageState createState() => _InstantBookingPageState();
}

class _InstantBookingPageState extends State<InstantBookingPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _locationController;
  // Controllers
 // final TextEditingController _locationController = TextEditingController(text: '66b85d3b94f38b18c5b06e36');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bagsController = TextEditingController(
      text: '1');

  // Price constants
  final double pricePerBagPerDay = 7.90;
  final double serviceChargePerDay = 2.6;

  final StripePaymentService _paymentService = StripePaymentService();
  // Date and time variables
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  double totalPrice = 0.0;

  bool _isLoading = false;
  String? _bookingId;
  String? _errorMessage;


  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(text: widget.locationId);
    // Add listener to bags controller
    _bagsController.addListener(_updateTotalPrice);
    // Calculate initial price
    _updateTotalPrice();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _bagsController.removeListener(_updateTotalPrice); // Clean up
    _bagsController.dispose();
    super.dispose();
  }

  void _updateTotalPrice() {
    setState(() {
      int numBags = int.tryParse(_bagsController.text) ?? 1;

      // Calculate the number of days between start and end dates
      int numDays = 1; // Default to 1 day if dates are invalid
      if (_startDate != null && _endDate != null) {
        numDays = _endDate!.difference(_startDate!).inDays + 1; // Add 1 to include the end date
      }

      // Update total price based on the formula
      totalPrice = (numBags * pricePerBagPerDay * numDays) +
          (serviceChargePerDay * numDays);
    });
  }

  // Date picker for start date
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 180)),
     // firstDate: DateTime.now(),
     // lastDate: DateTime(2025),
        lastDate: DateTime.now().add(Duration(days: 365))
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate == null) {
          _endDate = picked; // Set end date same as start date if not set
        }
        _updateTotalPrice();
      });
    }
  }

  Future<void> createBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _bookingId = null;
    });

    try {
      // Validate required fields
      if (_startDate == null || _endDate == null ||
          _startTime == null || _endTime == null) {
        throw Exception('Please select all date and time fields');
      }

      // Validate bags count
      int bagsCount = int.tryParse(_bagsController.text) ?? 0;
      if (bagsCount <= 0) {
        throw Exception('Please enter a valid number of bags');
      }

      // Calculate the final price
      int numberOfDays = _endDate!.difference(_startDate!).inDays + 1;
      double finalPrice = (bagsCount * pricePerBagPerDay * numberOfDays) +
          (serviceChargePerDay * numberOfDays);

      // Prepare booking data
      final bookingData = {
        'location': _locationController.text,
        'startDate': DateFormat('yyyy-MM-dd').format(_startDate!),
        'startTime': '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}',
        'endDate': DateFormat('yyyy-MM-dd').format(_endDate!),
        'endTime': '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}',
        'totalPricePaid': finalPrice,
        'numberOfBags': bagsCount,
        'status': 'pending',
        'guest': {
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text
        }
      };

      // Step 1: Create Initial Booking
      final bookingResponse = await http.post(
        Uri.parse('https://urlocker-api.onrender.com/api/v1/bookings/instant-booking'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(bookingData),
      );

      if (bookingResponse.statusCode != 201) {
        final errorBody = json.decode(bookingResponse.body);
        throw Exception(
            errorBody['message'] ?? 'Booking creation failed with status ${bookingResponse.statusCode}'
        );
      }

      final bookingResult = json.decode(bookingResponse.body);
      final bookingId = bookingResult['booking']['_id'];

      setState(() {
        _isLoading = false;
        _bookingId = bookingId;
      });

      // Show success dialog first
      _showSuccessDialog(bookingId, finalPrice);

    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      _showErrorDialog(e.toString());
    }
  }

  void _showSuccessDialog(String bookingId, double finalPrice) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your booking has been confirmed!'),
              SizedBox(height: 8),
              Text('Booking ID: $bookingId'),
              SizedBox(height: 8),
              Text('Number of Bags: ${_bagsController.text}'),
              Text('Total Price: A\$${totalPrice.toStringAsFixed(2)}'),
              SizedBox(height: 16),
              Text('Please proceed to payment to complete your booking.',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Proceed to Payment'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to payment screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                            amount: finalPrice,
                            bookingId: bookingId
                        )
                    )
                );

                // Reset form after navigation
                _formKey.currentState?.reset();
                setState(() {
                  _startDate = null;
                  _endDate = null;
                  _startTime = null;
                  _endTime = null;
                  totalPrice = 0.0;
                  _bagsController.text = '1';
                });
              },
            ),
          ],
        );
      },
    );
  }


  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Date picker for end date
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        _updateTotalPrice();
      });
    }
  }

  // Time picker methods
  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _endTime) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instant Booking'),
        backgroundColor: Color(0xFF39C7B6),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF39C7B6).withOpacity(0.1), Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
             Card(
               elevation: 4,
               child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking Details',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),

                          // Bags Counter with + - buttons
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _bagsController,
                                  decoration: InputDecoration(
                                    labelText: 'Number of Bags',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.luggage),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (value) =>
                                  value!.isEmpty
                                      ? 'Please enter number of bags'
                                      : null,
                                ),
                              ),
                              SizedBox(width: 8),
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    int currentValue = int.tryParse(
                                        _bagsController.text) ?? 1;
                                    if (currentValue > 1) {
                                      _bagsController.text =
                                          (currentValue - 1).toString();
                                      _updateTotalPrice();
                                    }
                                  });

                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  int currentValue = int.tryParse(
                                      _bagsController.text) ?? 1;
                                  _bagsController.text =
                                      (currentValue + 1).toString();
                                  _updateTotalPrice();
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 16),

                          // Price Information Card
                          Card(
                            elevation: 4,
                            child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Price Details',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                        'Charge per luggage: A\$$pricePerBagPerDay per bag/day'),
                                    Text(
                                        'Service charge per day: A\$$serviceChargePerDay'),
                                    Divider(),
                                    Text(
                                      'Total Price: A\$${totalPrice.toStringAsFixed(
                                          2)}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF07514A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ),

                          SizedBox(height: 16),

                          // Date and Time Selection
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: Icon(Icons.calendar_today),
                                  label: Text(_startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : 'Start Date'),
                                  onPressed: () => _selectStartDate(context),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: Icon(Icons.access_time),
                                  label: Text(_startTime != null
                                      ? _startTime!.format(context)
                                      : 'Start Time'),
                                  onPressed: () => _selectStartTime(context),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: Icon(Icons.calendar_today),
                                  label: Text(_endDate != null
                                      ? DateFormat('yyyy-MM-dd').format(_endDate!)
                                      : 'End Date'),
                                  onPressed: () => _selectEndDate(context),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: Icon(Icons.access_time),
                                  label: Text(_endTime != null
                                      ? _endTime!.format(context)
                                      : 'End Time'),
                                  onPressed: () => _selectEndTime(context),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
             ),
                SizedBox(height: 16),
                // Personal Information Card
             Card(
               elevation: 4,
               child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) =>
                            value!.isEmpty
                                ? 'Please enter name'
                                : null,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              }
                              final emailRegex = RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (!emailRegex.hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.phone),
                            ),
                            keyboardType: TextInputType.phone,
                           // validator: (value) => value!.isEmpty ? 'Please enter phone number' : null,
                          ),
                        ],
                      ),
                    ),
             ),

                SizedBox(height: 24),
                // Submit Button
                ElevatedButton(
                  onPressed: _isLoading ? null : createBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFAAEDDF),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _isLoading ? 'Processing...' : 'Create Booking',
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//================================//
//================================//
