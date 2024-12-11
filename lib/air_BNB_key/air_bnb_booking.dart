// import 'package:flutter/material.dart';
// import 'package:flutter_stripe_tutorial/localization/location_model.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:intl/intl.dart';
//
// class BNBBookingPage extends StatefulWidget {
//   final String bookingId;
//
//   const BNBBookingPage({Key? key, required this.bookingId, required Location selectedLocation,}) : super(key: key);
//
//   @override
//   _BNBBookingPageState createState() => _BNBBookingPageState();
// }
//
// class _BNBBookingPageState extends State<BNBBookingPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _guestNameController = TextEditingController();
//   final _guestEmailController = TextEditingController();
//   final _pickupNameController = TextEditingController();
//   final _pickupEmailController = TextEditingController();
//
//   DateTime? _dropOffDate;
//   TimeOfDay? _dropOffTime;
//   DateTime? _pickUpDate;
//   TimeOfDay? _pickUpTime;
//
//   bool _isLoading = false;
//
//   Future<void> _createBooking() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _isLoading = true);
//
//     try {
//       final response = await http.post(
//         Uri.parse('https://urlocker-api.onrender.com/api/v1/airbnb-keys/bookings'),
//         headers: {'Content-Type': 'application/json',
//           'Accept': 'application/json', },
//         body: jsonEncode({
//           "bookingId": widget.bookingId,
//           "guest": {
//             "name": _guestNameController.text,
//             "email": _guestEmailController.text,
//           },
//           "keyStorage": {
//             "keyPickUpBy": {
//               "name": _pickupNameController.text,
//               "email": _pickupEmailController.text,
//             },
//             "keyDropOffTime": _dropOffDate?.toIso8601String(),
//             "keyPickUpTime": _pickUpDate?.toIso8601String(),
//           }
//         }),
//       );
//
//       if (response.statusCode == 201 || response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Booking created successfully!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         _formKey.currentState!.reset();
//       } else {
//         throw Exception('Failed to create booking: ${response.body}');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error creating booking: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> _selectDate(BuildContext context, bool isDropOff) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(Duration(days: 365)),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: Colors.blue,
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Colors.black,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       setState(() {
//         if (isDropOff) {
//           _dropOffDate = picked;
//         } else {
//           _pickUpDate = picked;
//         }
//       });
//     }
//   }
//
//   Future<void> _selectTime(BuildContext context, bool isDropOff) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             timePickerTheme: TimePickerThemeData(
//               backgroundColor: Colors.white,
//               hourMinuteTextColor: Colors.blue,
//               dayPeriodTextColor: Colors.blue,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       setState(() {
//         if (isDropOff) {
//           _dropOffTime = picked;
//         } else {
//           _pickUpTime = picked;
//         }
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create Booking'),
//         backgroundColor: Colors.blue,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Guest Details Section
//                 _buildSectionTitle('Agent Details', Icons.person),
//                 _buildInputField(
//                   controller: _guestNameController,
//                   label: 'Agent Name',
//                   icon: Icons.person_outline,
//                   validator: (value) =>
//                   value?.isEmpty ?? true ? 'Please enter guest name' : null,
//                 ),
//                 SizedBox(height: 16),
//                 _buildInputField(
//                   controller: _guestEmailController,
//                   label: 'Agent Email',
//                   icon: Icons.email_outlined,
//                   validator: (value) {
//                     if (value?.isEmpty ?? true) return 'Please enter guest email';
//                     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                         .hasMatch(value!)) {
//                       return 'Please enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//
//                 SizedBox(height: 32),
//
//                 // Key Pickup Details Section
//                 _buildSectionTitle('Key Pickup Details', Icons.key),
//                 _buildInputField(
//                   controller: _pickupNameController,
//                   label: 'Pickup Person Name',
//                   icon: Icons.person_outline,
//                   validator: (value) =>
//                   value?.isEmpty ?? true ? 'Please enter pickup person name' : null,
//                 ),
//                 SizedBox(height: 16),
//                 _buildInputField(
//                   controller: _pickupEmailController,
//                   label: 'Pickup Person Email',
//                   icon: Icons.email_outlined,
//                   validator: (value) {
//                     if (value?.isEmpty ?? true) return 'Please enter pickup person email';
//                     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                         .hasMatch(value!)) {
//                       return 'Please enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//
//                 SizedBox(height: 32),
//
//                 // Date & Time Section
//                 _buildSectionTitle('Schedule', Icons.schedule),
//                 _buildDateTimePicker(
//                   'Drop-off Date & Time',
//                   _dropOffDate,
//                   _dropOffTime,
//                       () => _selectDate(context, true),
//                       () => _selectTime(context, true),
//                 ),
//                 SizedBox(height: 16),
//                 _buildDateTimePicker(
//                   'Pick-up Date & Time',
//                   _pickUpDate,
//                   _pickUpTime,
//                       () => _selectDate(context, false),
//                       () => _selectTime(context, false),
//                 ),
//
//                 SizedBox(height: 32),
//
//                 // Submit Button
//                 Container(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: _isLoading ? null : _createBooking,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.greenAccent[100],
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     child: _isLoading
//                         ? CircularProgressIndicator(color: Colors.white)
//                         : Text(
//                       'Create Booking',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSectionTitle(String title, IconData icon) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 16),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.blue),
//           SizedBox(width: 8),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     required String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon, color: Colors.blue),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: Colors.blue, width: 2),
//         ),
//         filled: true,
//         fillColor: Colors.grey[50],
//       ),
//       validator: validator,
//     );
//   }
//
//   Widget _buildDateTimePicker(
//       String label,
//       DateTime? date,
//       TimeOfDay? time,
//       VoidCallback onDateTap,
//       VoidCallback onTimeTap,
//       ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         SizedBox(height: 8),
//         Row(
//           children: [
//             Expanded(
//               child: InkWell(
//                 onTap: onDateTap,
//                 child: Container(
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.calendar_today, color: Colors.blue),
//                       SizedBox(width: 8),
//                       Text(
//                         date == null
//                             ? 'Select Date'
//                             : DateFormat('MMM dd, yyyy').format(date),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(width: 16),
//             Expanded(
//               child: InkWell(
//                 onTap: onTimeTap,
//                 child: Container(
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.access_time, color: Colors.blue),
//                       SizedBox(width: 8),
//                       Text(
//                         time == null ? 'Select Time' : time.format(context),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   @override
//   void dispose() {
//     _guestNameController.dispose();
//     _guestEmailController.dispose();
//     _pickupNameController.dispose();
//     _pickupEmailController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_stripe_tutorial/air_BNB_key/air_bnb_payment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class BNBBookingPage extends StatefulWidget {
  final String locationId;
  final Map<String, dynamic> selectedLocation; // Change type to Map
  final String bookingId;

  const BNBBookingPage({
    Key? key,
    required this.locationId,
    required this.bookingId,
    required this.selectedLocation,
  }) : super(key: key);

  @override
  _BNBBookingPageState createState() => _BNBBookingPageState();
}

