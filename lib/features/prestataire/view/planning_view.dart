import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../widget/provider_header_wrapper.dart';

class ProviderPlanningView extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const ProviderPlanningView({
    super.key,
    this.scaffoldKey,
  });

  @override
  State<ProviderPlanningView> createState() => _ProviderPlanningViewState();
}

class _ProviderPlanningViewState extends State<ProviderPlanningView> {
  DateTime _selectedDate = DateTime.now();
  String _filterStatus = 'All'; // All, Available, Booked, Blocked

  // NOUVEAU: Mock data avec couleurs par jour pour le calendrier
  final Map<DateTime, List<Color>> _availability = {
    DateTime(2026, 3, 1): [Colors.green],
    DateTime(2026, 3, 2): [Colors.red, Colors.green],
    DateTime(2026, 3, 3): [Colors.green, Colors.green, Colors.green],
    DateTime(2026, 3, 4): [Colors.red],
    DateTime(2026, 3, 5): [Colors.grey],
    DateTime(2026, 3, 6): [Colors.green, Colors.green],
    DateTime(2026, 3, 7): [Colors.grey],
    DateTime(2026, 3, 8): [Colors.green],
    DateTime(2026, 3, 9): [Colors.red, Colors.red],
    DateTime(2026, 3, 10): [Colors.green, Colors.green, Colors.green],
    DateTime(2026, 3, 11): [Colors.green],
    DateTime(2026, 3, 12): [Colors.red],
    DateTime(2026, 3, 13): [Colors.green, Colors.green],
    DateTime(2026, 3, 14): [Colors.grey],
  };

  // NOUVEAU: Get events for day
  List<Color> _getEventsForDay(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    return _availability[date] ?? [];
  }

  // Mock data - groupé par jour
  final Map<String, List<Map<String, dynamic>>> _slotsByDay = {
    'Mon 3 March': [
      {'time': '09:00-10:30', 'status': 'Available', 'color': Colors.green},
      {'time': '11:00-12:30', 'status': 'Booked', 'client': 'Sarah B.', 'color': Colors.red},
      {'time': '14:00-15:30', 'status': 'Available', 'color': Colors.green},
      {'time': '16:00-17:30', 'status': 'Blocked', 'color': Colors.grey},
    ],
    'Tue 4 March': [
      {'time': '09:00-10:30', 'status': 'Available', 'color': Colors.green},
      {'time': '14:00-16:00', 'status': 'Booked', 'client': 'Omar M.', 'color': Colors.red},
    ],
    'Wed 5 March': [
      {'time': '10:00-12:00', 'status': 'Available', 'color': Colors.green},
    ],
    'Thu 6 March': [
      {'time': 'No slots', 'status': 'Blocked', 'color': Colors.grey},
    ],
  };

