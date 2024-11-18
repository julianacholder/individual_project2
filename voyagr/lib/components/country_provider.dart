// This is the CountryProvider - it manages all the country data for the app
// and handles communication with the API service.

import 'package:flutter/foundation.dart';
import 'api_service.dart';

class CountryProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  // A map to store our country data, organized by category
  Map<String, List<Map<String, String>>> _countryData = {};
  bool _isLoading = false;
  String _error = '';

  bool get isLoading => _isLoading;
  String get error => _error;
  Map<String, List<Map<String, String>>> get countryData => _countryData;

  // Fetches country data for a specific category
  // Params:
  // - category: The continent or region (e.g., "Asia", "Europe")
  // - countries: List of country names to fetch data for

  Future<void> fetchCountriesData(
      String category, List<String> countries) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final results = await _apiService.fetchCountryImages(countries);
      _countryData[category] = results;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // Store the error and reset loading state
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
