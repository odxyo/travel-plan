import 'package:travel_plan/models/user.dart';

class Review {
  final String id;
  final String detail;
  final String placeId;
  final int star;
  final String userId;
  final String created;
  final String updated;

  final UserModel user;

  Review({
    required this.id,
    required this.detail,
    required this.placeId,
    required this.star,
    required this.userId,
    required this.created,
    required this.updated,
    required this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      detail: json['detail'] ?? '',
      placeId: json['place_id'] ?? '',
      star: json['star'],
      userId: json['user_id'] ?? '',
      created: json['created'] ?? '',
      updated: json['updated'] ?? '',
      user: json['expand'] != null && json['expand']['user_id'] != null
          ? UserModel.fromJson(json['expand']['user_id'])
          : UserModel(
              avatar: '',
              email: '',
              name: '',
              id: '',
              bio: '',
              role_admin: false),
    );
  }
}
