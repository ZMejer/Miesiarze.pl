import 'dart:convert';
import 'package:http/http.dart' as http;

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
    final url = Uri.parse('http://10.0.2.2:90/login.php');
    final response = await http.post(url, body: {
      'email': email,
      'password': password,
    });

    final data = json.decode(response.body);

    if (response.statusCode == 200 && data['status'] == 'success') {
      _isLoggedIn = true;
      _currentUser = data['user'];
      return true;
    }

    return false;
  }

  static void logout() {
    _isLoggedIn = false;
    _currentUser = null;
  }
}
