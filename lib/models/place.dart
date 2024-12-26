class Place {
  final String id;
  final String title;
  final String detail;
  final String img;
  final String locationPlace;
  final String province;
  final String district;
  final bool recommend;

  Place({
    required this.id,
    required this.title,
    required this.detail,
    required this.img,
    required this.locationPlace,
    required this.province,
    required this.district,
    required this.recommend,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      detail: json['detial'] ?? '',
      img: json['img'] ?? '',
      locationPlace: json['location_place'] ?? '',
      province: json['province'] ?? '',
      district: json['district'] ?? '',
      recommend: json['recomand'] ?? false,
    );
  }
}
