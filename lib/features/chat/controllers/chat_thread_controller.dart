import 'package:flutter/foundation.dart';
import '../domain/chat_repository.dart';
import '../domain/models/conversation.dart';
import '../domain/models/message.dart';

class ChatThreadController extends ChangeNotifier {
  final ChatRepository _repository;
  final String conversationId;
  
  List<Message> _messages = [];
  Conversation? _conversation;
  bool _isLoading = false;
  String? _error;

  List<Message> get messages => _messages;
  Conversation? get conversation => _conversation;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ChatThreadController(this._repository, this.conversationId) {
    _init();
  }

  void _init() {
    _markAsRead();
    loadMessages();
    _repository.watchMessages(conversationId).listen((messages) {
      _messages = messages;
      notifyListeners();
    });
  }

  Future<void> loadMessages() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _messages = await _repository.getMessages(conversationId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendText(String text) async {
    if (text.trim().isEmpty) return;
    
    try {
      await _repository.sendText(conversationId, text.trim());
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> sendImage(String imageUrl) async {
    try {
      await _repository.sendImage(conversationId, imageUrl);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> sendVoice(String voiceUrl, int duration) async {
    try {
      await _repository.sendVoice(conversationId, voiceUrl, duration);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      await _repository.deleteMessage(conversationId, messageId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> _markAsRead() async {
    try {
      await _repository.markAsRead(conversationId);
    } catch (e) {
      // Silent fail
    }
  }

  void setConversation(Conversation conversation) {
    _conversation = conversation;
    notifyListeners();
  }
}
