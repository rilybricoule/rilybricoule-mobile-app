import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../domain/conversation_model.dart';
import '../../data/prestataire_mock_data.dart';
import '../../widget/provider_header_wrapper.dart';
import 'chat_thread_view.dart';

class ProviderChatListView extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const ProviderChatListView({
    super.key,
    this.scaffoldKey,
  });

  @override
  State<ProviderChatListView> createState() => _ProviderChatListViewState();
}

class _ProviderChatListViewState extends State<ProviderChatListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conversations = PrestataireMockData.conversations;

    // Filter conversations
    final filteredConversations = _searchController.text.isEmpty
        ? conversations
        : conversations.where((c) {
      final clientName = c['clientName'].toString().toLowerCase();
      final query = _searchController.text.toLowerCase();
      return clientName.contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER COMPACT
            ProviderHeaderWrapper(
              scaffoldKey: widget.scaffoldKey,
              compact: true,
            ),

            // SEARCH BAR
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
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
                  fillColor: AppColors.surface,
                ),
              ),
            ),

            // LISTE DES CONVERSATIONS
            Expanded(
              child: filteredConversations.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _searchController.text.isNotEmpty
                          ? Icons.search_off
                          : Icons.chat_bubble_outline,
                      size: 64,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                    SizedBox(height: 16),
                    Text(
                      _searchController.text.isNotEmpty
                          ? 'No conversations found'
                          : 'No conversations yet',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                    if (_searchController.text.isNotEmpty) ...[
                      SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                        child: Text('Clear Search'),
                      ),
                    ],
                  ],
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: filteredConversations.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final c = filteredConversations[index];

                  return AppCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProviderChatThreadView(
                            conversation: Conversation.fromMap(c),
                          ),
                        ),
                      );
                    },
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppColors.providerPrimary.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                color: AppColors.providerPrimary,
                                size: 28,
                              ),
                            ),
                            // Active indicator
                            Positioned(
                              right: 2,
                              bottom: 2,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      c['clientName'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    c['timeLabel'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                c['lastMessage'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                  color: c['unreadCount'] > 0
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                  fontWeight: c['unreadCount'] > 0
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (c['unreadCount'] > 0) ...[
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.providerPrimary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${c['unreadCount']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}