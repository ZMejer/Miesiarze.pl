import 'database_helper.dart';

class AuthService {
  static bool _isLoggedIn = false;

  static bool isLoggedIn() {
    return _isLoggedIn;
  }

  static Future<bool> login(String email, String password) async {
    final user = await DatabaseHelper.instance.getUser(email, password);
    if (user != null) {
      _isLoggedIn = true;
      return true;
    }
    return false;
  }

  static void logout() {
    _isLoggedIn = false;
  }
}
