import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class FeePaymentScreen extends StatefulWidget {
  const FeePaymentScreen({super.key});

  @override
  State<FeePaymentScreen> createState() => _FeePaymentScreenState();
}

class _FeePaymentScreenState extends State<FeePaymentScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Opłacanie składek')),
    );
  }
}
