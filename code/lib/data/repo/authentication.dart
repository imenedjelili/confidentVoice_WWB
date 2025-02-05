abstract class AbstractAuthentication {
  Future<bool> doSignup(String email, String pass, String passConfirm);
  Future<bool> doLogin(String email, String pass);
}
