// onboard_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main_activity.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardingSlider(
        pageBackgroundColor: const Color(0xFFBEEDE4),
        controllerColor: Colors.black54,
        totalPage: 4,
        headerBackgroundColor: const Color(0xFFBEEDE4),
        finishButtonText: 'Let\'s Go',
        finishButtonStyle: const FinishButtonStyle(
          backgroundColor: Colors.black,
        ),
        onFinish: () async {
          // Save onboarding completion status
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('onboardingCompleted', true);

          // Navigate to main activity
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => const MainActivity(),
              ),
            );
          }
        },
        skipTextButton: const Text(
          'Skip',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        background: [
          Image.asset(
            'assets/p1.jpg',
            height: MediaQuery.of(context).size.height / 1.2,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/p2.jpg',
            height: MediaQuery.of(context).size.height / 1.2,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/p3.jpg',
            height: MediaQuery.of(context).size.height / 1.2,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/p4.jpg',
            height: MediaQuery.of(context).size.height / 1.2,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ],
        speed: 1.8,
        pageBodies: [
          buildPageBody('  Got Baggage?\nStash it!  '),
          buildPageBody('Stash in 3 steps!'),
          buildPageBody('Less bags, More Fun'),
          buildPageBody('Search and find best partner'),
        ],
      ),
    );
  }

  Widget buildPageBody(String text) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 500),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.orange,
                backgroundColor: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}