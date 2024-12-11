import 'package:flutter/material.dart';
import 'package:flutter_stripe_tutorial/pages/booking.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PartnerProfileScreen extends StatefulWidget {
  const PartnerProfileScreen({Key? key}) : super(key: key);

  @override
  State<PartnerProfileScreen> createState() => _PartnerProfileScreenState();
}

class _PartnerProfileScreenState extends State<PartnerProfileScreen> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchPartnerProfile();
  }

  Future<void> fetchPartnerProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        setState(() {
          error = 'No auth token found. Please login first.';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('https://urlocker-api.onrender.com/api/v1/users/profile/partner'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        if (decodedData is Map<String, dynamic>) {
          setState(() {
            profileData = decodedData;
            isLoading = false;
          });
        } else {
          setState(() {
            error = 'Unexpected response format';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = 'Failed to load profile: ${response.statusCode}\n${response.body}';
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

  String formatDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  Widget _buildProfileField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'Not provided',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(String title, List<Widget> children) {
    return Card(
      elevation: 6,
        shadowColor: const Color(0xFF6DEDE2),
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF07514A),
              ),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userData = profileData?['user'] as Map<String, dynamic>?;
    final businessAddress = profileData?['businessAddress'] as Map<String, dynamic>?;
    final bankDetails = profileData?['bankDetails'] as Map<String, dynamic>?;

    return Scaffold(
      // appBar: AppBar(
       // title: const Text('Partner Profile'),
       //  leading: IconButton(
       //    onPressed: () async {
       //      final prefs = await SharedPreferences.getInstance();
       //      final token = prefs.getString('auth_token');
       //      if (mounted) {
       //        Navigator.push(
       //          context,
       //          MaterialPageRoute(
       //            builder: (context) => BookingPage(),
       //          ),
       //        );
       //      }
       //    },
       //    icon: const Icon(Icons.double_arrow_rounded),
       //  ),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.refresh),
      //       onPressed: () {
      //         setState(() {
      //           isLoading = true;
      //           error = null;
      //         });
      //         fetchPartnerProfile();
      //       },
      //     ),
      //   ],
      // ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
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
                fetchPartnerProfile();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        child: Card(
          child: Container(
            width: MediaQuery.of(context).size.width/1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      if (userData?['profilePicture'] != null)
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                            userData!['profilePicture'],
                          ),
                        )
                      else
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            (userData?['username']?[0] ?? 'P').toUpperCase(),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF07514A),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        userData?['username'] ?? 'Partner Name',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userData?['email'] ?? 'partner@example.com',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Business Address Section
                _buildProfileSection(
                  'Business Address',
                  [
                    _buildProfileField('Street', businessAddress?['street']),
                    _buildProfileField('District', businessAddress?['district']),
                    _buildProfileField('City', businessAddress?['city']),
                    _buildProfileField('State', businessAddress?['state']),
                    _buildProfileField('Zip Code', businessAddress?['zipCode']),
                    _buildProfileField('Country', businessAddress?['country']),
                  ],
                ),

                // Bank Details Section
                _buildProfileSection(
                  'Bank Details',
                  [
                    _buildProfileField('Bank Name', bankDetails?['bankName']),
                    _buildProfileField('Account Holder', bankDetails?['accountHolderName']),
                    _buildProfileField('Account Number', bankDetails?['accountNumber']),
                    _buildProfileField('BSB Number', bankDetails?['bsbNumber']),
                    _buildProfileField('Pay ID', bankDetails?['payId']),
                  ],
                ),

                // Additional Information Section
                _buildProfileSection(
                  'Additional Information',
                  [
                    _buildProfileField('Trade License', profileData?['tradeLicenseNumber']),
                    _buildProfileField('Earnings', '${profileData?['earnings'] ?? 0}'),
                    _buildProfileField(
                      'Account Status',
                      userData?['isActive'] == true ? 'Active' : 'Inactive',
                    ),
                    _buildProfileField(
                      'Member Since',
                      userData?['createdAt'] != null
                          ? formatDateTime(userData!['createdAt'])
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
