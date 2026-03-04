import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import 'chat/controllers/conversations_controller.dart';
import 'chat/domain/chat_service.dart';
import 'chat/presentation/screens/conversation_list_screen.dart';
import 'home/view/home_view.dart';
import 'home/widgets/custom_bottom_nav_bar.dart';
import 'reservations/view/reservations_view.dart';
import 'search/view/search_view.dart';
import 'profile/view/profile_screen.dart';

class ClientMainView extends StatefulWidget {
  final int initialIndex;
  
  const ClientMainView({super.key, this.initialIndex = 0});

  @override
  State<ClientMainView> createState() => _ClientMainViewState();
}

class _ClientMainViewState extends State<ClientMainView> {
  late int _currentIndex;
  VoidCallback? _showFiltersCallback;
  VoidCallback? _focusSearchCallback;
  Function(String)? _applyQueryCallback;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    final chatRepository = ChatService().repository;
    _screens = [
      HomeView(
        onNavigateToSearch: navigateToSearch,
        onCategorySelected: navigateToSearchWithQuery,
        onNavigateToProfile: () {
          setState(() {
            _currentIndex = 4;
          });
        },
      ),
      SearchView(
        shouldShowFilters: false,
        onFiltersReady: (callback) => _showFiltersCallback = callback,
        onFocusReady: (callback) => _focusSearchCallback = callback,
        onQueryReady: (callback) => _applyQueryCallback = callback,
      ),
      const ReservationsView(),
      ChangeNotifierProvider(
        create: (_) => ConversationsController(chatRepository),
        child: ConversationListScreen(
          onNavigateToSearch: () => navigateToSearch(),
        ),
      ),
      ProfileScreen(
        onNavigateToTab: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '$title\n(To be implemented)',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
