// TrendyPlacesGalleryPage.dart
import 'package:flutter/material.dart';

class TrendyPlace {
  final String name;
  final String city;
  final String country;
  final String type; // e.g. "City", "Landmark", "Attraction", "Restaurant"
  final String imageUrl;
  bool isFavorite;

  TrendyPlace({
    required this.name,
    required this.city,
    required this.country,
    required this.type,
    required this.imageUrl,
    this.isFavorite = false,
  });

  String get description => '$city, $country';
}

// ---------------------------
// TrendyPlacesGalleryPage
// ---------------------------
class TrendyPlacesGalleryPage extends StatefulWidget {
  const TrendyPlacesGalleryPage({Key? key}) : super(key: key);

  @override
  State<TrendyPlacesGalleryPage> createState() =>
      _TrendyPlacesGalleryPageState();
}

class _TrendyPlacesGalleryPageState extends State<TrendyPlacesGalleryPage> {
  final Color themeBlue = const Color(0xFF0177DB);
  final ScrollController _listController = ScrollController();
  final GlobalKey _filterButtonKey = GlobalKey();

  List<TrendyPlace> allTrendyPlaces = [];
  List<TrendyPlace> displayedTrendyPlaces = [];

  // Pagination
  final int _itemsPerPage = 20;
  int _currentPage = 1;
  bool _showPagination = false;

  // Search & filter
  String _searchQuery = '';
  String _selectedCountry = 'All';

