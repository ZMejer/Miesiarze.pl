import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'database_helper.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final user = await DatabaseHelper.instance.getUser(email, password);
    if (user != null) {
      final success = await AuthService.login(email, password);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logowanie udane')),
        );
        Navigator.pushReplacementNamed(context, '/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Błąd logowania')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Błędny email lub hasło')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logowanie')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Hasło')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('Zaloguj')),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Nie masz konta? Zarejestruj się'),
            ),
            TextButton(
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
                    (Route<dynamic> route) => false,
              ),
              child: const Text('Wróć do ekranu głównego'),
            )
          ],
        ),
      ),
    );
  }
}
