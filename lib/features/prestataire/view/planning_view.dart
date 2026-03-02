import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section_header.dart';

class ProviderPlanningView extends StatefulWidget {
  const ProviderPlanningView({super.key});

  @override
  State<ProviderPlanningView> createState() => _ProviderPlanningViewState();
}

class _ProviderPlanningViewState extends State<ProviderPlanningView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Mock data for availability markers
  // Green: available, Red: booked, Gray: blocked
  final Map<DateTime, List<Color>> _events = {
    DateTime(2026, 3, 1): [Colors.green],
    DateTime(2026, 3, 2): [Colors.red, Colors.green],
    DateTime(2026, 3, 3): [Colors.green, Colors.green, Colors.green],
    DateTime(2026, 3, 4): [Colors.red],
    DateTime(2026, 3, 5): [Colors.grey],
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  List<Color> _getEventsForDay(DateTime day) {
    // Normalize day to midnight for map lookup
    final date = DateTime(day.year, day.month, day.day);
    return _events[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Planning & Calendrier'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined, color: AppColors.primary),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCalendarSection(),
          const Divider(height: 1),
          Expanded(child: _buildSlotsSection()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Gérer les créneaux', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      color: AppColors.surface,
      child: TableCalendar(
        firstDay: DateTime.utc(2025, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        eventLoader: _getEventsForDay,
        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          markerSize: 7,
          markerMargin: EdgeInsets.symmetric(horizontal: 0.5),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (events.isEmpty) return null;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: (events as List<Color>).map((color) {
                return Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSlotsSection() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Créneaux du ${_selectedDay?.day}/${_selectedDay?.month}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Text(
              'Disponible',
              style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSlotItem('09:00 - 10:30', 'Libre', Colors.green),
        _buildSlotItem('11:00 - 12:30', 'Réservé (Sarah B.)', Colors.red),
        _buildSlotItem('14:00 - 15:30', 'Libre', Colors.green),
        _buildSlotItem('16:00 - 17:30', 'Bloqué', Colors.grey),
        const SizedBox(height: 80), // Space for FAB
      ],
    );
  }

  Widget _buildSlotItem(String time, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                time,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
            Text(
              status,
              style: TextStyle(
                color: color == Colors.red ? AppColors.error : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: color == Colors.red ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.more_vert, size: 18, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

