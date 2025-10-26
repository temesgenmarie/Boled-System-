class User {
  final String id;
  final String username;
  final String organizationName;
  final DateTime? lastLoginTime;

  User({
    required this.id,
    required this.username,
    required this.organizationName,
    this.lastLoginTime,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      organizationName: json['organizationName'] as String,
      lastLoginTime: json['lastLoginTime'] != null
          ? DateTime.parse(json['lastLoginTime'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'organizationName': organizationName,
      'lastLoginTime': lastLoginTime?.toIso8601String(),
    };
  }
}
