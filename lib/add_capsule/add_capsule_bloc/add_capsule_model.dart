import 'package:map_location_picker/map_location_picker.dart';

class Capsule {
  String? id;
  String caption;
  String content;
  String cron;
  DateTime availableAt;
 
  DateTime createdAt;
  List<String> members;
  CapsuleLocation? location;

  int tapCount;

  Capsule({
    this.caption = "",
    this.content = "",
    this.tapCount = 0,
    this.members = const [],
    this.id,
    required this.location,
    required this.availableAt,
    required this.createdAt,
    required this.cron,
  });

  Capsule.zero()
      : caption = "",
        content = "",
        members = [],
        id = null,
        location = null,
        cron = "",
        availableAt = DateTime.now(),
        createdAt = DateTime.now(),
        tapCount = 0;

  static Capsule fromJson(Map<String, dynamic> json) {
    List<String> members = List<dynamic>.from(json['members']).map((e) => e.toString()).toList();

    return Capsule(
      caption: json['caption'],
      cron: json['cron']??'',
      id: json['id'],
      content: json['content']??"",
      members: members,
      location: CapsuleLocation.fromJson(json['location']),
      availableAt:DateTime.parse(json['availableAt']),
      createdAt: DateTime.parse(json['createdAt']),
      tapCount: json['tapCount'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['caption'] = caption;
    data['content'] = content;
    data['cron'] = cron;
    data['id'] = id;
    data['members'] = members;
    data['location'] = location;
    data['availableAt'] = availableAt;
    data['createdAt'] = createdAt;
    data['tapCount'] = tapCount;
    return data;
  }
}

class CapsuleMedia {
  String type;
  String path;

  CapsuleMedia({
    required this.type,
    required this.path,
  });

  CapsuleMedia.zero()
      : type = "",
        path = "";
}

class CapsuleMember {
  String sub;
  String email;

  CapsuleMember({
    required this.sub,
    required this.email,
  });

  CapsuleMember.zero()
      : sub = "",
        email = "";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CapsuleMember && other.sub == sub && other.email == email;
  }

  @override
  int get hashCode => sub.hashCode ^ email.hashCode;
}

class CapsuleLocation {
  LatLng latLng;
  String address;

  CapsuleLocation({
    required this.latLng,
    required this.address,
  });

  CapsuleLocation.zero()
      : latLng = LatLng(0, 0),
        address = "";

  static CapsuleLocation fromJson(Map<String, dynamic> json) {
    return CapsuleLocation(
      latLng: LatLng(json['lat'], json['lng']),
      address: json['address'],
    );
  }

  // check if latlng is zero
  bool get isZero => latLng.latitude == 0 && latLng.longitude == 0;
}
