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

    // Definiowanie koloru obramowania wokół CircleAvatar
    const Color avatarBorderColor = Color(0xFFF7F2FA); // Kolor #f7f2fa
    const Color profileBackgroundColor = Color(0xFF1A263E); // Kolor tła niebieskiego

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 140,
                width: double.infinity,
                color: profileBackgroundColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40), // odstęp pod „Profil”
                      Text('Imię: ${user['name']}'),
                      Text('Nazwisko: ${user['surname']}'),
                      Text('Email: ${user['email']}'),
                      Text('Płeć: ${user['gender'] == 0 ? 'Kobieta' : 'Mężczyzna'}'),
                      Text('Data urodzenia: ${user['birthdate']}'),
                      Text('Telefon: ${user['phone_number']}'),
                      Text('Numer karty: ${user['card_number']}'),
                      Text('Student: ${user['is_student'] == 1 ? 'Tak' : 'Nie'}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Prostokąt z napisem z imieniem użytkownika
          Positioned(
            top: 50, // Ustawiamy początek prostokąta tuż pod kółkiem
            left: 20,
            right: 20,
            height: 140,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 25),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end, // Wyrównanie tekstu do dołu
                  children: [
                    Text(
                      '${user['name']} ${user['surname']}', // Zmieniony na dynamiczne imię
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Kółko z wyższym z-indexem (później w kodzie, dlatego ma wyższy z-index)
          Positioned(
            top: 0, // Przesuwamy kółko wyżej, aby było nad paskiem
            left: MediaQuery.of(context).size.width / 2 - 60, // Wyśrodkowanie kółka
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: avatarBorderColor, // Biały kolor z #f7f2fa
              ),
              padding: const EdgeInsets.all(8), // Odstęp wewnętrzny, aby zrobić efekt border
              child: CircleAvatar(
                radius: 55, // Rozmiar okręgu
                backgroundImage: NetworkImage(
                  'https://www.w3schools.com/w3images/avatar2.png',
                ),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
