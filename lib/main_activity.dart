import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe_tutorial/air_BNB_key/air_bnb_search.dart';
import 'package:flutter_stripe_tutorial/pages/home.dart';
import 'package:flutter_stripe_tutorial/pages/settings.dart';
import 'package:flutter_stripe_tutorial/charging_booking/charging_booking_req.dart';
import 'package:flutter_stripe_tutorial/partner_profile/partner_login.dart';

import 'localization/location_search.dart';


class MainActivity extends StatefulWidget {
  const MainActivity({super.key});

  @override
  State<MainActivity> createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {

  final pages=[
    HomePage(),
    SearchPage(),
    PartnerLoginPage(),
   // ChargingPoint(),
    BNBSearch(),
    SettingPage(),
  ];
  var page=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color(0xFF6DEDE2),
        index: 0,
        onTap: (index) {
         setState(() {
           page=index;
         });
        },
          items: [
            Icon(Icons.home),
            Icon(Icons.manage_search_outlined),
            Icon(Icons.person_pin_rounded),
            //Icon(Icons.charging_station),
            Icon(Icons.key_sharp),
            Icon(Icons.settings),
          ]
      ),
      body: pages[page],
    );
  }
}


