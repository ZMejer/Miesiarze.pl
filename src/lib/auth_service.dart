import 'database_helper.dart';

class AuthService {
  static bool _isLoggedIn = false;
  static Map<String, dynamic>? _currentUser;

  static bool isLoggedIn() {
    return _isLoggedIn;
  }

  static Map<String, dynamic>? getCurrentUser() {
    return _currentUser;
  }

  static Future<bool> login(String email, String password) async {
    final user = await DatabaseHelper.instance.getUser(email, password);
    if (user != null) {
      _isLoggedIn = true;
      _currentUser = user;
      return true;
    }
    return false;
  }

  static void logout() {
    _isLoggedIn = false;
    _currentUser = null;
  }
}
