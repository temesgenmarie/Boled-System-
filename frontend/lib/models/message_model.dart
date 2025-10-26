enum MessageType { funeral, announcement }

class Message {
  final String id;
  final MessageType type;
  final String memberId; // Added member reference
  final String memberName; // Added member name for display
  
  // Announcement fields
  final String? announcementPlace;
  final String? announcementTime;
  final String? announcementDay;
  
  // Funeral fields
  final String? funeralChurch;
  final String? funeralPlace;
  final String? funeralDeathType; // new or old
  final String? funeralDeathInfo;
  
  final String body;
  final List<String> recipientIds;
  final DateTime sentAt;
  final DateTime? scheduledFor;
  final bool isScheduled;
  final String status; // 'pending', 'sent', 'failed'

  Message({
    required this.id,
    required this.type,
    required this.memberId,
    required this.memberName,
    this.announcementPlace,
    this.announcementTime,
    this.announcementDay,
    this.funeralChurch,
    this.funeralPlace,
    this.funeralDeathType,
    this.funeralDeathInfo,
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
    String? memberId,
    String? memberName,
    String? announcementPlace,
    String? announcementTime,
    String? announcementDay,
    String? funeralChurch,
    String? funeralPlace,
    String? funeralDeathType,
    String? funeralDeathInfo,
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
      memberId: memberId ?? this.memberId,
      memberName: memberName ?? this.memberName,
      announcementPlace: announcementPlace ?? this.announcementPlace,
      announcementTime: announcementTime ?? this.announcementTime,
      announcementDay: announcementDay ?? this.announcementDay,
      funeralChurch: funeralChurch ?? this.funeralChurch,
      funeralPlace: funeralPlace ?? this.funeralPlace,
      funeralDeathType: funeralDeathType ?? this.funeralDeathType,
      funeralDeathInfo: funeralDeathInfo ?? this.funeralDeathInfo,
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
      memberId: json['memberId'] as String,
      memberName: json['memberName'] as String,
      announcementPlace: json['announcementPlace'] as String?,
      announcementTime: json['announcementTime'] as String?,
      announcementDay: json['announcementDay'] as String?,
      funeralChurch: json['funeralChurch'] as String?,
      funeralPlace: json['funeralPlace'] as String?,
      funeralDeathType: json['funeralDeathType'] as String?,
      funeralDeathInfo: json['funeralDeathInfo'] as String?,
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
      'memberId': memberId,
      'memberName': memberName,
      'announcementPlace': announcementPlace,
      'announcementTime': announcementTime,
      'announcementDay': announcementDay,
      'funeralChurch': funeralChurch,
      'funeralPlace': funeralPlace,
      'funeralDeathType': funeralDeathType,
      'funeralDeathInfo': funeralDeathInfo,
      'body': body,
      'recipientIds': recipientIds,
      'sentAt': sentAt.toIso8601String(),
      'scheduledFor': scheduledFor?.toIso8601String(),
      'isScheduled': isScheduled,
      'status': status,
    };
  }
}
