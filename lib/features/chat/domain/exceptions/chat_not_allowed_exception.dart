class ChatNotAllowedException implements Exception {
  final String message;
  ChatNotAllowedException(this.message);
  
  @override
  String toString() => message;
}
