import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'auth_service.dart';
import 'add_card_screen.dart';
import 'add_permit_screen.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.getCurrentUser();

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Brak danych użytkownika')),
      );
    }

    final String userDocumentUrl =
        "http://172.20.10.6:90/license.php?firstName=${user['name']}&lastName=${user['surname']}&cardNumber=${user['card_number']}";

    final List<Map<String, String>> documents = [
      {
        "title": "Karta wędkarska",
        "qrData": userDocumentUrl,
      },
      {
        "title": "Zezwolenie (okręg we Wrocławiu)",
        "qrData": "https://example.com",
      },
      {
        "title": "Zezwolenie (okręg w Krakowie)",
        "qrData": "https://example.com",
      },
      {
        "title": "Zezwolenie (okręg w Warszawie)",
        "qrData": "https://example.com",
      },
    ];

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Moje dokumenty',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: documents.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final doc = documents[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QrCodeScreen(
                          title: doc['title']!,
                          qrData: doc['qrData']!,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: 300,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.qr_code, size: 40),
                          const SizedBox(height: 12),
                          Text(
                            doc['title']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCardScreen(),
                      ),
                    );
                  },
                  child: const Text('Dodaj kartę wędkarską'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddPermitScreen(),
                      ),
                    );
                  },
                  child: const Text('Dodaj zezwolenie'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QrCodeScreen extends StatelessWidget {
  final String title;
  final String qrData;

  const QrCodeScreen({super.key, required this.title, required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: QrImageView(
          data: qrData,
          version: QrVersions.auto,
          size: 300.0,
          gapless: false,
        ),
      ),
    );
  }
}