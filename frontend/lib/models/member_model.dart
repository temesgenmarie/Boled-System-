class Member {
  final String id;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final DateTime dateOfBirth;
  final String? address;
  final bool isActive;
  final DateTime createdAt;

  Member({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.dateOfBirth,
    this.address,
    required this.isActive,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      address: json['address'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'address': address,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Member copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    DateTime? dateOfBirth,
    String? address,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Member(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
