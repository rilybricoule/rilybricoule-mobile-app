import 'package:flutter/foundation.dart';
import '../domain/chat_repository.dart';
import '../domain/models/conversation.dart';

class ConversationsController extends ChangeNotifier {
  final ChatRepository _repository;
  
  List<Conversation> _conversations = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  List<Conversation> get conversations => _conversations;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasConversations => _conversations.isNotEmpty;
  int get totalUnreadCount => _conversations.fold(0, (sum, c) => sum + c.unreadCount);

  ConversationsController(this._repository) {
    _init();
  }

  void _init() {
    loadConversations();
    _repository.watchConversations().listen((conversations) {
      _conversations = conversations;
      notifyListeners();
    });
  }

  Future<void> loadConversations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _conversations = await _repository.getConversations(query: _searchQuery);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> search(String query) async {
    _searchQuery = query;
    await loadConversations();
  }

  void clearSearch() {
    _searchQuery = '';
    loadConversations();
  }

  Future<void> refresh() async {
    await loadConversations();
  }
}
