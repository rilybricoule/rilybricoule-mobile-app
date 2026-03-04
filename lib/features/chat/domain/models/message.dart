enum MessageType { text, image, voice, location }

enum MessageStatus { sending, sent, delivered, read }

class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final MessageType type;
  final String? text;
  final String? imageUrl;
  final String? voiceUrl;
  final int? voiceDuration; // in seconds
  final double? latitude;
  final double? longitude;
  final String? locationLabel;
  final DateTime createdAt;
  final MessageStatus status;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.type,
    this.text,
    this.imageUrl,
    this.voiceUrl,
    this.voiceDuration,
    this.latitude,
    this.longitude,
    this.locationLabel,
    required this.createdAt,
    required this.status,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      text: json['text'] as String?,
      imageUrl: json['imageUrl'] as String?,
      voiceUrl: json['voiceUrl'] as String?,
      voiceDuration: json['voiceDuration'] as int?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      locationLabel: json['locationLabel'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: MessageStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MessageStatus.sent,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'type': type.name,
      'text': text,
      'imageUrl': imageUrl,
      'voiceUrl': voiceUrl,
      'voiceDuration': voiceDuration,
      'latitude': latitude,
      'longitude': longitude,
      'locationLabel': locationLabel,
      'createdAt': createdAt.toIso8601String(),
      'status': status.name,
    };
  }

  Message copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    MessageType? type,
    String? text,
    String? imageUrl,
    String? voiceUrl,
    int? voiceDuration,
    double? latitude,
    double? longitude,
    String? locationLabel,
    DateTime? createdAt,
    MessageStatus? status,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      voiceUrl: voiceUrl ?? this.voiceUrl,
      voiceDuration: voiceDuration ?? this.voiceDuration,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationLabel: locationLabel ?? this.locationLabel,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}
