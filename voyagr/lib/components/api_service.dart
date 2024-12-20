//This App uses two Restful Apis
// One- The Pixaby Free Api which get images of the countries names passed to it
// Two - A Rapid travel Api that get activities you could do in a particular country
// with params such as region, language and categories

import 'dart:convert';
import 'package:http/http.dart' as http;

//Set Api keys and Urls for both Apis

class ApiService {
  static const String apiKey = '47115757-4515a6533335eb8fb8b0544ae';
  static const String baseUrl = 'https://pixabay.com/api/';
  static const String rapidApiKey =
      '11f59c997amsh1717ee6d70f2ff5p182876jsn59520ba2f105';
  static const String rapidApiHost =
      'travel-guide-api-city-guide-top-places.p.rapidapi.com';

  //Fetches pictures from the pixaby Api based on the name of the country passed

  Future<List<Map<String, String>>> fetchCountryImages(
      List<String> countries) async {
    List<Map<String, String>> results = [];

    for (String country in countries) {
      final response = await http.get(
        Uri.parse('$baseUrl?key=$apiKey&q=$country&image_type=photo'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['hits'] != null && data['hits'].isNotEmpty) {
          results.add({
            'country': country,
            'image': data['hits'][0]
                ['webformatURL'], // Fetches the first image from the api
          });
        }
      }
    }
    return results;
  }

  //Fetches the country details from the Rapid Api based on the country name
  //language and categories

  Future<List<Map<String, dynamic>>> fetchCountryDetails(String region) async {
    final url = Uri.parse(
        'https://travel-guide-api-city-guide-top-places.p.rapidapi.com/check');

    try {
      final response = await http.post(
        url,
        headers: {
          'x-rapidapi-key': rapidApiKey,
          'x-rapidapi-host': rapidApiHost,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'region': region,
          'language': 'en',
          'interests': ['historical', 'cultural', 'food']
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['result']);
      } else {
        throw Exception('Failed to load country details');
      }
    } catch (e) {
      throw Exception('Error fetching country details: $e');
    }
  }
}
