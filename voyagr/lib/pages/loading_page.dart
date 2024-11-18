//  This page shows the Company logo when the user first loads the app
//Then navigates to the onboarding page
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:voyagr/pages/onboarding_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _setupNavigationTimer();
  }

  //Sets up a timer to navigate to the onboarding page
  void _setupNavigationTimer() {
    Timer(
      const Duration(seconds: 4),
      () => _navigateToOnboarding(),
    );
  }

  // Handle navigation to the onboarding page
  void _navigateToOnboarding() {
    // Make sure the widget is still mounted before navigating
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const OnboardingPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: child,
            );
          },
          child: Image.asset(
            'assets/images/voyagr.png',
          ),
        ),
      ),
    );
  }
}
