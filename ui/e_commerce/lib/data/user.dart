import 'dart:typed_data';

class User {
  String email;
  String name;
  String userId;
  DateTime createdAt;
  String status;

  User(
      {required this.name,
      required this.userId,
      required this.email,
      required this.status,
      required this.createdAt});
}
