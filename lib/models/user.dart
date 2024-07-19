class User {
  User({
    required this.id,
    required this.username,
    required this.password,
    required this.fullName,
    required this.userType,
  });

  final String id;
  final String username;
  final String password;
  final String fullName;
  final String userType;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      fullName: json['full_name'],
      userType: json['user_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'full_name': fullName,
      'user_type': userType,
    };
  }
}
