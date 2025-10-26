enum MessageType { funeral, announcement }

class Message {
  final String id;
  final MessageType type;
  final String? subject;
  final String body;
  final List<String> recipientIds;
  final DateTime sentAt;
  final DateTime? scheduledFor;
  final bool isScheduled;
  final String status; // 'pending', 'sent', 'failed'

  Message({
    required this.id,
    required this.type,
    this.subject,
    required this.body,
    required this.recipientIds,
    required this.sentAt,
    this.scheduledFor,
    required this.isScheduled,
    required this.status,
  });

  Message copyWith({
    String? id,
    MessageType? type,
    String? subject,
    String? body,
    List<String>? recipientIds,
    DateTime? sentAt,
    DateTime? scheduledFor,
    bool? isScheduled,
    String? status,
  }) {
    return Message(
      id: id ?? this.id,
      type: type ?? this.type,
      subject: subject ?? this.subject,
      body: body ?? this.body,
      recipientIds: recipientIds ?? this.recipientIds,
      sentAt: sentAt ?? this.sentAt,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      isScheduled: isScheduled ?? this.isScheduled,
      status: status ?? this.status,
    );
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      type: MessageType.values.byName(json['type'] as String),
      subject: json['subject'] as String?,
      body: json['body'] as String,
      recipientIds: List<String>.from(json['recipientIds'] as List),
      sentAt: DateTime.parse(json['sentAt'] as String),
      scheduledFor: json['scheduledFor'] != null
          ? DateTime.parse(json['scheduledFor'] as String)
          : null,
      isScheduled: json['isScheduled'] as bool? ?? false,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'subject': subject,
      'body': body,
      'recipientIds': recipientIds,
      'sentAt': sentAt.toIso8601String(),
      'scheduledFor': scheduledFor?.toIso8601String(),
      'isScheduled': isScheduled,
      'status': status,
    };
  }
}
