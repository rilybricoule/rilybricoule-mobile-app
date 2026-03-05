import '../domain/models/conversation.dart';
import '../domain/models/message.dart';
import '../domain/models/user_summary.dart';

abstract class ChatRepository {
  Future<List<Conversation>> getConversations({String? query});
  Stream<List<Conversation>> watchConversations();
  Future<List<Message>> getMessages(String conversationId);
  Stream<List<Message>> watchMessages(String conversationId);
  Future<void> sendText(String conversationId, String text);
  Future<void> sendImage(String conversationId, String imageUrl);
  Future<void> sendVoice(String conversationId, String voiceUrl, int duration);
  Future<void> sendLocation(String conversationId, double lat, double lng, String label);
  Future<void> markAsRead(String conversationId);
  Future<Conversation> getOrCreateConversationWithProvider(String providerId, {String? bookingId});
  Future<void> deleteMessage(String conversationId, String messageId);
  Future<bool> hasConfirmedBookingWithProvider(String providerId);
}
