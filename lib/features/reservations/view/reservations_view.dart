import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../data/mock_reservations_repository.dart';
import '../models/reservation_status.dart';
import '../viewmodel/reservations_viewmodel.dart';
import '../widgets/reservation_card.dart';

class ReservationsView extends StatelessWidget {
  final int? initialTabIndex;

  const ReservationsView({super.key, this.initialTabIndex});

  @override
  Widget build(BuildContext context) {
    // Create a shared repository instance so changes persist
    final listRepository = MockReservationsRepository();
    
    return ChangeNotifierProvider(
      create: (_) => ReservationsViewModel(listRepository)..loadReservations(),
      child: _ReservationsContent(
        initialTabIndex: initialTabIndex,
        listRepository: listRepository,
      ),
    );
  }
}

class _ReservationsContent extends StatefulWidget {
  final int? initialTabIndex;
  final MockReservationsRepository listRepository;

  const _ReservationsContent({
    this.initialTabIndex,
    required this.listRepository,
  });

  @override
  State<_ReservationsContent> createState() => _ReservationsContentState();
}

class _ReservationsContentState extends State<_ReservationsContent> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTabIndex ?? 0,
    );
    _tabController.addListener(_onTabChanged);
  }

  @override
  void didUpdateWidget(_ReservationsContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTabIndex != null && widget.initialTabIndex != oldWidget.initialTabIndex) {
      _tabController.animateTo(widget.initialTabIndex!);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final viewModel = context.read<ReservationsViewModel>();
    viewModel.selectTab(ReservationStatus.values[_tabController.index]);
  }

  // Method to switch to cancelled tab
  void _navigateToCancelledTab() {
    // Index 3 is the cancelled tab
    _tabController.animateTo(3);
    final viewModel = context.read<ReservationsViewModel>();
    viewModel.selectTab(ReservationStatus.cancelled);
    // Refresh to show updated data
    viewModel.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            _buildTabBar(),
            Expanded(child: _buildTabBarView()),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
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
          Expanded(
            child: Text(
              'Mes Réservations',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.mainAppPrimary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.mainAppPrimary,
        indicatorWeight: 3,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        tabs: ReservationStatus.values.map((status) {
          return Tab(text: status.tabLabel);
        }).toList(),
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: ReservationStatus.values.map((status) {
        return _buildTabContent(status);
      }).toList(),
    );
  }

  Widget _buildTabContent(ReservationStatus status) {
    return Consumer<ReservationsViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.mainAppPrimary),
          );
        }

        if (viewModel.error != null) {
          return Center(
            child: Text(
              'Erreur: ${viewModel.error}',
              style: GoogleFonts.poppins(color: AppColors.error),
            ),
          );
        }

        final reservations = viewModel.filteredReservations;

        if (reservations.isEmpty) {
          return _buildEmptyState(context, status);
        }

        return RefreshIndicator(
          onRefresh: viewModel.refresh,
          color: AppColors.mainAppPrimary,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              return ReservationCard(
                reservation: reservation,
                onViewDetails: () async {
                  // Navigate to details and wait for result
                  final result = await Navigator.pushNamed(
                    context,
                    AppRoutes.reservationDetails,
                    arguments: {
                      'reservationId': reservation.id,
                      'listRepository': widget.listRepository,
                    },
                  );
                  
                  // If cancelled, refresh and navigate to cancelled tab
                  if (result == 'cancelled') {
                    final viewModel = context.read<ReservationsViewModel>();
                    await viewModel.refresh();
                    _navigateToCancelledTab();
                  }
                },
                onLeaveReview: reservation.canReview
                    ? () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.leaveReview,
                          arguments: reservation.id,
                        );
                      }
                    : null,
                onViewInvoice: reservation.status == ReservationStatus.completed
                    ? () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.invoice,
                          arguments: reservation.id,
                        );
                      }
                    : null,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, ReservationStatus status) {
    String message;
    switch (status) {
      case ReservationStatus.upcoming:
        message = 'Aucune réservation à venir';
        break;
      case ReservationStatus.ongoing:
        message = 'Aucune réservation en cours';
        break;
      case ReservationStatus.completed:
        message = 'Aucune réservation terminée';
        break;
      case ReservationStatus.cancelled:
        message = 'Aucune réservation annulée';
        break;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to search tab (index 1)
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainAppPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Explorer des prestataires',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}