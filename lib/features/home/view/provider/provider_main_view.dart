import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'ProviderDashboardView.dart';
import 'provider_bookings_view.dart';
import 'provider_chat_list_view.dart';
import 'provider_planning_view.dart';
import 'provider_profile_view.dart';
import '../../widgets/provider_bottom_nav_bar.dart';

class ProviderMainView extends StatefulWidget {
  const ProviderMainView({super.key});

  @override
  State<ProviderMainView> createState() => _ProviderMainViewState();
}

class _ProviderMainViewState extends State<ProviderMainView> {
  int _currentIndex = 0; // Start with Dashboard

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const ProviderDashboardView(),
      const ProviderBookingsView(),
      const ProviderChatListView(),
      const ProviderPlanningView(),
      const ProviderProfileView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
