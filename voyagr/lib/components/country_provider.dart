// country_provider.dart
import 'package:flutter/foundation.dart';
import 'api_service.dart';

class CountryProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  Map<String, List<Map<String, String>>> _countryData = {};
  bool _isLoading = false;
  String _error = '';

  bool get isLoading => _isLoading;
  String get error => _error;
  Map<String, List<Map<String, String>>> get countryData => _countryData;

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
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
