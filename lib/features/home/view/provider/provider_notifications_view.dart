import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

class ProviderNotificationsView extends StatefulWidget {
  const ProviderNotificationsView({super.key});

  @override
  State<ProviderNotificationsView> createState() =>
      _ProviderNotificationsViewState();
}

class _ProviderNotificationsViewState extends State<ProviderNotificationsView> {
  final List<_MockNotification> _items = [
    _MockNotification(
      id: 'n1',
      title: 'New booking request',
      message: 'Sarah requested “Plumbing Repair” for today at 14:00.',
      timeLabel: '2 min',
      read: false,
    ),
    _MockNotification(
      id: 'n2',
      title: 'Payment reminder',
      message: 'Don’t forget to confirm the cash payment after service.',
      timeLabel: '1 h',
      read: false,
    ),
    _MockNotification(
      id: 'n3',
      title: 'New review received',
      message: 'You received a 5-star review on your last service.',
      timeLabel: 'Yesterday',
      read: true,
    ),
  ];

  final Set<String> _selected = {};

  bool get _selectionMode => _selected.isNotEmpty;

  void _toggleSelect(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selected.clear();
    });
  }

  void _deleteSelected() {
    setState(() {
      _items.removeWhere((n) => _selected.contains(n.id));
      _selected.clear();
    });
  }

  void _markRead(String id) {
    setState(() {
      final idx = _items.indexWhere((n) => n.id == id);
      if (idx == -1) return;
      _items[idx] = _items[idx].copyWith(read: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = _selectionMode ? '${_selected.length} selected' : 'Notifications';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          if (_selectionMode) ...[
            IconButton(
              tooltip: 'Delete',
              onPressed: _deleteSelected,
              icon: const Icon(Icons.delete_outline),
            ),
            IconButton(
              tooltip: 'Cancel',
              onPressed: _clearSelection,
              icon: const Icon(Icons.close),
            ),
          ],
        ],
      ),
      body: _items.isEmpty
          ? Center(
              child: Text(
                'No notifications',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final n = _items[index];
                final selected = _selected.contains(n.id);

                return AppCard(
                  onTap: () {
                    if (_selectionMode) {
                      _toggleSelect(n.id);
                      return;
                    }
                    _markRead(n.id);
                  },
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => _toggleSelect(n.id),
                        child: Container(
                          width: 22,
                          height: 22,
                          margin: const EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected
                                ? AppColors.primary
                                : AppColors.primary.withOpacity(0.08),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          child: selected
                              ? const Icon(Icons.check,
                                  size: 14, color: Colors.white)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    n.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight:
                                              n.read ? FontWeight.w500 : FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  n.timeLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              n.message,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (!n.read)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(top: 6),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _MockNotification {
  final String id;
  final String title;
  final String message;
  final String timeLabel;
  final bool read;

  const _MockNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timeLabel,
    required this.read,
  });

  _MockNotification copyWith({bool? read}) {
    return _MockNotification(
      id: id,
      title: title,
      message: message,
      timeLabel: timeLabel,
      read: read ?? this.read,
    );
  }
}
