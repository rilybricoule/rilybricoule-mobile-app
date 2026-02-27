import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/local_chat_repository.dart';
import '../../domain/models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final VoidCallback? onLongPress;

  const MessageBubble({
    super.key,
    required this.message,
    this.onLongPress,
  });

  bool get isMe => message.senderId == LocalChatRepository.currentUserId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMe) ...[
              const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.mainAppPrimary,
                child: Icon(Icons.person, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: message.type == MessageType.image || message.type == MessageType.voice
                        ? EdgeInsets.zero
                        : const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe ? AppColors.mainAppPrimary : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isMe ? 16 : 4),
                        bottomRight: Radius.circular(isMe ? 4 : 16),
                      ),
                    ),
                    child: message.type == MessageType.text
                        ? Text(
                            message.text ?? '',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: isMe ? Colors.white : AppColors.textPrimary,
                            ),
                          )
                        : message.type == MessageType.image
                            ? ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                                  bottomRight: Radius.circular(isMe ? 4 : 16),
                                ),
                                child: Image.network(
                                  message.imageUrl ?? '',
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 200,
                                      height: 200,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image, size: 48),
                                    );
                                  },
                                ),
                              )
                            : _buildVoiceMessage(isMe, message),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(message.createdAt),
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        _buildStatusIcon(),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (isMe) const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    switch (message.status) {
      case MessageStatus.sending:
        return const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(AppColors.textSecondary),
          ),
        );
      case MessageStatus.sent:
        return const Icon(Icons.check, size: 14, color: AppColors.textSecondary);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all, size: 14, color: AppColors.textSecondary);
      case MessageStatus.read:
        return const Icon(Icons.done_all, size: 14, color: AppColors.mainAppPrimary);
    }
  }

  Widget _buildVoiceMessage(bool isMe, Message message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      width: 200,
      child: Row(
        children: [
          Icon(
            Icons.play_arrow,
            color: isMe ? Colors.white : AppColors.mainAppPrimary,
            size: 32,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: (isMe ? Colors.white : AppColors.mainAppPrimary).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${message.voiceDuration ?? 0}s',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: isMe ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
