class TripItem {
  final String dEnd;
  final String dStart;
  final String id;
  final String placeId;
  final String updated;
  final String userId;
  final bool status;
  final String? placeTitle;
  final String? placeImg;

  TripItem({
    required this.dEnd,
    required this.dStart,
    required this.id,
    required this.placeId,
    required this.updated,
    required this.userId,
    required this.status,
    this.placeTitle,
    this.placeImg,
  });

  factory TripItem.fromJson(Map<String, dynamic> json) {
    return TripItem(
      dEnd: json['d_end'],
      dStart: json['d_start'],
      id: json['id'],
      placeId: json['place_id'],
      updated: json['updated'],
      userId: json['user_id'],
      status: json['status'],
      placeTitle: json['title'],
      placeImg: json['img'],
    );
  }

  TripItem copyWith({
    String? placeTitle,
    String? placeImg,
  }) {
    return TripItem(
      dEnd: this.dEnd,
      dStart: this.dStart,
      id: this.id,
      placeId: this.placeId,
      updated: this.updated,
      userId: this.userId,
      status: this.status,
      placeTitle: placeTitle ?? this.placeTitle,
      placeImg: placeImg ?? this.placeImg,
    );
  }
}
