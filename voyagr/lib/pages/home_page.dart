// This is the main home page of Voyagr a travel app.
// It shows different travel destinations grouped by continents and lets users
// search for specific places and give details about
// fun vacation plans they could do in a specific country.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/country_provider.dart';
import 'country_details_page.dart';
import '../components/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Keep track of which category tab is selected
  String _selectedCategory = "All";
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  final ApiService _apiService = ApiService();

  //  travel destinations organized by continent
  // TODO: Move this to a separate config file when the list grows
  final Map<String, List<String>> _categoryCountries = {
    "All": ["Maldives", "Kenya", "India", "Rwanda"],
    "Asia": ["Maldives", "India", "Bangkok"],
    "America": ["USA", "Canada", "Brazil"],
    "Europe": ["France", "Germany", "Italy"],
    "Africa": ["Kenya", "Uganda", "Rwanda"],
  };

  @override
  void initState() {
    super.initState();
    // Fetch initial data after the widget is fully built
    _initializeData();
  }

//used Provider for state management
  void _initializeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CountryProvider>(context, listen: false);
      provider.fetchCountriesData(
          _selectedCategory, _categoryCountries[_selectedCategory]!);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Handles the search functionality when user submits a country name
  Future<void> _handleSearch() async {
    final searchTerm = _searchController.text.trim();
    if (searchTerm.isEmpty) {
      _showSnackBar('Please enter a country name');
      return;
    }

    setState(() => _isSearching = true);

    try {
      _navigateToDetails(searchTerm);
    } catch (e) {
      _showSnackBar('Error fetching details for "$searchTerm"');
    } finally {
      setState(() => _isSearching = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 80.0, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 15),
                _buildSearchBar(),
                const SizedBox(height: 20),
                _buildExclusiveDestinations(),
                const SizedBox(height: 30),
                _buildExploreCategories(),
                const SizedBox(height: 30),
                _buildKnowYourWorld(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // The welcoming header section
  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello there! 👋',
          style: TextStyle(
            fontSize: 23,
            color: Color(0xFF706969),
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Explore the world',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Search bar with loading indicator
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFECF2F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search for a city or country...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _isSearching
              ? const _LoadingIndicator()
              : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _searchController.clear(),
                ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
        ),
        onSubmitted: (_) => _handleSearch(),
      ),
    );
  }

  // Exclusive destinations section with horizontal scrolling
  Widget _buildExclusiveDestinations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Exclusive Destinations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categoryCountries.keys
                .map((category) => _buildTabButton(category))
                .toList(),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 260,
          child: Consumer<CountryProvider>(
            builder: (context, provider, _) => _buildDestinationsList(provider),
          ),
        ),
      ],
    );
  }

  // The main list of destinations
  Widget _buildDestinationsList(CountryProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final countryData = provider.countryData[_selectedCategory] ?? [];

    if (countryData.isEmpty) {
      return const Center(child: Text('No destinations found'));
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: countryData.length,
      itemBuilder: (context, index) =>
          _buildDestinationCard(countryData[index]),
    );
  }

  // Individual destination card
  Widget _buildDestinationCard(Map<String, String> country) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 250,
      child: GestureDetector(
        onTap: () => _navigateToDetails(country['country']!),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDestinationImage(country['image']!),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  country['country']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Network image with loading and error handling
  Widget _buildDestinationImage(String imageUrl) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Image.network(
        imageUrl,
        height: 190,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 190,
            color: Colors.grey[200],
            child: const Center(child: Icon(Icons.error)),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildImageLoadingIndicator(loadingProgress);
        },
      ),
    );
  }

  Widget _buildImageLoadingIndicator(ImageChunkEvent loadingProgress) {
    return SizedBox(
      height: 190,
      child: Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        ),
      ),
    );
  }

  // Category tabs at the top
  Widget _buildTabButton(String text) {
    bool isSelected = text == _selectedCategory;
    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: Material(
        color: isSelected ? const Color(0xFF51ADE5) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _handleCategoryChange(text),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleCategoryChange(String category) {
    setState(() => _selectedCategory = category);
    final provider = Provider.of<CountryProvider>(context, listen: false);
    provider.fetchCountriesData(category, _categoryCountries[category]!);
  }

  // Navigation helper
  void _navigateToDetails(String countryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountryDetailsPage(countryName: countryName),
      ),
    );
  }

  // Explore categories section with icons
  Widget _buildExploreCategories() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore Category',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 20),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CategoryCard(icon: '🏔️', label: 'Mountain'),
              CategoryCard(icon: '🏖️', label: 'Beach'),
              CategoryCard(icon: '🏰', label: 'History'),
            ],
          ),
        ),
      ],
    );
  }

  // Know your world section with grid
  Widget _buildKnowYourWorld() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Know Your World',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Grow your world knowledge',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: 400,
          child: _buildPlacesGrid(),
        ),
      ],
    );
  }

  Widget _buildPlacesGrid() {
    // Our featured places data
    final places = [
      {
        "imagePath": 'assets/images/dubia.jpg',
        "placeName": 'Dubai',
        "description": 'City in the UAE',
      },
      {
        "imagePath": 'assets/images/bangkok.jpg',
        "placeName": 'Bangkok',
        "description": 'Capital of Thailand',
      },
      {
        "imagePath": 'assets/images/india.jpg',
        "placeName": 'Sikkim',
        "description": 'State of India',
      },
      {
        "imagePath": 'assets/images/singapore.jpg',
        "placeName": 'Singapore',
        "description": 'Country in Asia',
      },
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3 / 2,
      ),
      itemCount: places.length,
      itemBuilder: (context, index) => PlaceCard(
        imagePath: places[index]["imagePath"]!,
        placeName: places[index]["placeName"]!,
        description: places[index]["description"]!,
      ),
    );
  }
}

// Loading indicator widget to keep things DRY
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(10),
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

// A reusable card for showing travel categories
class CategoryCard extends StatelessWidget {
  final String icon;
  final String label;

  const CategoryCard({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 25),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// Card widget for displaying place information

class PlaceCard extends StatelessWidget {
  final String imagePath;
  final String placeName;
  final String description;

  const PlaceCard({
    Key? key,
    required this.imagePath,
    required this.placeName,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  placeName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
