import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_status_chip.dart';

// Your custom components
import '../widget/provider_app_header.dart';
import '../viewmodel/provider_state.dart';
import 'notifications_view.dart';
import 'earnings_view.dart';
import 'reviews_view.dart';

class ProviderDashboardView extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Function(int)? onNavigateToTab;  // NOUVEAU

  const ProviderDashboardView({
    super.key,
    this.scaffoldKey,
    this.onNavigateToTab,  // NOUVEAU
  });

  @override
  State<ProviderDashboardView> createState() => _ProviderDashboardViewState();
}

class _ProviderDashboardViewState extends State<ProviderDashboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
          },
          child: CustomScrollView(
            slivers: [
              // FIXED: Replaced manual header with Consumer + ProviderAppHeader
              SliverToBoxAdapter(
                child: Consumer<ProviderState>(
                  builder: (context, providerState, _) {
                    return ProviderAppHeader(
                      isOnline: providerState.isOnline,
                      onOnlineToggle: providerState.toggleOnline,
                      notificationCount: providerState.notificationCount,
                      onNotificationTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ProviderNotificationsView(),
                          ),
                        );
                      },
                      onAvatarTap: () {
                        widget.scaffoldKey?.currentState?.openDrawer();
                      },
                    );
                  },
                ),
              ),

              // STATS GRID
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.25,
                  ),
                  delegate: SliverChildListDelegate([
                    _StatCard(
                      icon: Icons.calendar_today,
                      value: '127',
                      label: 'Total bookings',
                      color: AppColors.providerPrimary,
                      trend: '+12%',
                      onTap: () {
                        // MODIFIÉ: Navigate to Bookings tab (index 2)
                        widget.onNavigateToTab?.call(2);
                      },
                    ),
                    _StatCard(
                      icon: Icons.attach_money,
                      value: '15,240',
                      label: 'Total revenue',
                      color: AppColors.success,
                      prefix: 'MAD',
                      trend: '+8%',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ProviderEarningsView()),
                        );
                      },
                    ),
                    _StatCard(
                      icon: Icons.pending_actions,
                      value: '8',
                      label: 'Pending requests',
                      color: AppColors.warning,
                      onTap: () {
                        // MODIFIÉ: Navigate to Bookings tab (index 2)
                        widget.onNavigateToTab?.call(2);
                      },
                    ),
                    _StatCard(
                      icon: Icons.star,
                      value: '4.8',
                      label: 'Average rating',
                      color: AppColors.info,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ProviderReviewsView()),
                        );
                      },
                    ),
                  ]),
                ),
              ),

              // RECENT BOOKINGS SECTION
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 6),
                    AppSectionHeader(
                      title: 'Recent bookings',
                      trailing: TextButton(
                        onPressed: () {
                          // MODIFIÉ: Navigate to Bookings tab
                          widget.onNavigateToTab?.call(2);
                        },
                        child: const Text('See all'),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _BookingPreviewCard(
                      clientName: 'Sarah Benjelloun',
                      service: 'Plumbing - Repair',
                      date: 'Today • 14:00',
                      statusLabel: 'Pending',
                      statusColor: AppColors.warning,
                      onTap: () => widget.onNavigateToTab?.call(2),  // NOUVEAU
                    ),
                    const SizedBox(height: 12),
                    _BookingPreviewCard(
                      clientName: 'Omar Mansouri',
                      service: 'Electricity',
                      date: 'Tomorrow • 10:30',
                      statusLabel: 'Confirmed',
                      statusColor: AppColors.success,
                      onTap: () => widget.onNavigateToTab?.call(2),  // NOUVEAU
                    ),
                  ]),
                ),
              ),

              // UPCOMING MISSIONS
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    AppSectionHeader(
                      title: 'Upcoming missions today',
                      trailing: TextButton(
                        onPressed: () {
                          // MODIFIÉ: Navigate to Planning tab
                          widget.onNavigateToTab?.call(3);
                        },
                        child: const Text('View Calendar'),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _MissionTodayCard(
                      clientName: 'Ayoub El Fassi',
                      service: 'Air Conditioning',
                      time: '16:30',
                      address: 'Hay Hassani, Casablanca',
                      onTap: () => widget.onNavigateToTab?.call(3),  // NOUVEAU
                    ),
                    const SizedBox(height: 12),
                    _MissionTodayCard(
                      clientName: 'Meriem Tazi',
                      service: 'Locksmith',
                      time: '18:45',
                      address: 'Oasis, Casablanca',
                      isUrgent: true,
                      onTap: () => widget.onNavigateToTab?.call(3),  // NOUVEAU
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _MissionTodayCard extends StatelessWidget {
  final String clientName;
  final String service;
  final String time;
  final String address;
  final bool isUrgent;
  final VoidCallback? onTap;  // NOUVEAU

  const _MissionTodayCard({
    required this.clientName,
    required this.service,
    required this.time,
    required this.address,
    this.isUrgent = false,
    this.onTap,  // NOUVEAU
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isUrgent
          ? BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.error.withOpacity(0.5),
          width: 1.5,
        ),
      )
          : null,
      child: AppCard(
        padding: const EdgeInsets.all(16),
        onTap: onTap,  // NOUVEAU
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.providerPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    time.split(':')[0],
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: AppColors.providerPrimary,
                    ),
                  ),
                  Text(
                    time.split(':')[1],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: AppColors.providerPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        clientName,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      if (isUrgent) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'URGENT',
                            style: TextStyle(color: AppColors.error, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(service, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          address,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.border),
          ],
        ),
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  final int badgeCount;
  final VoidCallback onPressed;

  const _NotificationButton({
    required this.badgeCount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: const Icon(Icons.notifications_outlined, color: Colors.white),
          ),
        ),
        if (badgeCount > 0)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text(
                '$badgeCount',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final String? trend;
  final String? prefix;
  final VoidCallback? onTap;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.trend,
    this.prefix,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (prefix != null) ...[
                    Text(
                      '$prefix ',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  Flexible(
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  if (trend != null) ...[
                    const SizedBox(width: 6),
                    Text(
                      trend!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BookingPreviewCard extends StatelessWidget {
  final String clientName;
  final String service;
  final String date;
  final String statusLabel;
  final Color statusColor;
  final VoidCallback? onTap;  // NOUVEAU

  const _BookingPreviewCard({
    required this.clientName,
    required this.service,
    required this.date,
    required this.statusLabel,
    required this.statusColor,
    this.onTap,  // NOUVEAU
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,  // MODIFIÉ
      padding: const EdgeInsets.all(14),
      child: Row(
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
                  clientName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  service,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          AppStatusChip(label: statusLabel, color: statusColor),
        ],
      ),
    );
  }
}