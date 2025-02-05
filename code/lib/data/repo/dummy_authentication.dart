import 'authentication.dart';

class DummyAuthentication implements AbstractAuthentication {
  static final DummyAuthentication _instance = DummyAuthentication._internal();

  factory DummyAuthentication() {
    return _instance;
  }

  DummyAuthentication._internal();

  String? _userEmail;
  String? _password;

  @override
  Future<bool> doSignup(String email, String pass, String passConfirm) async {
    if (pass == passConfirm) {
      _userEmail = email;
      _password = pass;
      return true;
    }
    return false;
  }

  @override
  Future<bool> doLogin(String email, String pass) async {
    if (_userEmail == email && _password == pass) {
      return true;
    }
    return false;
  }
}
