class UserModel {
  String password;
  String username;

  UserModel({required this.password, required this.username});

  Map<String, dynamic> toJson() {
    return {
      "username" : username,
      "password" : password
    };
  }
}

class LoginFeedback {
  String accessToken;
  String username;

  LoginFeedback({required this.accessToken, required this.username});

  factory LoginFeedback.fromJson(Map<String, dynamic> json) => LoginFeedback(accessToken: json['accessToken'], username: json['username']);
}