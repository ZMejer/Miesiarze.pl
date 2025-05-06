import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'auth_service.dart';
import 'add_card_screen.dart';
import 'add_permit_screen.dart';
import 'package:http/http.dart' as http;
import 'fee_payment.dart';


class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();

}

class _DocumentsScreenState extends State<DocumentsScreen> {

  Future<List<Map<String, dynamic>>> _fetchPermits(String email) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:90/get_user_permits.php'),
      body: {'email': email},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return List<Map<String, dynamic>>.from(data['permits']);
      } else {
        throw Exception('Błąd API: ${data['message']}');
      }
    } else {
      throw Exception('Błąd serwera: ${response.statusCode}');
    }
  }

  late Future<List<Map<String, dynamic>>> _permitsFuture;

  @override
  void initState() {
    super.initState();
    final user = AuthService.getCurrentUser();
    if (user != null) {
      _permitsFuture = _fetchPermits(user['email']);
    }
  }

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

    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _permitsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Błąd: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Brak zezwoleń'));
          }

          final permits = snapshot.data!;

          final districtNames = {
            'WWA': 'Warszawa',
            'KRK': 'Kraków',
            'WRO': 'Wrocław',
            'JEL': 'Jelenia Góra',
          };

          final documents = [
            {
              "title": "Karta wędkarska",
              "qrData": userDocumentUrl,
            },
            {
              "title": "Legitymacja członkowska PZW",
              "qrData": userDocumentUrl,
            },
            ...permits.map((p) => {
              "title":
              "Zezwolenie (okręg ${districtNames[p['district']] ?? p['district']})",
              "qrData": "http://example.com/permit/${p['id']}",
            }),
          ];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
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
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddPermitScreen(),
                          ),
                        );
                        final user = AuthService.getCurrentUser();
                        if (user != null) {
                          setState(() {
                            _permitsFuture = _fetchPermits(user['email']);
                          });
                        }
                      },
                      child: const Text('Dodaj zezwolenie'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FeePaymentScreen(),
                          ),
                        );
                      },
                      child: const Text('Opłać składki członkowskie'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
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