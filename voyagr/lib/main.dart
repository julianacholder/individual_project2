import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voyagr/pages/loading_page.dart';
import 'components/country_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voyagr/pages/home_page.dart';
import 'package:voyagr/pages/onboarding_page.dart';

//Used Provider for state management
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

  //Set the title and the Fonts for the app with google fonts

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoThreads',
      theme: ThemeData(
        textTheme: GoogleFonts.outfitTextTheme(),
        primaryTextTheme: GoogleFonts.outfitTextTheme(),
      ),
      home: const LoadingPage(),

      //Defined routes for the various pages of the app
      routes: {
        '/home': (context) => const HomePage(),
        '/onboarding': (context) => const OnboardingPage()
      },
    );
  }
}
