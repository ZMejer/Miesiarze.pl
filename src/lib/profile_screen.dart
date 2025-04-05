import 'package:flutter/material.dart';
import 'auth_service.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AuthService.isLoggedIn()
          ? const Text('Mój profil')
          : const Text('Zaloguj się, by wyświetlić profil'),
    );
  }
}
