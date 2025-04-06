import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'auth_service.dart';

class AddCardScreen extends StatelessWidget {
  const AddCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dodaj kartę wędkarską')),
      body: const Center(
        child: Text('Formularz dodawania karty wędkarskiej'),
      ),
    );
  }
}