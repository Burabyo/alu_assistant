class AuthService {
  static String? _email;
  static String? _password;
  static bool isLoggedIn = false;

  static bool register(String email, String password) {
    _email = email;
    _password = password;
    return true;
  }

  static bool login(String email, String password) {
    if (email == _email && password == _password) {
      isLoggedIn = true;
      return true;
    }
    return false;
  }

  static void logout() {
    isLoggedIn = false;
  }
}
