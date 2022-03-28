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

  Future<bool> login(
      {required String username, required String password}) async {
    Client _client = Client("");
    var _endPoint = EndPointProvider(_client.init());
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      LoginFeedback user =
          await _endPoint.login(username: username, password: password);
      _user = user;
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      return true;
    } catch (e) {
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      return false;
    }
  }
}
