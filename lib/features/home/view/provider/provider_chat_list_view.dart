import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

class ProviderChatListView extends StatelessWidget {
  const ProviderChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    final conversations = <_MockConversation>[
      const _MockConversation(
        id: 'c1',
        clientName: 'Sarah Benjelloun',
        lastMessage: 'Thank you for your help!',
        timeLabel: '2 min',
        unreadCount: 2,
      ),
      const _MockConversation(
        id: 'c2',
        clientName: 'Omar Mansouri',
        lastMessage: 'Can you come earlier?',
        timeLabel: '1 h',
        unreadCount: 0,
      ),
      const _MockConversation(
        id: 'c3',
        clientName: 'Imane Zahra',
        lastMessage: 'Perfect, see you tomorrow.',
        timeLabel: 'Yesterday',
        unreadCount: 0,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: conversations.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final c = conversations[index];

          return AppCard(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Open chat with ${c.clientName} (mock)')),
              );
            },
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.person_outline, color: AppColors.primary),
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
                              c.clientName,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            c.timeLabel,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        c.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                if (c.unreadCount > 0) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${c.unreadCount}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MockConversation {
  final String id;
  final String clientName;
  final String lastMessage;
  final String timeLabel;
  final int unreadCount;

  const _MockConversation({
    required this.id,
    required this.clientName,
    required this.lastMessage,
    required this.timeLabel,
    required this.unreadCount,
  });
}

