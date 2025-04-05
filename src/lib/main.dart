import 'package:flutter/material.dart';
import 'documents_screen.dart';
import 'reports_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'auth_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bottom Nav Demo',
      initialRoute: '/',
      routes: {
        '/': (_) => MainScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    DocumentsScreen(),
    ReportsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mięsiarze.pl'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'Mięsiarze.pl',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Dokumenty'),
              onTap: () {
                setState(() {
                  _currentIndex = 0; // Przejście do ekranu Dokumentów
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Rejestr'),
              onTap: () {
                setState(() {
                  _currentIndex = 1; // Przejście do ekranu Rejestru
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                setState(() {
                  _currentIndex = 2; // Przejście do ekranu Profilu
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Logowanie'),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Rejestracja'),
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Wyloguj się'),
              onTap: () {
                AuthService.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),

      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dokumenty',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Rejestr',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
