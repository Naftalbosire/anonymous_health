import 'package:flutter/material.dart';
import 'package:frontend/screens/home/welcome_screen.dart';
import 'dart:async';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Start a timer to navigate to the WelcomeScreen after a delay
    Timer(
      const Duration(seconds: 3), // Duration of the splash screen
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const WelcomeScreen()), // Navigate to WelcomeScreen
      ),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 39, 181),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 5, 39, 209),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Logo Image
            Image.asset(
              'assets/images/Anonymous.png', // Corrected asset path
              fit: BoxFit.cover, // Adjust the image fit as needed
            ),
            // Text (App name)
            const Align(
              alignment: Alignment(0.0, 0.4),
              child: Text(
                "Anonymous Health",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 19,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
