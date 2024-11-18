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
  String _selectedCategory = "All";
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  final ApiService _apiService = ApiService();

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

  Future<void> _handleSearch() async {
    final searchTerm = _searchController.text.trim();
    if (searchTerm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a country name')),
      );
      return;
    }

    setState(() => _isSearching = true);

    try {
      _navigateToDetails(searchTerm);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching details for "$searchTerm"')),
      );
    } finally {
      setState(() => _isSearching = false);
    }
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
                const Text(
                  'Hello there! 👋',
                  style: TextStyle(
                    fontSize: 23,
                    color: Color(0xFF706969),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Explore the world',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
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
                          ? const Padding(
                              padding: EdgeInsets.all(10),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
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
                ),
                const SizedBox(height: 20),
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
                    builder: (context, provider, _) {
                      if (provider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final countryData =
                          provider.countryData[_selectedCategory] ?? [];

                      if (countryData.isEmpty) {
                        return const Center(
                            child: Text('No destinations found'));
                      }

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: countryData.length,
                        itemBuilder: (context, index) {
                          final country = countryData[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 16),
                            width: 250,
                            child: GestureDetector(
                              onTap: () =>
                                  _navigateToDetails(country['country']!),
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        country['image']!,
                                        height: 190,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            height: 190,
                                            color: Colors.grey[200],
                                            child: const Center(
                                              child: Icon(Icons.error),
                                            ),
                                          );
                                        },
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return SizedBox(
                                            height: 190,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
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
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Explore Category',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CategoryCard(
                        icon: '🏔️',
                        label: 'Mountain',
                      ),
                      CategoryCard(
                        icon: '🏖️',
                        label: 'Beach',
                      ),
                      CategoryCard(
                        icon: '🏰',
                        label: 'History',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Column(
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
                      child: GridView.builder(
                        physics:
                            const NeverScrollableScrollPhysics(), // Disabled scrolling to align with the scroll at the top
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 3 / 2,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) {
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

                          final place = places[index];

                          return PlaceCard(
                            imagePath: place['imagePath']!,
                            placeName: place['placeName']!,
                            description: place['description']!,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String text) {
    bool isSelected = text == _selectedCategory;
    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: Material(
        color: isSelected ? const Color(0xFF51ADE5) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedCategory = text;
            });
            final provider =
                Provider.of<CountryProvider>(context, listen: false);
            provider.fetchCountriesData(text, _categoryCountries[text]!);
          },
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
}

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
            style: const TextStyle(
              fontSize: 32,
            ),
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
