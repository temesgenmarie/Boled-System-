import 'package:uuid/uuid.dart';

enum MemberRole { admin, user }

class Member {
  final String id;
  final String fullName;
  final String phone;
  final String? email;
  final String organizationId;
  final MemberRole role; // Added role field for admin/user distinction
  final bool isActive;
  final DateTime createdAt;

  Member({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
    required this.organizationId,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      organizationId: json['organizationId'] as String,
      role: MemberRole.values.byName(json['role'] as String? ?? 'user'),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'organizationId': organizationId,
      'role': role.name,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Member copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? email,
    String? organizationId,
    MemberRole? role,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Member(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      organizationId: organizationId ?? this.organizationId,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