class _BNBBookingPageState extends State<BNBBookingPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final double amounts=15.00;

  // Guest Information
  final TextEditingController _guestNameController = TextEditingController();
  final TextEditingController _guestEmailController = TextEditingController();
  final TextEditingController _guestPhoneController = TextEditingController();

  // Key Pick Up Person Information
  final TextEditingController _pickUpNameController = TextEditingController();
  final TextEditingController _pickUpEmailController = TextEditingController();
  final TextEditingController _pickUpPhoneController = TextEditingController();

  // Key Owner Information
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerEmailController = TextEditingController();

  // Dates and Times
  DateTime? startDate;
  TimeOfDay? startTime;
  DateTime? endDate;
  TimeOfDay? endTime;
  DateTime? keyPickUpTime;
  DateTime? keyDropOffTime;

  // Fee
  final TextEditingController _storageFeeController = TextEditingController();

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  Future<void> _selectDateTime(BuildContext context, bool isPickUp) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          final DateTime dateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          if (isPickUp) {
            keyPickUpTime = dateTime;
          } else {
            keyDropOffTime = dateTime;
          }
        });
      }
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(dateTime.toUtc());
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> createBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final Map<String, dynamic> bookingData = {
        'guest': {
          'name': _guestNameController.text,
          'email': _guestEmailController.text,
          'phone': _guestPhoneController.text,
        },
        'location': widget.locationId,
        'startDate': _formatDate(startDate),
        'startTime': _formatTime(startTime),
        'endDate': _formatDate(endDate),
        'endTime': _formatTime(endTime),
        'keyPickUpBy': {
          'name': _pickUpNameController.text,
          'email': _pickUpEmailController.text,
          'phone': _pickUpPhoneController.text,
        },
        'keyPickUpTime': _formatDateTime(keyPickUpTime),
        'keyDropOffTime': _formatDateTime(keyDropOffTime),
        'keyStorageFee': int.tryParse(_storageFeeController.text),
        'keyOwner': {
          'name': _ownerNameController.text,
          'email': _ownerEmailController.text,
        },
      };

      final response = await http.post(
        Uri.parse('https://urlocker-api.onrender.com/api/v1/airbnb-keys/bookings'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(bookingData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking created successfully!')),
        );
       // Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => BNBPaymentScreen(amount: amounts),));
      } else {
        throw Exception('Failed to create booking: ${response.body}');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Create Booking',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionCard(
                  context,
                  'Agent Information',
                  [
                    _buildTextField(
                      controller: _guestNameController,
                      label: 'Agent Name',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _guestEmailController,
                      label: 'Agent Email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField2(
                      controller: _guestPhoneController,
                      label: 'Agent Phone',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _buildSectionCard(
                  context,
                  'Booking Dates',
                  [
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateTimeButton(
                            icon: Icons.calendar_today,
                            label: 'Start Date',
                            value: startDate == null ? null : _formatDate(startDate),
                            onPressed: () => _selectDate(context, true),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDateTimeButton(
                            icon: Icons.access_time,
                            label: 'Start Time',
                            value: startTime == null ? null : _formatTime(startTime),
                            onPressed: () => _selectTime(context, true),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateTimeButton(
                            icon: Icons.calendar_today,
                            label: 'End Date',
                            value: endDate == null ? null : _formatDate(endDate),
                            onPressed: () => _selectDate(context, false),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDateTimeButton(
                            icon: Icons.access_time,
                            label: 'End Time',
                            value: endTime == null ? null : _formatTime(endTime),
                            onPressed: () => _selectTime(context, false),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _buildSectionCard(
                  context,
                  'Key Pick Up Person',
                  [
                    _buildTextField(
                      controller: _pickUpNameController,
                      label: 'Pick Up Person Name',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _pickUpEmailController,
                      label: 'Pick Up Person Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField2(
                      controller: _pickUpPhoneController,
                      label: 'Pick Up Person Phone',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _buildSectionCard(
                  context,
                  'Key Pick Up/Drop Off Times',
                  [
                    _buildDateTimeButton(
                      icon: Icons.vpn_key,
                      label: 'Pick Up Time',
                      value: keyPickUpTime == null
                          ? null
                          : DateFormat('yyyy-MM-dd HH:mm').format(keyPickUpTime!),
                      onPressed: () => _selectDateTime(context, true),
                      fullWidth: true,
                    ),
                    const SizedBox(height: 16),
                    _buildDateTimeButton(
                      icon: Icons.lock_open,
                      label: 'Drop Off Time',
                      value: keyDropOffTime == null
                          ? null
                          : DateFormat('yyyy-MM-dd HH:mm').format(keyDropOffTime!),
                      onPressed: () => _selectDateTime(context, false),
                      fullWidth: true,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                Container(
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(27),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: isLoading ? null : createBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Text(
                      'Confirm Booking',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Helper widgets
  Widget _buildSectionCard(BuildContext context, String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
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
      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
    );
  }
//================second _buildTextField (not validator added)==================//

  Widget _buildTextField2({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
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
     // validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
    );
  }

  Widget _buildDateTimeButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    String? value,
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                value ?? 'Select $label',
                style: TextStyle(
                  color: value == null ? Colors.grey.shade600 : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _guestNameController.dispose();
    _guestEmailController.dispose();
    _guestPhoneController.dispose();
    _pickUpNameController.dispose();
    _pickUpEmailController.dispose();
    _pickUpPhoneController.dispose();
    _ownerNameController.dispose();
    _ownerEmailController.dispose();
    _storageFeeController.dispose();
    super.dispose();
  }
}