import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/country_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voyagr/pages/home_page.dart';
import 'package:voyagr/pages/onboarding_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CountryProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoThreads',
      theme: ThemeData(
        textTheme: GoogleFonts.outfitTextTheme(),
        primaryTextTheme: GoogleFonts.outfitTextTheme(),
      ),
      home: OnboardingPage(),
      routes: {
        '/home': (context) => const HomePage(),
      },
    );
  }
}
