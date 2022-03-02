import 'dart:convert';

class User {
  String id;
  String  name;
  String email;
  String? picture;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.picture});

  factory User.fromJson(Map<String, dynamic>? jsonData) {
 
    return User(
        id: jsonData?['id'] as String,
        name: jsonData?['name'] as String,
        email: jsonData?['email'] as String,
        picture: jsonData?['picture'] ?? '');
  }
  static Map<String, dynamic> toMap(User model) => {
        'id': model.id,
        'email': model.email,
        'name': model.name,
        'picture': model.picture,
      };

  static String serialize(User model) => jsonEncode(User.toMap(model));

  static User deserialize(Map<String, dynamic> json) => User.fromJson(json);
}
