import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../controllers/chat_thread_controller.dart';
import '../../domain/models/conversation.dart';
import '../../domain/models/message.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/date_separator.dart';
import '../widgets/message_bubble.dart';

class ChatThreadScreen extends StatefulWidget {
  final Conversation conversation;

  const ChatThreadScreen({
    super.key,
    required this.conversation,
  });

  @override
  State<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends State<ChatThreadScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          Consumer<ChatThreadController>(
            builder: (context, controller, child) {
              return ChatInputBar(
                onSendText: (text) {
                  controller.sendText(text);
                  _scrollToBottom();
                },
                onSendImage: (imageUrl) {
                  controller.sendImage(imageUrl);
                  _scrollToBottom();
                },
                onSendVoice: (voiceUrl, duration) {
                  controller.sendVoice(voiceUrl, duration);
                  _scrollToBottom();
                },
                onSendLocation: (lat, lng, label) {
                  controller.sendLocation(lat, lng, label);
                  _scrollToBottom();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: AppColors.mainAppPrimary),
      ),
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: widget.conversation.otherUser.avatarUrl != null
                    ? NetworkImage(widget.conversation.otherUser.avatarUrl!)
                    : null,
                backgroundColor: AppColors.mainAppPrimary.withOpacity(0.1),
                child: widget.conversation.otherUser.avatarUrl == null
                    ? Text(
                  widget.conversation.otherUser.name[0].toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mainAppPrimary,
                  ),
                )
                    : null,
              ),
              if (widget.conversation.otherUser.isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.conversation.otherUser.name,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.conversation.otherUser.isOnline ? 'En ligne' : 'Hors ligne',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: widget.conversation.otherUser.isOnline
                        ? AppColors.success
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Appel (bientôt)', style: GoogleFonts.poppins()),
              ),
            );
          },
          icon: const Icon(Icons.phone, color: AppColors.mainAppPrimary),
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
    );
  }

  Widget _buildMessageList() {
    return Consumer<ChatThreadController>(
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

        if (controller.messages.isEmpty) {
          return Center(
            child: Text(
              'Aucun message',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: controller.messages.length,
          itemBuilder: (context, index) {
            final message = controller.messages[index];
            final showDateSeparator = _shouldShowDateSeparator(
              controller.messages,
              index,
            );

            return Column(
              children: [
                if (showDateSeparator)
                  DateSeparator(date: message.createdAt),
                MessageBubble(
                  message: message,
                  onLongPress: () => _showMessageOptions(context, controller, message),
                ),
              ],
            );
          },
        );
      },
    );
  }

  bool _shouldShowDateSeparator(List<Message> messages, int index) {
    if (index == 0) return true;

    final currentDate = DateTime(
      messages[index].createdAt.year,
      messages[index].createdAt.month,
      messages[index].createdAt.day,
    );
    final previousDate = DateTime(
      messages[index - 1].createdAt.year,
      messages[index - 1].createdAt.month,
      messages[index - 1].createdAt.day,
    );

    return currentDate != previousDate;
  }

  void _showMessageOptions(
      BuildContext context,
      ChatThreadController controller,
      Message message,
      ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.type == MessageType.text)
              ListTile(
                leading: const Icon(Icons.copy, color: AppColors.mainAppPrimary),
                title: Text(
                  'Copier',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Copy to clipboard
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Message copié', style: GoogleFonts.poppins()),
                    ),
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: Text(
                'Supprimer',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: AppColors.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                controller.deleteMessage(message.id);
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag, color: AppColors.warning),
              title: Text(
                'Signaler',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Signalement (bientôt)', style: GoogleFonts.poppins()),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}