  // Sample Data (60 TrendyPlaces)
  late final List<TrendyPlace> _TrendyPlaces = [
    // --- CITIES ---
    TrendyPlace(
      name: 'Tokyo',
      city: 'Tokyo',
      country: 'Japan',
      type: 'City',
      imageUrl:
          'https://images.unsplash.com/photo-1549693578-d683be217e58?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Paris',
      city: 'Paris',
      country: 'France',
      type: 'City',
      imageUrl:
          'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'New York City',
      city: 'New York',
      country: 'USA',
      type: 'City',
      imageUrl:
          'https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Dubai',
      city: 'Dubai',
      country: 'UAE',
      type: 'City',
      imageUrl:
          'https://images.unsplash.com/photo-1504274066651-8d31a536b11a?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'London',
      city: 'London',
      country: 'United Kingdom',
      type: 'City',
      imageUrl:
          'https://images.unsplash.com/photo-1467269204594-9661b134dd2b?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Cape Town',
      city: 'Cape Town',
      country: 'South Africa',
      type: 'City',
      imageUrl:
          'https://images.unsplash.com/photo-1549693578-d683be217e58?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Barcelona',
      city: 'Barcelona',
      country: 'Spain',
      type: 'City',
      imageUrl:
          'https://images.unsplash.com/photo-1549693578-d683be217e58?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Rome',
      city: 'Rome',
      country: 'Italy',
      type: 'City',
      imageUrl:
          'https://images.unsplash.com/photo-1506806732259-39c2d0268443?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Lagos',
      city: 'Lagos',
      country: 'Nigeria',
      type: 'City',
      imageUrl:
          'https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Sydney',
      city: 'Sydney',
      country: 'Australia',
      type: 'City',
      imageUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1400',
    ),

    // --- LANDMARKS ---
    TrendyPlace(
      name: 'Eiffel Tower',
      city: 'Paris',
      country: 'France',
      type: 'Landmark',
      imageUrl:
          'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Burj Khalifa',
      city: 'Dubai',
      country: 'UAE',
      type: 'Landmark',
      imageUrl:
          'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Statue of Liberty',
      city: 'New York',
      country: 'USA',
      type: 'Landmark',
      imageUrl:
          'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Big Ben',
      city: 'London',
      country: 'United Kingdom',
      type: 'Landmark',
      imageUrl:
          'https://images.unsplash.com/photo-1528909514045-2fa4ac7a08ba?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Christ the Redeemer',
      city: 'Rio de Janeiro',
      country: 'Brazil',
      type: 'Landmark',
      imageUrl:
          'https://images.unsplash.com/photo-1549693578-d683be217e58?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Great Wall of China',
      city: 'Beijing',
      country: 'China',
      type: 'Landmark',
      imageUrl:
          'https://images.unsplash.com/photo-1549693578-d683be217e58?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Pyramids of Giza',
      city: 'Giza',
      country: 'Egypt',
      type: 'Landmark',
      imageUrl:
          'https://images.unsplash.com/photo-1549693578-d683be217e58?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Colosseum',
      city: 'Rome',
      country: 'Italy',
      type: 'Landmark',
      imageUrl:
          'https://images.unsplash.com/photo-1506806732259-39c2d0268443?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Table Mountain',
      city: 'Cape Town',
      country: 'South Africa',
      type: 'Landmark',
      imageUrl:
          'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Sydney Opera House',
      city: 'Sydney',
      country: 'Australia',
      type: 'Landmark',
      imageUrl:
          'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?q=80&w=1400',
    ),

    // --- ATTRACTIONS ---
    TrendyPlace(
      name: 'Times Square',
      city: 'New York',
      country: 'USA',
      type: 'Attraction',
      imageUrl:
          'https://images.unsplash.com/photo-1549693578-d683be217e58?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Santorini Caldera',
      city: 'Santorini',
      country: 'Greece',
      type: 'Attraction',
      imageUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Shibuya Crossing',
      city: 'Tokyo',
      country: 'Japan',
      type: 'Attraction',
      imageUrl:
          'https://images.unsplash.com/photo-1549692520-acc6669e2f0c?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Central Park',
      city: 'New York',
      country: 'USA',
      type: 'Attraction',
      imageUrl:
          'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Bondi Beach',
      city: 'Sydney',
      country: 'Australia',
      type: 'Attraction',
      imageUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Victoria Island',
      city: 'Lagos',
      country: 'Nigeria',
      type: 'Attraction',
      imageUrl:
          'https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Istanbul Grand Bazaar',
      city: 'Istanbul',
      country: 'Turkey',
      type: 'Attraction',
      imageUrl:
          'https://images.unsplash.com/photo-1467269204594-9661b134dd2b?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Plaza Mayor',
      city: 'Madrid',
      country: 'Spain',
      type: 'Attraction',
      imageUrl:
          'https://images.unsplash.com/photo-1508057198894-247b23fe5ade?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Niagara Falls',
      city: 'Ontario',
      country: 'Canada',
      type: 'Attraction',
      imageUrl:
          'https://images.unsplash.com/photo-1549693578-d683be217e58?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Zuma Rock',
      city: 'Abuja',
      country: 'Nigeria',
      type: 'Attraction',
      imageUrl:
          'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=1400',
    ),

    // --- RESTAURANTS ---
    TrendyPlace(
      name: 'Sushi Saito',
      city: 'Tokyo',
      country: 'Japan',
      type: 'Restaurant',
      imageUrl:
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Noma',
      city: 'Copenhagen',
      country: 'Denmark',
      type: 'Restaurant',
      imageUrl:
          'https://images.unsplash.com/photo-1528605248644-14dd04022da1?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Per Se',
      city: 'New York',
      country: 'USA',
      type: 'Restaurant',
      imageUrl:
          'https://images.unsplash.com/photo-1550966871-3ed3cdb5ed0c?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Epicure',
      city: 'Paris',
      country: 'France',
      type: 'Restaurant',
      imageUrl:
          'https://images.unsplash.com/photo-1528605248644-14dd04022da1?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'DiverXO',
      city: 'Madrid',
      country: 'Spain',
      type: 'Restaurant',
      imageUrl:
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Zuma',
      city: 'Dubai',
      country: 'UAE',
      type: 'Restaurant',
      imageUrl:
          'https://images.unsplash.com/photo-1551218808-94e220e084d2?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Botin',
      city: 'Madrid',
      country: 'Spain',
      type: 'Restaurant',
      imageUrl:
          'https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Pipero Roma',
      city: 'Rome',
      country: 'Italy',
      type: 'Restaurant',
      imageUrl:
          'https://images.unsplash.com/photo-1565299507177-b0ac66763828?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Eleven Madison Park',
      city: 'New York',
      country: 'USA',
      type: 'Restaurant',
      imageUrl:
          'https://images.unsplash.com/photo-1528698827591-e19ccd7bc23d?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Gion Karyo',
      city: 'Kyoto',
      country: 'Japan',
      type: 'Restaurant',
      imageUrl:
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=1400',
    ),

    // EXTRAS TO MAKE THE THIRD PAGE SINCE CHAT IS SUCH A LIL BITCH AND CAN"T PROVIDE GOOD IMAGE LINKS OR ENOUGH DETAILS

    TrendyPlace(
      name: 'Tokyo',
      city: 'Tokyo',
      country: 'Japan',
      type: 'City',
      imageUrl:
          'https://images.unsplash.com/photo-1549693578-d683be217e58?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Paris',
      city: 'Paris',
      country: 'France',
      type: 'City',
      imageUrl:
          'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'New York City',
      city: 'New York',
      country: 'USA',
      type: 'City',
      imageUrl:
          'https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Dubai',
      city: 'Dubai',
      country: 'UAE',
      type: 'City',
      imageUrl:
          'https://images.unsplash.com/photo-1504274066651-8d31a536b11a?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'London',
      city: 'London',
      country: 'United Kingdom',
      type: 'City',
      imageUrl:
          'https://images.unsplash.com/photo-1467269204594-9661b134dd2b?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Cape Town',
      city: 'Cape Town',
      country: 'South Africa',
      type: 'City',
      imageUrl:
          'https://images.unsplash.com/photo-1549693578-d683be217e58?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Barcelona',
      city: 'Barcelona',
      country: 'Spain',
      type: 'City',
      imageUrl:
          'https://images.unsplash.com/photo-1549693578-d683be217e58?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Rome',
      city: 'Rome',
      country: 'Italy',
      type: 'City',
      imageUrl:
          'https://images.unsplash.com/photo-1506806732259-39c2d0268443?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Lagos',
      city: 'Lagos',
      country: 'Nigeria',
      type: 'City',
      imageUrl:
          'https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Sydney',
      city: 'Sydney',
      country: 'Australia',
      type: 'City',
      imageUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Eiffel Tower',
      city: 'Paris',
      country: 'France',
      type: 'Landmark',
      imageUrl:
          'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Burj Khalifa',
      city: 'Dubai',
      country: 'UAE',
      type: 'Landmark',
      imageUrl:
          'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Statue of Liberty',
      city: 'New York',
      country: 'USA',
      type: 'Landmark',
      imageUrl:
          'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Big Ben',
      city: 'London',
      country: 'United Kingdom',
      type: 'Landmark',
      imageUrl:
          'https://images.unsplash.com/photo-1528909514045-2fa4ac7a08ba?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Christ the Redeemer',
      city: 'Rio de Janeiro',
      country: 'Brazil',
      type: 'Landmark',
      imageUrl:
          'https://images.unsplash.com/photo-1549693578-d683be217e58?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Great Wall of China',
      city: 'Beijing',
      country: 'China',
      type: 'Landmark',
      imageUrl:
          'https://images.unsplash.com/photo-1549693578-d683be217e58?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Pyramids of Giza',
      city: 'Giza',
      country: 'Egypt',
      type: 'Landmark',
      imageUrl:
          'https://images.unsplash.com/photo-1549693578-d683be217e58?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Colosseum',
      city: 'Rome',
      country: 'Italy',
      type: 'Landmark',
      imageUrl:
          'https://images.unsplash.com/photo-1506806732259-39c2d0268443?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Table Mountain',
      city: 'Cape Town',
      country: 'South Africa',
      type: 'Landmark',
      imageUrl:
          'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?q=80&w=1400',
    ),
    TrendyPlace(
      name: 'Sydney Opera House',
      city: 'Sydney',
      country: 'Australia',
      type: 'Landmark',
      imageUrl:
          'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?q=80&w=1400',
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
    final set = _TrendyPlaces.map((a) => a.country).toSet().toList();
    set.sort();
    return ['All', ...set];
  }

  // Filtering w/ index-based (prefix) match on TrendyPlace name tokens and city
  List<TrendyPlace> get _filteredTrendyPlaces {
    final q = _searchQuery.trim().toLowerCase();
    return _TrendyPlaces.where((a) {
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
      (_filteredTrendyPlaces.length / _itemsPerPage).ceil().clamp(1, 999);

  List<TrendyPlace> get _paginatedItems {
    final filtered = _filteredTrendyPlaces;
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
      _showPagination = false;
    });
  }

  void _applyCountryFilter(String country) {
    setState(() {
      _selectedCountry = country;
      _currentPage = 1;
      _showPagination = false;
    });
  }

  void _toggleFavorite(TrendyPlace a) {
    setState(() {
      a.isFavorite = !a.isFavorite;
    });
  }

  void _openTrendyPlaceOverview(TrendyPlace a) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => TrendyPlaceOverviewPage(trendyplace: a)));
  }

  void _openFavoritesPage() {
    final favs = _TrendyPlaces.where((a) => a.isFavorite).toList();
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => FavoritesPage(trendyplaces: favs)));
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
          'Popular Trendy Places in the City',
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
                        hintText: 'Search up Trendy Places to explore',
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
                ? const Center(child: Text('No Trendy Places found'))
                : GridView.builder(
                    controller: _listController,
                    padding: EdgeInsets.symmetric(
                        horizontal: screenW * 0.04, vertical: 12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.9, // adjust for taller or wider cards
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final a = items[index];
                      return GestureDetector(
                        onTap: () => _openTrendyPlaceOverview(a),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 4))
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
                              Positioned(
                                left: 10,
                                bottom: 12,
                                right: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(a.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text(a.description,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 11)),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 8,
                                top: 8,
                                child: InkWell(
                                  onTap: () => _toggleFavorite(a),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      a.isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: a.isFavorite
                                          ? themeBlue
                                          : Colors.black54,
                                      size: 20,
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
          if (_showPagination)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
              ),
              child: _buildPaginationWidget(_totalPages),
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

// TrendyPlaceOverviewPage (placeholder)
class TrendyPlaceOverviewPage extends StatelessWidget {
  final TrendyPlace trendyplace;
  const TrendyPlaceOverviewPage({Key? key, required this.trendyplace})
      : super(key: key);
  final Color themeBlue = const Color(0xFF0177DB);

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text(trendyplace.name),
          backgroundColor: const Color(0xFF007BFF)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenW * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(trendyplace.imageUrl, fit: BoxFit.cover),
            const SizedBox(height: 12),
            Text(trendyplace.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(trendyplace.description),
            const SizedBox(height: 16),
            const Text('TrendyPlace overview placeholder...'),
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

// FavoritesPage (placeholder that shows favorited TrendyPlaces)
class FavoritesPage extends StatelessWidget {
  final List<TrendyPlace> trendyplaces;
  const FavoritesPage({Key? key, required this.trendyplaces}) : super(key: key);
  final Color themeBlue = const Color(0xFF0177DB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Favorites'),
          backgroundColor: const Color(0xFF007BFF)),
      body: trendyplaces.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: trendyplaces.length,
              itemBuilder: (context, i) {
                final a = trendyplaces[i];
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
                              TrendyPlaceOverviewPage(trendyplace: a))),
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
