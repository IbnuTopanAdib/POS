class UserProfile {
  String? uid;
  String? email;
  String? ppURL;
  String? name;
  String? phoneNumber;

  UserProfile({
    required this.uid,
    required this.email,
    required this.ppURL,
    required this.name,
    required this.phoneNumber,
 
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'],
      email: json['email'],
      ppURL: json['ppURL'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['email'] = email;
    data['ppURL'] = ppURL;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
