class User {
  final String token;

  User({required this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['data']['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}

class GetUser {
  final String id;
  final String name;
  final String email;
  final String nisn;
  final String avatar;
  final String description;

  GetUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.description,
    required this.nisn,
  });

  factory GetUser.fromJson(Map<String, dynamic> json) {
    return GetUser(
        id: json['id'].toString(),
        name: json['name'].toString(),
        email: json['email'].toString(),
        avatar: json['avatar'].toString(),
        description: json['description'].toString(),
        nisn: json['nisn'].toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'description': description,
      'nisn': nisn
    };
  }
}

class UserList {
  final List<GetUser> getUser;

  UserList({required this.getUser});

  factory UserList.fromJson(Map<String, dynamic> json) {
    List<dynamic> getUserJson = json['data']?['data'] ?? [];
    List<GetUser> getUser = getUserJson
        .map((getUserJson) => GetUser.fromJson(getUserJson))
        .toList();
    return UserList(getUser: getUser);
  }

  Map<String, dynamic> toJson() {
    return {'getUser': getUser.map((getUser) => getUser.toJson()).toList()};
  }
}
