// import 'package:flutter/material.dart';
// import 'package:flutter_stripe_tutorial/partner_profile/partner_login.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class PartnerRegistrationPage extends StatefulWidget {
//   const PartnerRegistrationPage({Key? key}) : super(key: key);
//
//   @override
//   _PartnerRegistrationPageState createState() =>
//       _PartnerRegistrationPageState();
// }
//
// class _PartnerRegistrationPageState extends State<PartnerRegistrationPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   // Controllers for input fields
//   final _usernameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _streetController = TextEditingController();
//   final _districtController = TextEditingController();
//   final _cityController = TextEditingController();
//   final _stateController = TextEditingController();
//   final _zipCodeController = TextEditingController();
//   final _countryController = TextEditingController();
//   final _licenseController = TextEditingController();
//
//   bool _isLoading = false;
//
//   Future<void> _registerUser() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     final url = Uri.parse(
//         'https://urlocker-api.onrender.com/api/v1/users/register/partner');
//     final data = {
//       "username": _usernameController.text,
//       "email": _emailController.text,
//       "password": _passwordController.text,
//       "businessAddress": {
//         "street": _streetController.text,
//         "district": _districtController.text,
//         "city": _cityController.text,
//         "state": _stateController.text,
//         "zipCode": _zipCodeController.text,
//         "country": _countryController.text,
//       },
//       "tradeLicenseNumber": _licenseController.text,
//     };
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(data),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Registration successful!')),
//         );
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const PartnerLoginPage()),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: ${response.body}')),
//         );
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to register: $error')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Partner Registration'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Register your account',
//                   style: TextStyle(
//                       fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   'Please fill in the details below to create your account.',
//                   style: TextStyle(fontSize: 16, color: Colors.black54),
//                 ),
//                 const SizedBox(height: 20),
//                 _buildTextField(_usernameController, 'Username', Icons.person),
//                 _buildTextField(_emailController, 'Email', Icons.email,
//                     keyboardType: TextInputType.emailAddress),
//                 _buildTextField(_passwordController, 'Password', Icons.lock,
//                     obscureText: true),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Business Address',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 _buildTextField(_streetController, 'Street', Icons.location_on),
//                 _buildTextField(_districtController, 'District', Icons.location_city),
//                 _buildTextField(_cityController, 'City', Icons.location_city),
//                 _buildTextField(_stateController, 'State', Icons.map),
//                 _buildTextField(_zipCodeController, 'Zip Code', Icons.pin_drop,
//                     keyboardType: TextInputType.number),
//                 _buildTextField(_countryController, 'Country', Icons.public),
//                 _buildTextField(
//                     _licenseController, 'Trade License Number', Icons.business),
//                 const SizedBox(height: 20),
//                 _isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _registerUser,
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                       textStyle: const TextStyle(fontSize: 16),
//                     ),
//                     child: const Text('Register'),
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
//   Widget _buildTextField(TextEditingController controller, String labelText,
//       IconData icon, {bool obscureText = false, TextInputType? keyboardType}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscureText,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           labelText: labelText,
//           prefixIcon: Icon(icon),
//         ),
//         validator: (value) => value!.isEmpty ? 'Please enter $labelText' : null,
//       ),
//     );
//   }
// }
