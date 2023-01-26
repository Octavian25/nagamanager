part of 'providers.dart';

class AuthProvider with ChangeNotifier {
  LoginFeedback? _user;
  LoadingProvider? loadingProvider;
  void update(LoadingProvider loading) {
    loadingProvider = loading;
    notifyListeners();
  }

  LoginFeedback? get user => _user;

  set user(LoginFeedback? user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> checkLastLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String username = sharedPreferences.getString("username") ?? "-";
    String password = sharedPreferences.getString("password") ?? "-";
    if (username == "-" && password == "-") {
      return false;
    } else {
      return await login(username: username, password: password);
    }
  }

  Future<bool> login({required String username, required String password}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Client _client = Client();
    var _endPoint = EndPointProvider(_client.init());
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      sharedPreferences.setString("username", username);
      sharedPreferences.setString("password", password);
      LoginFeedback user = await compute(_endPoint.login, loginParam(username, password));
      _user = user;
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      return true;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      return false;
    }
  }

  Future<bool> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      final username = await sharedPreferences.remove("username");
      final password = await sharedPreferences.remove("password");
      print(username);
      print(password);
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      return true;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      return false;
    }
  }
}
