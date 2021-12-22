part of 'providers.dart';

class AuthProvider with ChangeNotifier {
  LoginFeedback? _user;

  LoginFeedback? get user  => _user;

  set user(LoginFeedback? user){
    _user = user;
    notifyListeners();
  }

  Future<bool> login({required String username,required String password}) async{
    try {
      LoginFeedback user = await AuthService().login(username: username, password: password);
      _user = user;
      return true;
    } catch (e) {
      return false;
    }
  }
}