import 'package:flutter/material.dart';
import 'bluetooth_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: Colors.deepPurple,
        titleTextStyle: const TextStyle(
          fontStyle: FontStyle.italic,
          letterSpacing: 1.5,
          fontSize: 25,
        ),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BluetoothScreen()),
            );
          },
          icon: const Icon(Icons.bluetooth),
          label: const Text("Conectar Bluetooth"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
      ),
      backgroundColor: Colors.black45,
    );
  }
}