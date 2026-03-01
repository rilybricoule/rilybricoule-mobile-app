import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'dashboard_view.dart';
import 'bookings_view.dart';
import 'chat/chat_list_view.dart';
import 'planning_view.dart';
import 'services_view.dart';
import 'profile_view.dart';
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

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const ProviderDashboardView(),
      const ProviderServicesView(),
      const ProviderBookingsView(),
      const ProviderPlanningView(),
      const ProviderChatListView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ProviderDrawer(),  // AJOUTÉ
      body: _screens[_currentIndex],
      bottomNavigationBar: ProviderBottomNavBar(
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
