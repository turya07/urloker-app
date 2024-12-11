import 'package:flutter/material.dart';
import 'package:flutter_stripe_tutorial/pages/booking.dart';
import 'package:flutter_stripe_tutorial/partner_profile/partner_all_location.dart';
import 'package:flutter_stripe_tutorial/partner_profile/partner_create.dart';
import 'package:flutter_stripe_tutorial/partner_profile/partner_profile.dart';


class PartnerDashboard extends StatefulWidget {
  const PartnerDashboard({super.key});

  @override
  State<PartnerDashboard> createState() => _PartnerDashboardState();
}

class _PartnerDashboardState extends State<PartnerDashboard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF39C7B6),
          title: const Text(
            'Partner Dashboard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0), // Adjust height if needed.
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: TabBar(
                automaticIndicatorColorAdjustment: true,
                isScrollable: true, // Enable scrolling for the TabBar.
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                tabs: [
                  Tab(
                    icon: Icon(Icons.list_alt, color: Colors.white),
                    text: 'Bookings',
                  ),
                  Tab(
                    icon: Icon(Icons.manage_accounts_rounded, color: Colors.white),
                    text: 'Profile',
                  ),
                  Tab(
                    icon: Icon(Icons.create, color: Colors.white),
                    text: 'SuperAdmin Create',
                  ),
                  Tab(
                    icon: Icon(Icons.location_on_outlined, color: Colors.white),
                    text: 'All Location',
                  ),
                ],
              ),
            ),
          ),

        ),
        body: TabBarView(
          children: [
            // Wrap each page in a container to prevent overflow
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BookingPage(),
              ),
            ),
            const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: PartnerProfileScreen(),
              ),
            ),
            const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: PartnerCreate(),
              ),
            ),
            const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: PartnerLocationsScreen(),
              ),
            ),

          ],
        ),
      ),
    );
  }
}