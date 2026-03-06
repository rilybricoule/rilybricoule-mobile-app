import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'dashboard_view.dart';
import 'bookings_view.dart';
import 'planning_view.dart';
import 'services_view.dart';
import 'profile/profile_view.dart';
import '../widget/provider_bottom_nav_bar.dart';
import '../widget/provider_drawer.dart';

class ProviderMainView extends StatefulWidget {
  const ProviderMainView({super.key});

  @override
  State<ProviderMainView> createState() => _ProviderMainViewState();
}

class _ProviderMainViewState extends State<ProviderMainView> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Callback pour changer de tab
  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //  Créer les screens ici pour passer le callback
    final screens = [
      ProviderDashboardView(
        scaffoldKey: _scaffoldKey,
        onNavigateToTab: _changeTab,
      ),
      ProviderServicesView(scaffoldKey: _scaffoldKey),
      ProviderBookingsView(scaffoldKey: _scaffoldKey),
      ProviderPlanningView(scaffoldKey: _scaffoldKey),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: const ProviderDrawer(),
      body: screens[_currentIndex],
      bottomNavigationBar: ProviderBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _changeTab,  // Utiliser le callback
      ),
    );
  }
}