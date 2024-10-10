// ignore_for_file: camel_case_types

class user {
  final int? id;
  final String username;
  final String? email;
  final String password;

  user({this.id, required this.username, this.email, required this.password});
  Map<String, Object?> tomap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password
    };
  }

  factory user.frommap(Map<String, Object?> map) {
    return user(
      id: map['id'] as int?,
      username: map['username'] as String,
      password: map['password'] as String,
      email: map['email'] as String?,
    );
  }
}
