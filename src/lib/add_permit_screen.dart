import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'auth_service.dart';

class AddPermitScreen extends StatelessWidget {
  const AddPermitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dodaj zezwolenie')),
      body: const Center(
        child: Text('Formularz dodawania zezwolenia'),
      ),
    );
  }
}
