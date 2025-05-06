import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class AddPermitScreen extends StatefulWidget {
  const AddPermitScreen({super.key});

  @override
  State<AddPermitScreen> createState() => _AddPermitScreenState();
}

class _AddPermitScreenState extends State<AddPermitScreen> {
  String _district = 'WRO';
  Future<void> _add_permit() async {
    final user = AuthService.getCurrentUser();
    String email = user?['email'];

    final url = Uri.parse('http://10.0.2.2:90/add_permit.php');
    final response = await http.post(url, body: {
      'district': _district,
      'email': email,
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final data = json.decode(response.body);

    if (response.statusCode == 200 && data['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dodano zezwolenie')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Błąd przy dodawaniu zezwolenia')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dodawanie zezwolenia')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _district,
              items: const [
                DropdownMenuItem(value: 'WRO', child: Text('Okręg we Wrocławiu')),
                DropdownMenuItem(value: 'KRK', child: Text('Okręg w Krakowie')),
                DropdownMenuItem(value: 'WWA', child: Text('Okręg w Warszawie')),
                DropdownMenuItem(value: 'JEL', child: Text('Okręg w Jeleniej Górze')),
              ],
              onChanged: (value) => setState(() => _district = value ?? 'WRO'),
              decoration: const InputDecoration(labelText: 'Okręg'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _add_permit, child: const Text('Dodaj zezwolenie')),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/documents'),
              child: const Text('Wróć do ekranu głównego'),
            ),
          ],
        ),
      ),
    );
  }
}
