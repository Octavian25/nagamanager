part of 'services.dart';

class AuthService {
  Future<LoginFeedback> login(
      {required String username, required String password}) async {
    var url = "$baseURL" + "auth/login";
    var body = json.encode({"username": username, "password": password});
    var header = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS"
    };
    try {
      var response = await Dio(BaseOptions(headers: header)).post(url, data: body);
      if (response.statusCode == 200) {
        LoginFeedback loginFeedback = LoginFeedback.fromJson(response.data);
        return loginFeedback;
      } else {
        throw Exception('Gagal Login');
      }
    } catch (e) {
      throw Exception('Gagal Login');
    }
  }
}
