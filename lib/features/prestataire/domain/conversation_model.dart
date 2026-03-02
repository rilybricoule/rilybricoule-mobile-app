class Conversation {
  final String id;
  final String clientName;
  final String lastMessage;
  final String timeLabel;
  final int unreadCount;

  Conversation({
    required this.id,
    required this.clientName,
    required this.lastMessage,
    required this.timeLabel,
    required this.unreadCount,
  });

  // This "Factory" handles the conversion from your Map to the Object
  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id']?.toString() ?? '',
      clientName: map['clientName'] ?? 'Client',
      lastMessage: map['lastMessage'] ?? '',
      timeLabel: map['timeLabel'] ?? '',
      unreadCount: map['unreadCount'] ?? 0,
    );
  }
}