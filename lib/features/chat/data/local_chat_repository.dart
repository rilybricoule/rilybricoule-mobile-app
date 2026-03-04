import 'dart:async';
import '../domain/chat_repository.dart';
import '../domain/models/conversation.dart';
import '../domain/models/message.dart';
import '../domain/models/user_summary.dart';

class LocalChatRepository implements ChatRepository {
  final List<Conversation> _conversations = [];
  final Map<String, List<Message>> _messages = {};
  final StreamController<List<Conversation>> _conversationsController = StreamController.broadcast();
  final Map<String, StreamController<List<Message>>> _messageControllers = {};
  
  static const String currentUserId = 'client_1';

  LocalChatRepository();

  @override
  Future<List<Conversation>> getConversations({String? query}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (query == null || query.isEmpty) {
      return List.from(_conversations)..sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
    }
    
    final lowerQuery = query.toLowerCase();
    return _conversations
        .where((c) =>
            c.otherUser.name.toLowerCase().contains(lowerQuery) ||
            c.lastMessagePreview.toLowerCase().contains(lowerQuery))
        .toList()
      ..sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
  }

  @override
  Stream<List<Conversation>> watchConversations() {
    return _conversationsController.stream;
  }

  @override
  Future<List<Message>> getMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_messages[conversationId] ?? []);
  }

  @override
  Stream<List<Message>> watchMessages(String conversationId) {
    if (!_messageControllers.containsKey(conversationId)) {
      _messageControllers[conversationId] = StreamController.broadcast();
    }
    return _messageControllers[conversationId]!.stream;
  }

  @override
  Future<void> sendText(String conversationId, String text) async {
    final message = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: currentUserId,
      type: MessageType.text,
      text: text,
      createdAt: DateTime.now(),
      status: MessageStatus.sending,
    );

    _messages[conversationId] = _messages[conversationId] ?? [];
    _messages[conversationId]!.add(message);
    _notifyMessages(conversationId);
    _updateConversationPreview(conversationId, text);

    // Simulate status updates
    await Future.delayed(const Duration(milliseconds: 500));
    _updateMessageStatus(conversationId, message.id, MessageStatus.sent);

    await Future.delayed(const Duration(milliseconds: 300));
    _updateMessageStatus(conversationId, message.id, MessageStatus.delivered);

    // Check if conversation exists and user is online
    final convIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (convIndex != -1 && _conversations[convIndex].otherUser.isOnline) {
      await Future.delayed(const Duration(milliseconds: 400));
      _updateMessageStatus(conversationId, message.id, MessageStatus.read);
    }
  }

  @override
  Future<void> sendImage(String conversationId, String imageUrl) async {
    final message = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: currentUserId,
      type: MessageType.image,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
      status: MessageStatus.sending,
    );

    _messages[conversationId] = _messages[conversationId] ?? [];
    _messages[conversationId]!.add(message);
    _notifyMessages(conversationId);
    _updateConversationPreview(conversationId, '📷 Photo');

    await Future.delayed(const Duration(milliseconds: 800));
    _updateMessageStatus(conversationId, message.id, MessageStatus.sent);

    await Future.delayed(const Duration(milliseconds: 300));
    _updateMessageStatus(conversationId, message.id, MessageStatus.delivered);

    final convIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (convIndex != -1 && _conversations[convIndex].otherUser.isOnline) {
      await Future.delayed(const Duration(milliseconds: 400));
      _updateMessageStatus(conversationId, message.id, MessageStatus.read);
    }
  }

  @override
  Future<void> sendVoice(String conversationId, String voiceUrl, int duration) async {
    final message = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: currentUserId,
      type: MessageType.voice,
      voiceUrl: voiceUrl,
      voiceDuration: duration,
      createdAt: DateTime.now(),
      status: MessageStatus.sending,
    );

    _messages[conversationId] = _messages[conversationId] ?? [];
    _messages[conversationId]!.add(message);
    _notifyMessages(conversationId);
    _updateConversationPreview(conversationId, '🎤 Message vocal');

    await Future.delayed(const Duration(milliseconds: 800));
    _updateMessageStatus(conversationId, message.id, MessageStatus.sent);

    await Future.delayed(const Duration(milliseconds: 300));
    _updateMessageStatus(conversationId, message.id, MessageStatus.delivered);

    final convIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (convIndex != -1 && _conversations[convIndex].otherUser.isOnline) {
      await Future.delayed(const Duration(milliseconds: 400));
      _updateMessageStatus(conversationId, message.id, MessageStatus.read);
    }
  }

  @override
  Future<void> sendLocation(String conversationId, double lat, double lng, String label) async {
    final message = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: currentUserId,
      type: MessageType.location,
      latitude: lat,
      longitude: lng,
      locationLabel: label,
      createdAt: DateTime.now(),
      status: MessageStatus.sending,
    );

    _messages[conversationId] = _messages[conversationId] ?? [];
    _messages[conversationId]!.add(message);
    _notifyMessages(conversationId);
    _updateConversationPreview(conversationId, '📍 Position partagée');

    await Future.delayed(const Duration(milliseconds: 500));
    _updateMessageStatus(conversationId, message.id, MessageStatus.sent);

    await Future.delayed(const Duration(milliseconds: 300));
    _updateMessageStatus(conversationId, message.id, MessageStatus.delivered);

    final convIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (convIndex != -1 && _conversations[convIndex].otherUser.isOnline) {
      await Future.delayed(const Duration(milliseconds: 400));
      _updateMessageStatus(conversationId, message.id, MessageStatus.read);
    }
  }

  @override
  Future<void> markAsRead(String conversationId) async {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      _conversations[index] = _conversations[index].copyWith(unreadCount: 0);
      _conversationsController.add(List.from(_conversations));
    }
  }

  @override
  Future<Conversation> getOrCreateConversationWithUser(UserSummary userSummary) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    // Find existing conversation
    final existingIndex = _conversations.indexWhere((c) => c.otherUser.id == userSummary.id);
    
    if (existingIndex != -1) {
      return _conversations[existingIndex];
    }
    
    // Create new conversation
    final newConv = Conversation(
      id: 'conv_${DateTime.now().millisecondsSinceEpoch}',
      otherUser: userSummary,
      lastMessagePreview: 'Commencez la conversation',
      lastMessageAt: DateTime.now(),
      unreadCount: 0,
    );
    
    _conversations.insert(0, newConv);
    _messages[newConv.id] = [];
    _conversationsController.add(List.from(_conversations));
    
    return newConv;
  }

  @override
  Future<void> deleteMessage(String conversationId, String messageId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final messages = _messages[conversationId];
    if (messages != null) {
      messages.removeWhere((m) => m.id == messageId);
      _notifyMessages(conversationId);
      
      // Update conversation preview
      if (messages.isNotEmpty) {
        final lastMsg = messages.last;
        String preview = 'Message supprimé';
        if (lastMsg.type == MessageType.text && lastMsg.text != null) {
          preview = lastMsg.text!;
        } else if (lastMsg.type == MessageType.image) {
          preview = '📷 Photo';
        } else if (lastMsg.type == MessageType.voice) {
          preview = '🎤 Message vocal';
        }
        _updateConversationPreview(conversationId, preview);
      } else {
        _updateConversationPreview(conversationId, 'Commencez la conversation');
      }
    }
  }

  void _updateMessageStatus(String conversationId, String messageId, MessageStatus status) {
    final messages = _messages[conversationId];
    if (messages != null) {
      final index = messages.indexWhere((m) => m.id == messageId);
      if (index != -1) {
        messages[index] = messages[index].copyWith(status: status);
        _notifyMessages(conversationId);
      }
    }
  }

  void _updateConversationPreview(String conversationId, String preview) {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      _conversations[index] = _conversations[index].copyWith(
        lastMessagePreview: preview,
        lastMessageAt: DateTime.now(),
      );
      _conversationsController.add(List.from(_conversations));
    }
  }

  void _notifyMessages(String conversationId) {
    if (_messageControllers.containsKey(conversationId)) {
      _messageControllers[conversationId]!.add(List.from(_messages[conversationId] ?? []));
    }
  }

  void dispose() {
    _conversationsController.close();
    for (var controller in _messageControllers.values) {
      controller.close();
    }
  }
}
