import 'package:rilybricoule_mobile_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_status_chip.dart';
import 'mission_details_view.dart';

class ProviderBookingsView extends StatefulWidget {
  const ProviderBookingsView({super.key});

  @override
  State<ProviderBookingsView> createState() => _ProviderBookingsViewState();
}

class _ProviderBookingsViewState extends State<ProviderBookingsView> {
  final List<_MockBooking> _bookings = const [
    _MockBooking(
      id: 'b1',
      clientName: 'Sarah Benjelloun',
      serviceName: 'Plumbing - Repair',
      dateLabel: 'Today • 14:00',
      address: 'Maarif, Casablanca',
      priceLabel: '150 MAD/hr',
      status: _BookingStatus.upcoming,
    ),
    _MockBooking(
      id: 'b2',
      clientName: 'Omar Mansouri',
      serviceName: 'Electricity',
      dateLabel: 'Tomorrow • 10:30',
      address: 'Bourgogne, Casablanca',
      priceLabel: '200 MAD/hr',
      status: _BookingStatus.upcoming,
    ),
    _MockBooking(
      id: 'b3',
      clientName: 'Imane Zahra',
      serviceName: 'Painting',
      dateLabel: 'Now',
      address: 'Gauthier, Casablanca',
      priceLabel: '350 MAD/hr',
      status: _BookingStatus.inProgress,
    ),
    _MockBooking(
      id: 'b4',
      clientName: 'Youssef A.',
      serviceName: 'Handyman',
      dateLabel: 'Yesterday • 16:00',
      address: 'Sidi Maarouf, Casablanca',
      priceLabel: '120 MAD/hr',
      status: _BookingStatus.completed,
    ),
    _MockBooking(
      id: 'b5',
      clientName: 'Khadija B.',
      serviceName: 'Cleaning',
      dateLabel: '05 Feb • 11:00',
      address: 'Ain Diab, Casablanca',
      priceLabel: '100 MAD/hr',
      status: _BookingStatus.cancelled,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Bookings'),
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Upcoming'),
              Tab(text: 'In progress'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _BookingsList(
              bookings: _bookings.where((b) => b.status == _BookingStatus.upcoming).toList(),
              emptyLabel: 'No upcoming bookings',
              showActions: true,
            ),
            _BookingsList(
              bookings:
              _bookings.where((b) => b.status == _BookingStatus.inProgress).toList(),
              emptyLabel: 'No bookings in progress',
              showActions: false,
            ),
            _BookingsList(
              bookings: _bookings.where((b) => b.status == _BookingStatus.completed).toList(),
              emptyLabel: 'No completed bookings',
              showActions: false,
            ),
            _BookingsList(
              bookings: _bookings.where((b) => b.status == _BookingStatus.cancelled).toList(),
              emptyLabel: 'No cancelled bookings',
              showActions: false,
            ),
          ],
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
        child: Text(
          emptyLabel,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textSecondary),
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
                      color: AppColors.primary.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.event_note, color: AppColors.primary),
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
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 16, color: AppColors.textSecondary),
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
        return 'In progress';
      case _BookingStatus.completed:
        return 'Completed';
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