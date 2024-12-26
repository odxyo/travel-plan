class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String bio;
  final bool role_admin;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.bio,
    required this.role_admin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
      bio: json['bio'] ?? '',
      role_admin: json['role_admin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'bio': bio,
      'role_admin': role_admin,
    };
  }
}
