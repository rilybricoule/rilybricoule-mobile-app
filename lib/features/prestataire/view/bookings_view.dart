import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../widget/provider_header_wrapper.dart';
import 'mission_details_view.dart';

class ProviderBookingsView extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const ProviderBookingsView({
    super.key,
    this.scaffoldKey,
  });

  @override
  State<ProviderBookingsView> createState() => _ProviderBookingsViewState();
}

class _ProviderBookingsViewState extends State<ProviderBookingsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<_MockBooking> _bookings = const [
    _MockBooking(
      id: 'b1',
      clientName: 'Sarah Benjelloun',
      serviceName: 'Plumbing - Repair',
      dateLabel: 'Today • 14:00',
      address: 'Maarif, Casablanca',
      priceLabel: '150 MAD',
      status: _BookingStatus.upcoming,
    ),
    _MockBooking(
      id: 'b2',
      clientName: 'Omar Mansouri',
      serviceName: 'Electricity',
      dateLabel: 'Tomorrow • 10:30',
      address: 'Bourgogne, Casablanca',
      priceLabel: '200 MAD',
      status: _BookingStatus.upcoming,
    ),
    _MockBooking(
      id: 'b3',
      clientName: 'Imane Zahra',
      serviceName: 'Painting',
      dateLabel: 'Now',
      address: 'Gauthier, Casablanca',
      priceLabel: '350 MAD',
      status: _BookingStatus.inProgress,
    ),
    _MockBooking(
      id: 'b4',
      clientName: 'Youssef A.',
      serviceName: 'Handyman',
      dateLabel: 'Yesterday • 16:00',
      address: 'Sidi Maarouf, Casablanca',
      priceLabel: '120 MAD',
      status: _BookingStatus.completed,
    ),
    _MockBooking(
      id: 'b5',
      clientName: 'Khadija B.',
      serviceName: 'Cleaning',
      dateLabel: '05 Feb • 11:00',
      address: 'Ain Diab, Casablanca',
      priceLabel: '100 MAD/h',
      status: _BookingStatus.cancelled,
    ),
  ];

  // Get filtered bookings
  List<_MockBooking> _getFilteredBookings(_BookingStatus status) {
    var filtered = _bookings.where((b) => b.status == status).toList();

    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((booking) {
        final clientName = booking.clientName.toLowerCase();
        final query = _searchController.text.toLowerCase();
        return clientName.contains(query);
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // HEADER COMPACT
              ProviderHeaderWrapper(
                scaffoldKey: widget.scaffoldKey,
                compact: true,
              ),

              // SEARCH + TABBAR
              Container(
                color: AppColors.surface,
                child: Column(
                  children: [
                    // SEARCH BAR
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Search by client name...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                            icon: Icon(Icons.clear, size: 20),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                              });
                            },
                          )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),

                    // TABBAR
                    TabBar(
                      labelColor: AppColors.providerPrimary,
                      unselectedLabelColor: AppColors.textSecondary,
                      indicatorColor: AppColors.providerPrimary,
                      indicatorWeight: 3,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                      ),
                      tabs: const [
                        Tab(text: 'Upcoming'),
                        Tab(text: 'Active'),
                        Tab(text: 'Done'),
                        Tab(text: 'Cancelled'),
                      ],
                    ),
                  ],
                ),
              ),

              // TABBAR VIEW
              Expanded(
                child: TabBarView(
                  children: [
                    _BookingsList(
                      bookings: _getFilteredBookings(_BookingStatus.upcoming),
                      emptyLabel: _searchController.text.isNotEmpty
                          ? 'No upcoming bookings found'
                          : 'No upcoming bookings',
                      showActions: true,
                    ),
                    _BookingsList(
                      bookings: _getFilteredBookings(_BookingStatus.inProgress),
                      emptyLabel: _searchController.text.isNotEmpty
                          ? 'No active bookings found'
                          : 'No active bookings',
                      showActions: false,
                    ),
                    _BookingsList(
                      bookings: _getFilteredBookings(_BookingStatus.completed),
                      emptyLabel: _searchController.text.isNotEmpty
                          ? 'No completed bookings found'
                          : 'No completed bookings',
                      showActions: false,
                    ),
                    _BookingsList(
                      bookings: _getFilteredBookings(_BookingStatus.cancelled),
                      emptyLabel: _searchController.text.isNotEmpty
                          ? 'No cancelled bookings found'
                          : 'No cancelled bookings',
                      showActions: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingsList extends StatelessWidget {
  final List<_MockBooking> bookings;
  final String emptyLabel;
  final bool showActions;

  const _BookingsList({
    required this.bookings,
    required this.emptyLabel,
    required this.showActions,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            SizedBox(height: 16),
            Text(
              emptyLabel,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final b = bookings[index];

        return AppCard(
          onTap: () {},
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.providerPrimary.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.person, color: AppColors.providerPrimary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b.clientName,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          b.serviceName,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  AppStatusChip(
                    label: b.status.label,
                    color: b.status.color,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      b.dateLabel,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                  Text(
                    b.priceLabel,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.providerPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      b.address,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
              if (showActions) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Booking declined (mock)')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                        ),
                        child: const Text('Decline'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProviderMissionDetailsView(
                                clientName: b.clientName,
                                serviceName: b.serviceName,
                                address: b.address,
                              ),
                            ),
                          );
                        },
                        child: const Text('Accept'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

enum _BookingStatus { upcoming, inProgress, completed, cancelled }

extension on _BookingStatus {
  String get label {
    switch (this) {
      case _BookingStatus.upcoming:
        return 'Upcoming';
      case _BookingStatus.inProgress:
        return 'Active';
      case _BookingStatus.completed:
        return 'Done';
      case _BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case _BookingStatus.upcoming:
        return AppColors.warning;
      case _BookingStatus.inProgress:
        return AppColors.info;
      case _BookingStatus.completed:
        return AppColors.success;
      case _BookingStatus.cancelled:
        return AppColors.error;
    }
  }
}

class _MockBooking {
  final String id;
  final String clientName;
  final String serviceName;
  final String dateLabel;
  final String address;
  final String priceLabel;
  final _BookingStatus status;

  const _MockBooking({
    required this.id,
    required this.clientName,
    required this.serviceName,
    required this.dateLabel,
    required this.address,
    required this.priceLabel,
    required this.status,
  });
}