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
      body: user == null
          ? const Center(child: Text('Brak danych użytkownika'))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Imię: ${user['name']}'),
            Text('Nazwisko: ${user['surname']}'),
            Text('Email: ${user['email']}'),
            Text('Płeć: ${user['gender'] == 0 ? 'Kobieta' : 'Mężczyzna'}'),
            Text('Data urodzenia: ${user['birthdate']}'),
            Text('Telefon: ${user['phoneNumber']}'),
            Text('Numer karty: ${user['cardNumber']}'),
            Text('Student: ${user['isStudent'] == 1 ? 'Tak' : 'Nie'}'),
          ],
        ),
      ),
    );

  }
}