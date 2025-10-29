// homepage_page1.dart
import 'package:flutter/material.dart';

// ---------------------------
// City model
// ---------------------------
class City {
  final String name;
  final String country;
  final String imageUrl;
  final String description;
  bool isFavorite;

  City({
    required this.name,
    required this.country,
    required this.imageUrl,
    required this.description,
    this.isFavorite = false,
  });
}

// ---------------------------
// HomepagePage1
// ---------------------------
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color themeBlue = const Color(0xFF0177DB);

  // sample dataset (mix of cities, some same-country and same-start letters)
  final List<City> _allCities = [
    City(
      name: 'Tokyo',
      country: 'Japan',
      imageUrl:
          'https://images.unsplash.com/photo-1549693578-d683be217e58?q=80&w=1400&auto=format&fit=crop',
      description: 'A high-energy megacity mixing modern and traditional.',
    ),
    City(
      name: 'Kyoto',
      country: 'Japan',
      imageUrl:
          'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8a3lvdG8lMjBqYXBhbnxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=600',
      description: 'Temples, gardens, and historic neighborhoods.',
    ),
    City(
      name: 'Paris',
      country: 'France',
      imageUrl:
          'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=1400&auto=format&fit=crop',
      description: 'Art, cafés, and iconic architecture.',
    ),
    City(
      name: 'Nice',
      country: 'France',
      imageUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1400&auto=format&fit=crop',
      description: 'French Riviera charm and seaside promenades.',
    ),
    City(
      name: 'London',
      country: 'United Kingdom',
      imageUrl:
          'https://images.unsplash.com/photo-1467269204594-9661b134dd2b?q=80&w=1400&auto=format&fit=crop',
      description: 'Historic landmarks and modern culture.',
    ),
    City(
      name: 'Liverpool',
      country: 'United Kingdom',
      imageUrl:
          'https://images.unsplash.com/photo-1708806000941-795fc88e2494?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8TGl2ZXJwb29sJTIwdW5pdGVkJTIwa2luZ2RvbXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=600',
      description: 'Music heritage and maritime history.',
    ),
    City(
      name: 'New York',
      country: 'USA',
      imageUrl:
          'https://images.unsplash.com/photo-1549924231-f129b911e442?q=80&w=1400&auto=format&fit=crop',
      description: 'Skyscrapers, neighborhoods, endless energy.',
    ),
    City(
      name: 'Newcastle',
      country: 'United Kingdom',
      imageUrl:
          'https://images.unsplash.com/photo-1534790566855-4cb788d389ec?q=80&w=1400&auto=format&fit=crop',
      description: 'Northern city with history and river views.',
    ),
    City(
      name: 'Lagos',
      country: 'Nigeria',
      imageUrl:
          'https://images.unsplash.com/photo-1707008797390-38f13ea40163?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fGxhZ29zJTIwbmlnZXJpYXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=600',
      description: 'Bustling coastal megacity with culture and commerce.',
    ),
    City(
      name: 'Abuja',
      country: 'Nigeria',
      imageUrl:
          'https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=1400&auto=format&fit=crop',
      description: 'Planned capital with green spaces.',
    ),
    City(
      name: 'Rome',
      country: 'Italy',
      imageUrl:
          'https://images.unsplash.com/photo-1537799943037-f5da89a65689?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fHJvbWUlMjBpdGFseXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=600',
      description: 'Ancient history, ruins, and great cuisine.',
    ),
    City(
      name: 'Milan',
      country: 'Italy',
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1661962887170-e7db3f307c7a?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8bWlsYW4lMjBpdGFseXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=600',
      description: 'Fashion capital with modern design.',
    ),
    City(
      name: 'Sydney',
      country: 'Australia',
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1697730221799-f2aa87ab2c5d?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8c3lkbmV5JTIwYXVzdHJhbGlhfGVufDB8fDB8fHww&auto=format&fit=crop&q=60&w=600',
      description: 'Harborside city with famous opera house.',
    ),
    City(
      name: 'Cape Town',
      country: 'South Africa',
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=1400&auto=format&fit=crop',
      description: 'Table Mountain and dramatic coastlines.',
    ),
  ];

  late List<City> _visibleCities;
  String _searchQuery = '';
  String _selectedCountry = 'All';
  final ScrollController _listController = ScrollController();
  bool _showPagination = false;

  // Pagination parameters
  final int _itemsPerPage = 6;
  int _currentPage = 1;
  int get _totalPages => (_filteredCitiesForPagination.length / _itemsPerPage)
      .ceil()
      .clamp(1, 999);

  // Derived list for pagination (applies search & filter)
  List<City> get _filteredCitiesForPagination {
    final q = _searchQuery.trim().toLowerCase();
    final List<City> filtered = _allCities.where((city) {
      final matchesCountry =
          _selectedCountry == 'All' || city.country == _selectedCountry;
      // Index-based match on name tokens or country (prefix match)
      final tokens =
          city.name.split(RegExp(r'[\s,]+')).map((t) => t.toLowerCase());
      final countryLower = city.country.toLowerCase();
      final bool matchesQuery = q.isEmpty ||
          tokens.any((t) => t.startsWith(q)) ||
          countryLower.startsWith(q);
      return matchesCountry && matchesQuery;
    }).toList();
    return filtered;
  }

  // visible page items
  List<City> get _paginatedItems {
    final filtered = _filteredCitiesForPagination;
    final start = (_currentPage - 1) * _itemsPerPage;
    final end = (start + _itemsPerPage).clamp(0, filtered.length);
    if (start >= filtered.length) return [];
    return filtered.sublist(start, end);
  }

  List<String> get _countryOptions {
    final countries = _allCities.map((c) => c.country).toSet().toList();
    countries.sort();
    return ['All', ...countries];
  }

  @override
  void initState() {
    super.initState();
    _visibleCities = List.from(_allCities);
    _listController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _listController.removeListener(_onScroll);
    _listController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_listController.hasClients) return;
    if (_listController.position.atEdge) {
      final isBottom = _listController.position.pixels ==
          _listController.position.maxScrollExtent;
      if (isBottom) {
        setState(() {
          _showPagination = true;
        });
      }
    } else {
      if (_showPagination) {
        setState(() {
          _showPagination = false;
        });
      }
    }
  }

  void _applySearchAndResetPagination() {
    setState(() {
      _currentPage = 1;
      // visibleCities recalculated through getters
    });
  }

  void _toggleFavorite(City city) {
    setState(() {
      city.isFavorite = !city.isFavorite;
    });
  }

  void _openCityOverview(City city) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CityOverviewPage(city: city)),
    );
  }

  void _openFavoritesPage() {
    final favs = _allCities.where((c) => c.isFavorite).toList();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FavoritesPage(cities: favs)),
    );
  }

  void _openSettings() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const BlankPage()));
  }

  void _openProfile() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const BlankPage()));
  }

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        // Home: scroll to top
        if (_listController.hasClients) {
          _listController.animateTo(0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut);
        }
        break;
      case 1:
        _openFavoritesPage();
        break;
      case 2:
        // Explore (center logo) -> navigate to continuation/Explore page placeholder
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const BlankPage()));
        break;
      case 3:
        _openSettings();
        break;
      case 4:
        _openProfile();
        break;
    }
  }

  void _goToPage(int page) {
    if (page < 1 || page > _totalPages) return;
    setState(() {
      _currentPage = page;
      // scroll to top of list for clarity
      if (_listController.hasClients) {
        _listController.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
      _showPagination = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLarge = screenWidth > 480;

    // current items for display (paginated)
    final items = _paginatedItems;
    final totalPages = _totalPages;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeBlue,
        elevation: 2,
        centerTitle: true,
        title: Text(
          'Beautiful Cities To Explore',
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.white),
          onPressed: _openProfile,
          iconSize: 26,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_outline, color: Colors.white),
            onPressed: _openFavoritesPage,
            iconSize: 26,
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: _openSettings,
            iconSize: 26,
          ),
        ],
      ),

      // body: column with fixed search/filter, then expanded list
      body: Column(
        children: [
          // Fixed search & filter row
          // ---------------------------
          // Filter row inside Column
          // ---------------------------
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04, vertical: 10),
            child: Row(
              children: [
                // Search field (80% width)
                Expanded(
                  flex: 8,
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(color: Colors.white),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search up cities to explore',
                        prefixIcon: const Icon(Icons.search),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (val) {
                        _searchQuery = val.trim();
                        _applySearchAndResetPagination();
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Filter (DropdownButton, takes ~20% width)
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedCountry,
                        icon: const Icon(Icons.arrow_drop_down),
                        style: const TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.w500),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedCountry = val;
                              _applySearchAndResetPagination();
                            });
                          }
                        },
                        items: _countryOptions.map((country) {
                          return DropdownMenuItem<String>(
                            value: country,
                            child: Text(country),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List (expanded)
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('No cities found'))
                : ListView.builder(
                    controller: _listController,
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04, vertical: 12),
                    itemCount: items.length +
                        1, // +1 for bottom spacing / pagination area
                    itemBuilder: (context, index) {
                      if (index == items.length) {
                        // bottom spacer and optionally pagination card (appears when _showPagination true)
                        return Column(
                          children: [
                            const SizedBox(height: 40),
                            if (_showPagination)
                              _buildPaginationWidget(totalPages),
                            const SizedBox(height: 20),
                          ],
                        );
                      }

                      final city = items[index];

                      return GestureDetector(
                        onTap: () => _openCityOverview(city),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          height: isLarge ? 200 : 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 6))
                            ],
                            image: DecorationImage(
                              image: NetworkImage(city.imageUrl),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.25),
                                  BlendMode.darken),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Container()),
                              ),
                              Positioned(
                                left: 16,
                                bottom: 16,
                                right: 70,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${city.name}, ${city.country}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      city.description,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 12,
                                top: 12,
                                child: InkWell(
                                  onTap: () {
                                    _toggleFavorite(city);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      city.isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: city.isFavorite
                                          ? themeBlue
                                          : Colors.black54,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // bottom nav
      // ---------------------------
      // BottomNavigationBar adjustments
      // ---------------------------
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: themeBlue,
        unselectedItemColor: themeBlue, // labels now same as icons
        onTap: _onBottomNavTap,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: themeBlue), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.star_border, color: themeBlue),
              label: 'Favorites'),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Image.asset(
                'assets/logo.png',
                width: 100, // make logo bigger than other icons
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            label: '', // remove label under logo
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings, color: themeBlue), label: 'Settings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, color: themeBlue),
              label: 'Profile'),
        ],
      ),
    );
  }

  // pagination widget shown at bottom of list (only when _showPagination is true)
  Widget _buildPaginationWidget(int totalPages) {
    final pages = List<int>.generate(totalPages, (i) => i + 1);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Previous
            TextButton(
              onPressed:
                  _currentPage > 1 ? () => _goToPage(_currentPage - 1) : null,
              child: Row(
                children: const [Icon(Icons.chevron_left), Text('Previous')],
              ),
            ),
            const SizedBox(width: 12),

            // Page numbers
            Wrap(
              spacing: 8,
              children: pages.map((p) {
                final isSelected = p == _currentPage;
                return OutlinedButton(
                  onPressed: () => _goToPage(p),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isSelected ? themeBlue : Colors.white,
                    side: BorderSide(
                        color: isSelected ? themeBlue : Colors.black12),
                  ),
                  child: Text(
                    '$p',
                    style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(width: 12),
            // Next
            TextButton(
              onPressed: _currentPage < totalPages
                  ? () => _goToPage(_currentPage + 1)
                  : null,
              child: Row(
                children: const [Text('Next'), Icon(Icons.chevron_right)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------
// Placeholder Pages
// ---------------------------
class CityOverviewPage extends StatelessWidget {
  final City city;
  const CityOverviewPage({Key? key, required this.city}) : super(key: key);
  final Color themeBlue = const Color(0xFF0177DB);

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text('${city.name}, ${city.country}'),
          backgroundColor: const Color(0xFF0177DB)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenW * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(city.imageUrl, fit: BoxFit.cover),
            const SizedBox(height: 12),
            Text('${city.name}, ${city.country}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(city.description),
            const SizedBox(height: 16),
            const Text('City overview placeholder...'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: themeBlue,
        unselectedItemColor: themeBlue, // labels now same as icons
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: themeBlue), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.star_border, color: themeBlue),
              label: 'Favorites'),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Image.asset(
                'assets/logo.png',
                width: 100, // make logo bigger than other icons
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            label: '', // remove label under logo
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings, color: themeBlue), label: 'Settings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, color: themeBlue),
              label: 'Profile'),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  final List<City> cities;
  const FavoritesPage({Key? key, required this.cities}) : super(key: key);
  final Color themeBlue = const Color(0xFF0177DB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Favorites'),
          backgroundColor: const Color(0xFF0177DB)),
      body: cities.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cities.length,
              itemBuilder: (context, i) {
                final c = cities[i];
                return ListTile(
                  leading: SizedBox(
                      width: 80,
                      child: Image.network(c.imageUrl, fit: BoxFit.cover)),
                  title: Text('${c.name}, ${c.country}'),
                  subtitle: Text(c.description,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CityOverviewPage(city: c))),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: themeBlue,
        unselectedItemColor: themeBlue, // labels now same as icons
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: themeBlue), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.star_border, color: themeBlue),
              label: 'Favorites'),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Image.asset(
                'assets/logo.png',
                width: 100, // make logo bigger than other icons
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            label: '', // remove label under logo
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings, color: themeBlue), label: 'Settings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, color: themeBlue),
              label: 'Profile'),
        ],
      ),
    );
  }
}

class BlankPage extends StatelessWidget {
  const BlankPage({Key? key}) : super(key: key);
  final Color themeBlue = const Color(0xFF0177DB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Blank Page Reached!'),
          backgroundColor: const Color(0xFF0177DB)),
      body: const Center(
          child: Text(
              'Input your custom page as a replacement!   Yes you eduvie etieyebo🙄')),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: themeBlue,
        unselectedItemColor: themeBlue, // labels now same as icons
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: themeBlue), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.star_border, color: themeBlue),
              label: 'Favorites'),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Image.asset(
                'assets/logo.png',
                width: 100, // make logo bigger than other icons
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            label: '', // remove label under logo
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings, color: themeBlue), label: 'Settings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, color: themeBlue),
              label: 'Profile'),
        ],
      ),
    );
  }
}
