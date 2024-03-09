class UserModel {
  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.profilePhoto,
    required this.familyName,
    required this.departmant,
    required this.createdAt,
    required this.latestStatus,
    required this.favoritePostIds,
    required this.ownPostIds,
    required this.isAdmin,
    this.mailSubscription = true,
  });
  late final String id;
  late final String email;
  late final String name;
  String? profilePhoto;
  late final String familyName;
  late final DateTime createdAt;
  late final String departmant;
  late final String latestStatus;
  late final List<String> favoritePostIds;
  late final List<String> ownPostIds;
  late final bool isAdmin;
  late bool mailSubscription;

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    profilePhoto = json['profilePhoto'];
    familyName = json['familyName'];
    createdAt = DateTime.parse(json['createdAt']);
    departmant = json['departmant'];
    latestStatus = json['latestStatus'];
    favoritePostIds = List.castFrom<dynamic, String>(json['favoritePostIds']);
    ownPostIds = List.castFrom<dynamic, String>(json['ownPostIds']);
    isAdmin = json['isAdmin'];
    mailSubscription = json['mailSubscription'];
  }
}
