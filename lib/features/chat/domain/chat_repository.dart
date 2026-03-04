import '../domain/models/conversation.dart';
import '../domain/models/message.dart';
import '../domain/models/user_summary.dart';

abstract class ChatRepository {
  // TODO: Replace with API calls when backend is ready
  Future<List<Conversation>> getConversations({String? query});
  Stream<List<Conversation>> watchConversations();
  Future<List<Message>> getMessages(String conversationId);
  Stream<List<Message>> watchMessages(String conversationId);
  Future<void> sendText(String conversationId, String text);
  Future<void> sendImage(String conversationId, String imageUrl);
  Future<void> sendVoice(String conversationId, String voiceUrl, int duration);
  Future<void> sendLocation(String conversationId, double lat, double lng, String label);
  Future<void> markAsRead(String conversationId);
  Future<Conversation> getOrCreateConversationWithUser(UserSummary userSummary);
  Future<void> deleteMessage(String conversationId, String messageId);
}
