import 'user_summary.dart';

class Conversation {
  final String id;
  final UserSummary otherUser;
  final String lastMessagePreview;
  final DateTime lastMessageAt;
  final int unreadCount;
  final bool isPinned;
  final String? bookingId;
  final String? bookingStatus;

  Conversation({
    required this.id,
    required this.otherUser,
    required this.lastMessagePreview,
    required this.lastMessageAt,
    required this.unreadCount,
    this.isPinned = false,
    this.bookingId,
    this.bookingStatus,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      otherUser: UserSummary.fromJson(json['otherUser'] as Map<String, dynamic>),
      lastMessagePreview: json['lastMessagePreview'] as String,
      lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
      unreadCount: json['unreadCount'] as int? ?? 0,
      isPinned: json['isPinned'] as bool? ?? false,
      bookingId: json['bookingId'] as String?,
      bookingStatus: json['bookingStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'otherUser': otherUser.toJson(),
      'lastMessagePreview': lastMessagePreview,
      'lastMessageAt': lastMessageAt.toIso8601String(),
      'unreadCount': unreadCount,
      'isPinned': isPinned,
      'bookingId': bookingId,
      'bookingStatus': bookingStatus,
    };
  }

  Conversation copyWith({
    String? id,
    UserSummary? otherUser,
    String? lastMessagePreview,
    DateTime? lastMessageAt,
    int? unreadCount,
    bool? isPinned,
    String? bookingId,
    String? bookingStatus,
  }) {
    return Conversation(
      id: id ?? this.id,
      otherUser: otherUser ?? this.otherUser,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      isPinned: isPinned ?? this.isPinned,
      bookingId: bookingId ?? this.bookingId,
      bookingStatus: bookingStatus ?? this.bookingStatus,
    );
  }
}
