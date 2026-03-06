import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

class ProviderStatisticsView extends StatefulWidget {
  const ProviderStatisticsView({super.key});

  @override
  State<ProviderStatisticsView> createState() => _ProviderStatisticsViewState();
}

class _ProviderStatisticsViewState extends State<ProviderStatisticsView> {
  String _selectedPeriod = '30 days';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Statistics'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            initialValue: _selectedPeriod,
            icon: Row(
              children: [
                Text(
                  _selectedPeriod,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.providerPrimary,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, color: AppColors.providerPrimary),
              ],
            ),
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: '7 days', child: Text('Last 7 days')),
              PopupMenuItem(value: '30 days', child: Text('Last 30 days')),
              PopupMenuItem(value: '90 days', child: Text('Last 90 days')),
              PopupMenuItem(value: 'All time', child: Text('All time')),
            ],
          ),
          SizedBox(width: 8),
        ],
      ),
      body: ListView(
        // MODIFIÉ: Padding réduit + bottom padding pour le system bar
        padding: EdgeInsets.only(
          left: 12,  // RÉDUIT de 16 à 12
          right: 12,  // RÉDUIT de 16 à 12
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,  // AJOUTÉ: Padding système
        ),
        children: [
          // OVERVIEW CARDS
          _buildOverviewSection(),
          SizedBox(height: 24),

          // REVENUE CHART
          _buildRevenueChart(),
          SizedBox(height: 24),

          // BOOKINGS TREND
          _buildBookingsTrend(),
          SizedBox(height: 24),

          // TOP SERVICES
          _buildTopServices(),
          SizedBox(height: 24),

          // PERFORMANCE METRICS
          _buildPerformanceMetrics(),
          SizedBox(height: 24),

          // BEST TIMES
          _buildBestTimes(),
        ],
      ),
    );
  }

  Widget _buildOverviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                icon: Icons.attach_money,
                label: 'Revenue',
                value: '15,240 MAD',
                change: '+12%',
                changePositive: true,
                color: AppColors.success,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                icon: Icons.calendar_today,
                label: 'Bookings',
                value: '127',
                change: '+8%',
                changePositive: true,
                color: AppColors.providerPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                icon: Icons.star,
                label: 'Avg Rating',
                value: '4.8',
                change: '+0.2',
                changePositive: true,
                color: Colors.amber,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                icon: Icons.check_circle,
                label: 'Completion',
                value: '96%',
                change: '+4%',
                changePositive: true,
                color: AppColors.info,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required String change,
    required bool changePositive,
    required Color color,
  }) {
    return AppCard(
      padding: EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(  // AJOUTÉ: Pour éviter overflow
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (changePositive ? AppColors.success : AppColors.error)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: changePositive ? AppColors.success : AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    return AppCard(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Revenue Trend',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.show_chart, color: AppColors.providerPrimary),
            ],
          ),
          SizedBox(height: 16),

          // MODIFIÉ: Ajouté SizedBox pour contraindre la largeur
          SizedBox(
            height: 150,
            width: double.infinity,  // AJOUTÉ
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) {
                final heights = [60.0, 80.0, 70.0, 120.0, 90.0, 110.0, 100.0];
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 3),  // RÉDUIT de 4 à 3
                    height: heights[index],
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.providerPrimary,
                          AppColors.providerPrimary.withOpacity(0.5),
                        ],
                      ),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map((day) => Expanded(
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsTrend() {
    return AppCard(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bookings by Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _buildProgressBar('Completed', 96, AppColors.success),
          SizedBox(height: 12),
          _buildProgressBar('Pending', 8, AppColors.warning),
          SizedBox(height: 12),
          _buildProgressBar('Cancelled', 4, AppColors.error),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String label, int value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / 127,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildTopServices() {
    final services = [
      {'name': 'Plumbing Repair', 'bookings': 45, 'revenue': '6,750 MAD'},
      {'name': 'Electrical Work', 'bookings': 38, 'revenue': '5,700 MAD'},
      {'name': 'Painting', 'bookings': 28, 'revenue': '4,200 MAD'},
    ];

    return AppCard(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Services',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.emoji_events, color: Colors.amber),
            ],
          ),
          SizedBox(height: 16),
          ...services.asMap().entries.map((entry) {
            final index = entry.key;
            final service = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: index < 2 ? 12 : 0),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: index == 0
                          ? Colors.amber.withOpacity(0.2)
                          : AppColors.providerPrimary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: index == 0 ? Colors.amber[700] : AppColors.providerPrimary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service['name'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${service['bookings']} bookings',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    service['revenue'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.providerPrimary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    return AppCard(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Metrics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _buildMetricRow(
            icon: Icons.attach_money,
            label: 'Avg. Earnings/Booking',
            value: '120 MAD',
            color: AppColors.success,
          ),
          Divider(height: 24),
          _buildMetricRow(
            icon: Icons.access_time,
            label: 'Avg. Response Time',
            value: '12 min',
            color: AppColors.info,
          ),
          Divider(height: 24),
          _buildMetricRow(
            icon: Icons.check_circle,
            label: 'Completion Rate',
            value: '96%',
            color: AppColors.providerPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 14),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildBestTimes() {
    return AppCard(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Best Performance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildBestTimeCard(
                  icon: Icons.calendar_today,
                  label: 'Best Day',
                  value: 'Saturday',
                  subValue: '24 bookings',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildBestTimeCard(
                  icon: Icons.access_time,
                  label: 'Best Hour',
                  value: '14:00-16:00',
                  subValue: '18 bookings',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBestTimeCard({
    required IconData icon,
    required String label,
    required String value,
    required String subValue,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.providerPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.providerPrimary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.providerPrimary, size: 20),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.providerPrimary,
            ),
          ),
          Text(
            subValue,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}