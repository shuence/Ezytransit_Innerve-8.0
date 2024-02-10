import 'dart:async';
import 'package:ezytransit_innerve/onboarding_screen.dart';
import 'package:ezytransit_innerve/screens/Home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth for Firebase Authentication
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Check if user is authenticated after 5 seconds
    Timer(const Duration(seconds: 5), () {
      checkAuthentication();
    });
  }

  Future<void> checkAuthentication() async {
    // Check if the current user is authenticated with Firebase
    User? user = FirebaseAuth.instance.currentUser;
    bool isLoggedIn = user != null;

    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) =>
              isLoggedIn ? const HomeScreen() : OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(seconds: 2),
          opacity: _opacity,
          child: Container(
            width: 360,
            height: 807,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(color: Colors.white),
            child: Stack(
              children: [
                Positioned(
                  left: 78,
                  top: 325,
                  child: Container(
                    width: 203,
                    height: 123,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/ezytranzit-new.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  left: 120,
                  top: 448,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'EZY',
                          style: TextStyle(
                            color: Color(0xFF09BD62),
                            fontSize: 16,
                            fontFamily: 'Dela Gothic One',
                            fontWeight: FontWeight.w800,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Dela Gothic One',
                            fontWeight: FontWeight.w800,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: 'TRANSZIT',
                          style: TextStyle(
                            color: Color(0xFF3B3B3B),
                            fontSize: 16,
                            fontFamily: 'Dela Gothic One',
                            fontWeight: FontWeight.w800,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Positioned(
                  left: 56,
                  top: 475,
                  child: Text(
                    'सोप्पं, सुरक्षित आणि स्मार्ट यात्रा, आता तुमच्या मोबाईलवर!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
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
