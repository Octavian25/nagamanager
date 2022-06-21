import 'package:encryptor_flutter_nagatech/main.dart';

class UserModel {
  String password;
  String username;

  UserModel({required this.password, required this.username});

  Map<String, dynamic> toJson() {
    return {
      "username": Encryptor.doEncrypt(username),
      "password": Encryptor.doEncrypt(password)
    };
  }
}

class LoginFeedback {
  String accessToken;
  String username;

  LoginFeedback({required this.accessToken, required this.username});

  factory LoginFeedback.fromJson(Map<String, dynamic> json) => LoginFeedback(
      accessToken: json['accessToken'],
      username: Encryptor.doDecrypt(json['username']));
}
