import 'package:flutter/material.dart';
import 'auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.getCurrentUser();

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Zaloguj się, aby wyświetlić profil.')),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Mój profil',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('ID: ${user['id']}'),
            Text('Email: ${user['email']}'),
          ],
        ),
      ),
    );
  }
}