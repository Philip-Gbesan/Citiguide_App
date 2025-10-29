// attractions_gallery_page.dart
import 'package:flutter/material.dart';

// ---------------------------
// Attraction model
// ---------------------------
class Attraction {
  final String name;
  final String city;
  final String country;
  final String imageUrl;
  bool isFavorite;

  Attraction({
    required this.name,
    required this.city,
    required this.country,
    required this.imageUrl,
    this.isFavorite = false,
  });

  String get description => '$city, $country';
}

// AttractionsGalleryPage
class AttractionsGalleryPage extends StatefulWidget {
  const AttractionsGalleryPage({Key? key}) : super(key: key);

  @override
  State<AttractionsGalleryPage> createState() => _AttractionsGalleryPageState();
}

class _AttractionsGalleryPageState extends State<AttractionsGalleryPage> {
  final Color themeBlue = const Color(0xFF0177DB);
  final ScrollController _listController = ScrollController();
  final GlobalKey _filterButtonKey = GlobalKey();

  // Pagination
  final int _itemsPerPage = 10;
  int _currentPage = 1;
  bool _showPagination = false;

  // Search & filter
  String _searchQuery = '';
  String _selectedCountry = 'All';

  // Attractions dummy dataset
  late final List<Attraction> _allAttractions = [
    // Tokyo (3+)
    Attraction(
      name: 'Tokyo Tower',
      city: 'Tokyo',
      country: 'Japan',
      imageUrl:
      'https://images.unsplash.com/photo-1509718443690-d8e2fb3474b7?q=80&w=1400&auto=format&fit=crop',
    ),
    Attraction(
      name: 'Shibuya Crossing',
      city: 'Tokyo',
      country: 'Japan',
      imageUrl:
      'https://images.unsplash.com/photo-1549692520-acc6669e2f0c?q=80&w=1400&auto=format&fit=crop',
    ),
    Attraction(
      name: 'Meiji Shrine',
      city: 'Tokyo',
      country: 'Japan',
      imageUrl:
      'https://images.unsplash.com/photo-1491553895911-0055eca6402d?q=80&w=1400&auto=format&fit=crop',
    ),
    // Paris (3)
    Attraction(
      name: 'Eiffel Tower',
      city: 'Paris',
      country: 'France',
      imageUrl:
      'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=1400&auto=format&fit=crop',
    ),
    Attraction(
      name: 'Louvre Museum',
      city: 'Paris',
      country: 'France',
      imageUrl:
      'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=1400&auto=format&fit=crop',
    ),
    // London (3)
    Attraction(
      name: 'London Eye',
      city: 'London',
      country: 'United Kingdom',
      imageUrl:
      'https://images.unsplash.com/photo-1467269204594-9661b134dd2b?q=80&w=1400&auto=format&fit=crop',
    ),
    Attraction(
      name: 'Tower Bridge',
      city: 'London',
      country: 'United Kingdom',
      imageUrl:
      'https://images.unsplash.com/photo-1508057198894-247b23fe5ade?q=80&w=1400&auto=format&fit=crop',
    ),
    // New York (3)
    Attraction(
      name: 'Statue of Liberty',
      city: 'New York',
      country: 'USA',
      imageUrl:
      'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=1400&auto=format&fit=crop',
    ),
    Attraction(
      name: 'Central Park',
      city: 'New York',
      country: 'USA',
      imageUrl:
      'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?q=80&w=1400&auto=format&fit=crop',
    ),
    // Lagos (3)
    Attraction(
      name: 'Lekki Conservation Centre',
      city: 'Lagos',
      country: 'Nigeria',
      imageUrl:
      'https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=1400&auto=format&fit=crop',
    ),
    Attraction(
      name: 'Nike Art Gallery',
      city: 'Lagos',
      country: 'Nigeria',
      imageUrl:
      'https://images.unsplash.com/photo-1495567720989-cebdbdd97913?q=80&w=1400&auto=format&fit=crop',
    ),
    Attraction(
      name: 'Tarkwa Bay',
      city: 'Lagos',
      country: 'Nigeria',
      imageUrl:
      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1400&auto=format&fit=crop',
    ),
    // Abuja (3)
    Attraction(
      name: 'Zuma Rock',
      city: 'Abuja',
      country: 'Nigeria',
      imageUrl:
      'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=1400&auto=format&fit=crop',
    ),
    Attraction(
      name: 'Millennium Park',
      city: 'Abuja',
      country: 'Nigeria',
      imageUrl:
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=1400&auto=format&fit=crop',
    ),
    // Newcastle (3)
    Attraction(
      name: 'Tyne Bridge',
      city: 'Newcastle',
      country: 'United Kingdom',
      imageUrl:
      'https://images.unsplash.com/photo-1534790566855-4cb788d389ec?q=80&w=1400&auto=format&fit=crop',
    ),
    // Madrid (3)
    Attraction(
      name: 'Plaza Mayor',
      city: 'Madrid',
      country: 'Spain',
      imageUrl:
      'https://images.unsplash.com/photo-1508057198894-247b23fe5ade?q=80&w=1400&auto=format&fit=crop',
    ),

    // ---------------------------
    // +30 random attractions from global cities
    // ---------------------------
    Attraction(
      name: 'Bondi Beach',
      city: 'Sydney',
      country: 'Australia',
      imageUrl:
      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1400&auto=format&fit=crop',
    ),
    Attraction(
      name: 'Harbour Bridge',
      city: 'Sydney',
      country: 'Australia',
      imageUrl:
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=1400&auto=format&fit=crop',
    ),
    Attraction(
      name: 'Christ the Redeemer',
      city: 'Rio de Janeiro',
      country: 'Brazil',
      imageUrl:
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=1400&auto=format&fit=crop',
    ),
    Attraction(
      name: 'Copacabana Beach',
      city: 'Rio de Janeiro',
      country: 'Brazil',
      imageUrl:
      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1400&auto=format&fit=crop',
    ),
    Attraction(
      name: 'Machu Picchu',
      city: 'Cusco',
      country: 'Peru',
      imageUrl:
      'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=1400&auto=format&fit=crop',
    ),
    Attraction(
      name: 'Sacred Valley',
      city: 'Cusco',
      country: 'Peru',
      imageUrl:
      'https://images.unsplash.com/photo-1549880338-65ddcdfd017b?q=80&w=1400&auto=format&fit=crop',
    ),
    Attraction(
      name: 'Charles Bridge',
      city: 'Prague',
      country: 'Czech Republic',
      imageUrl:
      'https://images.unsplash.com/photo-1495567720989-cebdbdd97913?q=80&w=1400&auto=format&fit=crop',
    ),
    Attraction(
      name: 'Hagia Sophia',
      city: 'Istanbul',
      country: 'Turkey',
      imageUrl:
      'https://images.unsplash.com/photo-1467269204594-9661b134dd2b?q=80&w=1400&auto=format&fit=crop',
    ),
    Attraction(
      name: 'Cairo Pyramids (Giza)',
      city: 'Giza',
      country: 'Egypt',
      imageUrl:
      'https://images.unsplash.com/photo-1508057198894-247b23fe5ade?q=80&w=1400&auto=format&fit=crop',
    ),
    Attraction(
      name: 'Egyptian Museum',
      city: 'Cairo',
      country: 'Egypt',
      imageUrl:
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=1400&auto=format&fit=crop',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _listController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _listController.removeListener(_onScroll);
    _listController.dispose();
    super.dispose();
  }

  List<String> get _countryOptions {
    final set = _allAttractions.map((a) => a.country).toSet().toList();
    set.sort();
    return ['All', ...set];
  }

  // Filtering w/ index-based (prefix) match on attraction name tokens and city
  List<Attraction> get _filteredAttractions {
    final q = _searchQuery.trim().toLowerCase();
    return _allAttractions.where((a) {
      final matchesCountry =
          _selectedCountry == 'All' || a.country == _selectedCountry;
      final tokens =
      a.name.split(RegExp(r'[\s,]+')).map((t) => t.toLowerCase());
      final cityLower = a.city.toLowerCase();
      final matchesQuery = q.isEmpty ||
          tokens.any((t) => t.startsWith(q)) ||
          cityLower.startsWith(q);
      return matchesCountry && matchesQuery;
    }).toList();
  }

  int get _totalPages =>
      (_filteredAttractions.length / _itemsPerPage).ceil().clamp(1, 999);

  List<Attraction> get _paginatedItems {
    final filtered = _filteredAttractions;
    final start = (_currentPage - 1) * _itemsPerPage;
    final end = (start + _itemsPerPage).clamp(0, filtered.length);
    if (start >= filtered.length) return [];
    return filtered.sublist(start, end);
  }

  void _onScroll() {
    if (!_listController.hasClients) return;
    final pos = _listController.position;
    if (pos.atEdge && pos.pixels == pos.maxScrollExtent) {
      setState(() {
        _showPagination = true;
      });
    } else {
      if (_showPagination) {
        setState(() {
          _showPagination = false;
        });
      }
    }
  }

  void _applySearchResetPagination(String query) {
    setState(() {
      _searchQuery = query.trim();
      _currentPage = 1;
      _showPagination = true;
    });
  }

  void _applyCountryFilter(String country) {
    setState(() {
      _selectedCountry = country;
      _currentPage = 1;
      _showPagination = true;
    });
  }

  void _toggleFavorite(Attraction a) {
    setState(() {
      a.isFavorite = !a.isFavorite;
    });
  }

  void _openAttractionOverview(Attraction a) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => AttractionOverviewPage(attraction: a)));
  }

  void _openFavoritesPage() {
    final favs = _allAttractions.where((a) => a.isFavorite).toList();
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => FavoritesPage(attractions: favs)));
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
      _showPagination = false;
    });
    if (_listController.hasClients) {
      _listController.animateTo(0,
          duration: const Duration(milliseconds: 330), curve: Curves.easeOut);
    }
  }

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

  // Show anchored popup menu below the filter button (compact and scrollable)
  Future<void> _showCountryDropdown() async {
    final countries = _countryOptions;
    // find button position
    final renderBox =
    _filterButtonKey.currentContext?.findRenderObject() as RenderBox?;
    final overlay =
    Overlay.of(context)?.context.findRenderObject() as RenderBox?;
    RelativeRect position = RelativeRect.fill;
    if (renderBox != null && overlay != null) {
      final target = renderBox.localToGlobal(Offset.zero, ancestor: overlay);
      position = RelativeRect.fromLTRB(
          target.dx,
          target.dy + renderBox.size.height,
          overlay.size.width - target.dx - renderBox.size.width,
          overlay.size.height - target.dy - renderBox.size.height);
    }

    final selected = await showMenu<String>(
      context: context,
      position: position,
      items: countries.map((c) {
        return PopupMenuItem<String>(
          value: c,
          child: SizedBox(width: 200, child: Text(c)),
        );
      }).toList(),
    );

    if (selected != null) {
      _applyCountryFilter(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final isLarge = screenW > 480;
    final items = _paginatedItems;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeBlue,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
        title: const Text(
          'Popular Attractions and Tourist Centers to Explore',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.star_outlined, color: Colors.white),
            onPressed: _openFavoritesPage,
            iconSize: 28,
          ),
        ],
      ),
      body: Column(
        children: [
          // fixed search + filter row
          Container(
            color: Colors.white,
            padding:
            EdgeInsets.symmetric(horizontal: screenW * 0.04, vertical: 10),
            child: Row(
              children: [
                // Search ~80%
                Expanded(
                  flex: 8,
                  child: Container(
                    height: 46,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search up attractions to explore',
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
                      onChanged: (val) => _applySearchResetPagination(val),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Filter ~20% -> compact dropdown anchored under button
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 46,
                    child: OutlinedButton(
                      key: _filterButtonKey,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      onPressed: _showCountryDropdown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                              child: Text(_selectedCountry,
                                  style: const TextStyle(color: Colors.black87),
                                  overflow: TextOverflow.ellipsis)),
                          const SizedBox(width: 6),
                          const Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // list
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('No attractions found'))
                : ListView.builder(
              controller: _listController,
              padding: EdgeInsets.symmetric(
                  horizontal: screenW * 0.04, vertical: 12),
              itemCount: items.length + 1,
              itemBuilder: (context, index) {
                if (index == items.length) {
                  // bottom spacer + pagination if shown
                  return Column(
                    children: [
                      const SizedBox(height: 30),
                      if (_showPagination)
                        _buildPaginationWidget(_totalPages),
                      const SizedBox(height: 20),
                    ],
                  );
                }

                final a = items[index];
                return GestureDetector(
                  onTap: () => _openAttractionOverview(a),
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
                        image: NetworkImage(a.imageUrl),
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
                                child: Container())),
                        Positioned(
                          left: 16,
                          bottom: 16,
                          right: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(a.name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text(a.description,
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 12,
                          top: 12,
                          child: InkWell(
                            onTap: () {
                              _toggleFavorite(a);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle),
                              child: Icon(
                                  a.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: a.isFavorite
                                      ? themeBlue
                                      : Colors.black54,
                                  size: 24),
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
}

// AttractionOverviewPage (placeholder)
class AttractionOverviewPage extends StatelessWidget {
  final Attraction attraction;
  const AttractionOverviewPage({Key? key, required this.attraction})
      : super(key: key);
  final Color themeBlue = const Color(0xFF0177DB);

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text(attraction.name),
          backgroundColor: const Color(0xFF007BFF)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenW * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(attraction.imageUrl, fit: BoxFit.cover),
            const SizedBox(height: 12),
            Text(attraction.name,
                style:
                const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(attraction.description),
            const SizedBox(height: 16),
            const Text('Attraction overview placeholder...'),
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

// FavoritesPage (placeholder shows favorited attractions)
class FavoritesPage extends StatelessWidget {
  final List<Attraction> attractions;
  const FavoritesPage({Key? key, required this.attractions}) : super(key: key);
  final Color themeBlue = const Color(0xFF0177DB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Favorites'),
          backgroundColor: const Color(0xFF007BFF)),
      body: attractions.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: attractions.length,
        itemBuilder: (context, i) {
          final a = attractions[i];
          return ListTile(
            leading: SizedBox(
                width: 80,
                child: Image.network(a.imageUrl, fit: BoxFit.cover)),
            title: Text(a.name),
            subtitle: Text(a.description),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        AttractionOverviewPage(attraction: a))),
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

// Blank Page
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
