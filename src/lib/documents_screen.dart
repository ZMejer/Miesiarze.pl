import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DocumentsScreen extends StatelessWidget {
  final String firstName = "Jan";
  final String lastName = "Kowalski";

  @override
  Widget build(BuildContext context) {
    String userProfileUrl = "https://httpbin.org/get?firstName=$firstName&lastName=$lastName";

    return Scaffold(
      appBar: AppBar(title: const Text('QR Code Example')),
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
