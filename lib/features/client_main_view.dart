import 'package:flutter/material.dart';
import 'home/view/home_view.dart';
import 'home/widgets/custom_bottom_nav_bar.dart';
import 'search/view/search_view.dart';

class ClientMainView extends StatefulWidget {
  const ClientMainView({super.key});

  @override
  State<ClientMainView> createState() => _ClientMainViewState();
}

class _ClientMainViewState extends State<ClientMainView> {
  int _currentIndex = 0;
  VoidCallback? _showFiltersCallback;
  VoidCallback? _focusSearchCallback;
  Function(String)? _applyQueryCallback;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeView(
        onNavigateToSearch: navigateToSearch,
        onCategorySelected: navigateToSearchWithQuery,
      ),
      SearchView(
        shouldShowFilters: false,
        onFiltersReady: (callback) => _showFiltersCallback = callback,
        onFocusReady: (callback) => _focusSearchCallback = callback,
        onQueryReady: (callback) => _applyQueryCallback = callback,
      ),
      const _PlaceholderScreen(title: 'Réservations'),
      const _PlaceholderScreen(title: 'Favoris'),
      const _PlaceholderScreen(title: 'Profil'),
    ];
  }

  void navigateToSearch({bool showFilters = false}) {
    setState(() {
      _currentIndex = 1;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showFilters) {
        _showFiltersCallback?.call();
      } else {
        _focusSearchCallback?.call();
      }
    });
  }

  void navigateToSearchWithQuery(String query) {
    setState(() {
      _currentIndex = 1;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyQueryCallback?.call(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title\n(To be implemented)',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
