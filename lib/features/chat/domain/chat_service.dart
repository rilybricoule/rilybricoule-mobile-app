import '../data/local_chat_repository.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  late final LocalChatRepository repository = LocalChatRepository();
}
