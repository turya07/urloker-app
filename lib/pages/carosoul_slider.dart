// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
//
//
// class  CarosoulSliderPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         children: [
//           CarouselSlider(
//             items: [
//
//               //1st Image of Slider
//               Container(
//                 margin: EdgeInsets.all(6.0),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8.0),
//                   image: DecorationImage(
//                     image: AssetImage('assets/homepage_banner.jpeg'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.all(6.0),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8.0),
//                   image: DecorationImage(
//                     image: AssetImage('assets/slider1.jpeg'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.all(6.0),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8.0),
//                   image: DecorationImage(
//                     image: AssetImage('assets/slider2.jpeg'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.all(6.0),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8.0),
//                   image: DecorationImage(
//                     image: AssetImage('assets/slider3.jpeg'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.all(6.0),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8.0),
//                   image: DecorationImage(
//                     image: AssetImage('assets/slider4.jpeg'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//
//
//             ],
//
//             //Slider Container properties
//             options: CarouselOptions(
//               height: 165.0,
//               enlargeCenterPage: true,
//               autoPlay: true,
//               aspectRatio: 16 / 9,
//               autoPlayCurve: Curves.fastOutSlowIn,
//               enableInfiniteScroll: true,
//               autoPlayAnimationDuration: Duration(milliseconds: 800),
//               viewportFraction: 0.8,
//             ),
//           ),
//         ],
//       ),
//
//     );
//   }
// }
