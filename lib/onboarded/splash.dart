// splash_screen.dart
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboard_page.dart';
import '../main_activity.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<Widget> getNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final bool onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;
    return onboardingCompleted ? const MainActivity() : const OnboardScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Widget>(
        future: getNextScreen(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FlutterSplashScreen.fadeIn(
              backgroundColor: Colors.white,
              onInit: () {
                debugPrint("On Init");
              },
              onEnd: () {
                debugPrint("On End");
              },
              childWidget: SizedBox(
                height: 400,
                width: 400,
                child: Column(
                  children: [
                    Image.asset("assets/logo.png"),
                    const SizedBox(height: 80),
                    const Text(
                      "Urloker",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 33,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Freedom in Every Journey",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
              onAnimationEnd: () => debugPrint("On Fade In End"),
              nextScreen: snapshot.data!,
              duration: const Duration(milliseconds: 4515),
            );
          }
          // Show loading indicator while checking SharedPreferences
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}