import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'login_screen.dart';
import 'main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final existingUser = await DatabaseHelper.instance.getUser(email, password);
    if (existingUser != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Użytkownik już istnieje')),
      );
      return;
    }

    await DatabaseHelper.instance.insertUser({
      'email': email,
      'password': password,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rejestracja udana')),
    );

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rejestracja')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Hasło')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _register, child: const Text('Zarejestruj się')),
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
