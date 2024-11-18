# 🌍 Voyagr - Travel Discovery App

<p align="center">
  <img src="/voyagr/assets/images/voyagr.png" alt="Voyagr Logo" width="200"/>
</p>

<p align="center">
  <a href="https://flutter.dev/">
    <img src="https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter" alt="Flutter Version">
  </a>
</p>

<p align="center">
  A beautiful Flutter travel app that helps users discover and explore destinations worldwide. Built with Flutter and powered by Pixabay and RapidAPI.
</p>

## ✨ Features

- 🔍 Smart search functionality for destinations
- 🗺️ Browse destinations by continent
- 🏷️ Category-based filtering (Mountains, Beaches, Historical sites)
- 📱 Clean and modern UI design
- 🌐 Integration with Pixabay and RapidAPI
- 📄 Detailed information for each destination
- 🎨 Custom animations and transitions

## 📱 App Screenshots

<p align="center">
  <img src="/voyagr/assets/images/screenshots/loading.png" width="200" alt="Loading Screen"/>
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="/voyagr/assets/images/screenshots/onboarding.png" width="200" alt="Onboarding Screen"/>
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="/voyagr/assets/images/screenshots/home.png" width="200" alt="Home Screen"/>
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="/voyagr/assets/images/screenshots/details.png" width="200" alt="Details Screen"/>
</p>


## 🛠️ Technologies Used

- **Framework**: Flutter 3.0+
- **State Management**: Provider
- **APIs**: 
  - [Pixabay API](https://pixabay.com/) for destination images
  - [RapidAPI](https://rapidapi.com/) for country information
- **Architecture**: MVVM pattern

## ⚙️ Installation

1. Clone the repository
```bash
git clone https://github.com/julianacholder/individual_project2
```

2. Navigate to the project directory
```bash
cd voyagr
```

3. Install dependencies
```bash
flutter pub get
```

4. Create a `.env` file in the root directory
```env
PIXABAY_API_KEY=your_pixabay_key
RAPID_API_KEY=your_rapid_api_key
```

5. Run the app
```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── components/           # Reusable widgets and providers
├── models/              # Data models
├── pages/               # App screens
├── services/            # API and business logic
├── utils/              # Helper functions and constants
└── main.dart           # App entry point
```

## 🔑 API Configuration

### Pixabay API Setup
```dart
// lib/services/api_service.dart
class ApiService {
  final String pixabayKey = 'YOUR_PIXABAY_KEY';
  final String baseUrl = 'https://pixabay.com/api/';
  
  Future<List> getImages(String query) async {
    // Implementation
  }
}
```

### RapidAPI Setup
```dart
// lib/services/api_service.dart
class ApiService {
  final String rapidApiKey = 'YOUR_RAPIDAPI_KEY';
  final String rapidApiHost = 'travel-api.p.rapidapi.com';
  
  Future<Map> getCountryInfo(String country) async {
    // Implementation
  }
}
```

## 📱 Core Features Implementation

### Provider Setup
```dart
// lib/components/country_provider.dart
class CountryProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  Map>> _countryData = {};
  
  Future fetchCountriesData(String category, List countries) async {
    // Implementation
  }
}
```

### Navigation
```dart
// lib/pages/home_page.dart
void _navigateToDetails(String countryName) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CountryDetailsPage(
        countryName: countryName,
      ),
    ),
  );
}
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

Juliana Crystal Holder
- GitHub: [@julianacholder](https://github.com/julianacholder)
- LinkedIn: [Juliana Crystal Holder](https://linkedin.com/in/julianacrystal)

## 🌟 Show your support

Give a ⭐️ if this project helped you!

## 📝 Notes

- This app is a demonstration of Flutter capabilities and API integration
- Uses the MVVM architectural pattern for clean code organization
- Implements custom animations for smooth user experience

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) for the amazing framework
- [Pixabay](https://pixabay.com/) for the beautiful images
- [RapidAPI](https://rapidapi.com/bilgisamapi-bilgisamapi-default/api/travel-guide-api-city-guide-top-places) for the travel data
- Icons made by [Freepik](https://www.freepik.com) from [www.flaticon.com](https://www.flaticon.com/)

---

<p align="center">Made with ❤️ by Juliana Crystal Holder</p>
