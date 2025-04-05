import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'auth_service.dart';

class DocumentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = AuthService.getCurrentUser();

    if (user == null) {
      return Scaffold(
        body: Center(child: Text('Brak danych użytkownika')),
      );
    }

    String userProfileUrl = "http://192.168.34.12:90/license.php?firstName=${user['name']}&lastName=${user['surname']}";

    return Scaffold(
      body: Center(
        child: QrImageView(
          data: userProfileUrl,
          version: QrVersions.auto,
          size: 300.0,
          gapless: false,
        ),
      ),
    );
  }
}