  void _showCalendarModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Date',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedDate = DateTime.now();
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Today'),
                  ),
                ],
              ),
            ),

            // NOUVEAU: Légende
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(Colors.green, 'Available'),
                  SizedBox(width: 12),
                  _buildLegendItem(Colors.red, 'Booked'),
                  SizedBox(width: 12),
                  _buildLegendItem(Colors.grey, 'Blocked'),
                ],
              ),
            ),

            // Calendar
            Expanded(
              child: TableCalendar(
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _selectedDate,
                selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                  });
                  Navigator.pop(context);
                },
                // NOUVEAU: Event loader
                eventLoader: _getEventsForDay,
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: AppColors.providerPrimary.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: AppColors.providerPrimary,
                    shape: BoxShape.circle,
                  ),
                  // NOUVEAU: Marker styling
                  markerSize: 6,
                  markerMargin: EdgeInsets.symmetric(horizontal: 1),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                // NOUVEAU: Calendar builders pour les markers
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isEmpty) return null;
                    return Positioned(
                      bottom: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: (events as List<Color>).take(3).map((color) {
                          return Container(
                            width: 6,
                            height: 6,
                            margin: EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Filter Slots',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            RadioListTile<String>(
              title: Text('All Slots'),
              value: 'All',
              groupValue: _filterStatus,
              onChanged: (v) {
                setState(() => _filterStatus = v!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text('Available Only'),
              value: 'Available',
              groupValue: _filterStatus,
              onChanged: (v) {
                setState(() => _filterStatus = v!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text('Booked Only'),
              value: 'Booked',
              groupValue: _filterStatus,
              onChanged: (v) {
                setState(() => _filterStatus = v!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text('Blocked Only'),
              value: 'Blocked',
              groupValue: _filterStatus,
              onChanged: (v) {
                setState(() => _filterStatus = v!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickTemplates() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Quick Templates',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.work, color: AppColors.providerPrimary),
              title: Text('Full-Time Worker'),
              subtitle: Text('Mon-Fri, 9:00-17:00'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Template applied: Full-Time Worker')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.weekend, color: AppColors.providerPrimary),
              title: Text('Weekend Warrior'),
              subtitle: Text('Sat-Sun, 8:00-18:00'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Template applied: Weekend Warrior')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.schedule, color: AppColors.providerPrimary),
              title: Text('Flexible Hours'),
              subtitle: Text('Custom schedule'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Template applied: Flexible')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            // HEADER COMPACT
            ProviderHeaderWrapper(
              scaffoldKey: widget.scaffoldKey,
              compact: true,
            ),

            // TITRE + ACTIONS
            Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
              color: AppColors.surface,
              child: Row(
                children: [
                  Text(
                    'Planning',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Spacer(),
                  // Calendar icon
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.providerPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.calendar_today, color: AppColors.providerPrimary, size: 20),
                      onPressed: _showCalendarModal,
                      tooltip: 'Calendar',
                    ),
                  ),
                  SizedBox(width: 8),
                  // Filter icon
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.providerPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.filter_list, color: AppColors.providerPrimary, size: 20),
                      onPressed: _showFilterModal,
                      tooltip: 'Filter',
                    ),
                  ),
                  SizedBox(width: 8),
                  // Settings icon
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.providerPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.settings_outlined, color: AppColors.providerPrimary, size: 20),
                      onPressed: _showQuickTemplates,
                      tooltip: 'Templates',
                    ),
                  ),
                ],
              ),
            ),

            // MINI HEADER - MOIS + TODAY BUTTON
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.surface,
              child: Row(
                children: [
                  Icon(Icons.event, color: AppColors.providerPrimary, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'March 2026',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Spacer(),
                  if (_filterStatus != 'All')
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.providerPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _filterStatus,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.providerPrimary,
                        ),
                      ),
                    ),
                  SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedDate = DateTime.now();
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.providerPrimary),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: Text(
                      'Today',
                      style: TextStyle(
                        color: AppColors.providerPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Divider(height: 1),

            // SLOTS LIST
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _slotsByDay.keys.length,
                itemBuilder: (context, index) {
                  final day = _slotsByDay.keys.elementAt(index);
                  final slots = _slotsByDay[day]!;

                  // Filter slots if needed
                  final filteredSlots = _filterStatus == 'All'
                      ? slots
                      : slots.where((s) => s['status'] == _filterStatus).toList();

                  if (filteredSlots.isEmpty && _filterStatus != 'All') {
                    return SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Day header
                      Padding(
                        padding: EdgeInsets.only(bottom: 12, top: index > 0 ? 16 : 0),
                        child: Text(
                          day,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      // Slots for this day
                      ...filteredSlots.map((slot) => _buildSlotCard(slot)).toList(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Add slot - Coming soon')),
          );
        },
        backgroundColor: AppColors.providerPrimary,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Slot',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // NOUVEAU: Widget helper pour la légende
  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSlotCard(Map<String, dynamic> slot) {
    final isBooked = slot['status'] == 'Booked';
    final color = slot['color'] as Color;

    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: AppCard(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Status indicator
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 16),
            // Time + Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slot['time'],
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (isBooked && slot['client'] != null) ...[
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.person, size: 14, color: AppColors.textSecondary),
                        SizedBox(width: 4),
                        Text(
                          slot['client'],
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // Status label
            if (!isBooked)
              Text(
                slot['status'],
                style: TextStyle(
                  color: color == Colors.green ? AppColors.success : AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            SizedBox(width: 8),
            // More menu
            Icon(Icons.more_vert, size: 18, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}