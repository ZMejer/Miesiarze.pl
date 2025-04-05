import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _cardNumberController = TextEditingController();
  String _gender = 'K';
  bool _isStudent = false;

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim();
    final birthdate = _birthdateController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();
    final cardNumber = _cardNumberController.text.trim();

    if ([email, password, name, surname, birthdate, phoneNumber, cardNumber].any((e) => e.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Uzupełnij wszystkie pola')),
      );
      return;
    }

    final url = Uri.parse('http://10.0.2.2:90/register.php');
    final response = await http.post(url, body: {
      'email': email,
      'password': password,
      'name': name,
      'surname': surname,
      'gender': _gender,
      'birthdate': birthdate,
      'phoneNumber': phoneNumber,
      'cardNumber': cardNumber,
      'isStudent': _isStudent ? '1' : '0',
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final data = json.decode(response.body);

    if (response.statusCode == 200 && data['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rejestracja udana')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Błąd rejestracji')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rejestracja')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Imię')),
            TextField(controller: _surnameController, decoration: const InputDecoration(labelText: 'Nazwisko')),
            DropdownButtonFormField<String>(
              value: _gender,
              items: const [
                DropdownMenuItem(value: 'K', child: Text('Kobieta')),
                DropdownMenuItem(value: 'M', child: Text('Mężczyzna')),
              ],
              onChanged: (value) => setState(() => _gender = value ?? 'K'),
              decoration: const InputDecoration(labelText: 'Płeć'),
            ),
            TextField(
              controller: _birthdateController,
              decoration: const InputDecoration(labelText: 'Data urodzenia (YYYY-MM-DD)'),
            ),
            TextField(controller: _phoneNumberController, decoration: const InputDecoration(labelText: 'Numer telefonu')),
            TextField(controller: _cardNumberController, decoration: const InputDecoration(labelText: 'Numer karty')),
            Row(
              children: [
                const Text('Jestem studentem'),
                Checkbox(value: _isStudent, onChanged: (val) => setState(() => _isStudent = val ?? false)),
              ],
            ),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Hasło')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _register, child: const Text('Zarejestruj się')),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Wróć do ekranu głównego'),
            ),
          ],
        ),
      ),
    );
  }
}
