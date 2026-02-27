import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../controllers/conversations_controller.dart';
import '../widgets/conversation_tile.dart';

class ConversationListScreen extends StatefulWidget {
  final Function() onNavigateToSearch;

  const ConversationListScreen({
    super.key,
    required this.onNavigateToSearch,
  });

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildSearchBar(),
            Expanded(child: _buildConversationList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Nouveau message',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Trouvez un prestataire pour commencer une conversation',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onNavigateToSearch();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainAppPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: Text(
                      'Explorer des prestataires',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        backgroundColor: AppColors.mainAppPrimary,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildAppBar() {
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
              'Messages',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.mainAppPrimary,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<ConversationsController>().clearSearch();
                }
              });
            },
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: AppColors.mainAppPrimary,
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Options (bientôt)', style: GoogleFonts.poppins()),
                ),
              );
            },
            icon: const Icon(Icons.more_vert, color: AppColors.mainAppPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    if (!_isSearching) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Rechercher une conversation...',
          hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          filled: true,
          fillColor: AppColors.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (query) {
          context.read<ConversationsController>().search(query);
        },
      ),
    );
  }

  Widget _buildConversationList() {
    return Consumer<ConversationsController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.mainAppPrimary),
          );
        }

        if (controller.error != null) {
          return Center(
            child: Text(
              'Erreur: ${controller.error}',
              style: GoogleFonts.poppins(color: AppColors.error),
            ),
          );
        }

        if (!controller.hasConversations) {
          return _buildEmptyState();
        }

        if (controller.conversations.isEmpty && _isSearching) {
          return _buildNoResultsState();
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          color: AppColors.mainAppPrimary,
          child: ListView.separated(
            itemCount: controller.conversations.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              indent: 72,
              color: AppColors.border,
            ),
            itemBuilder: (context, index) {
              final conversation = controller.conversations[index];
              return ConversationTile(
                conversation: conversation,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/chat/${conversation.id}',
                    arguments: conversation,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.mainAppPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 60,
                color: AppColors.mainAppPrimary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Aucune conversation pour le moment',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Vos conversations avec les prestataires apparaîtront ici après une réservation ou un premier contact.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: widget.onNavigateToSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainAppPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Explorer des prestataires',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Aucun résultat',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Essayez avec un autre terme de recherche',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                _searchController.clear();
                context.read<ConversationsController>().clearSearch();
              },
              child: Text(
                'Réinitialiser la recherche',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mainAppPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
