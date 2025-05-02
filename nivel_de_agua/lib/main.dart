import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/bluetooth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove a faixa de debug
      home: const SplashScreen(),
    );
  }
}

// Tela home
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //botao que vai fazer conexao com a tela de bluetooth
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BluetoothScreen()), //chamada da classe bluetoothscreen
            );
          },
          //personalizacao do botao do bluetooth
          icon:  Icon(Icons.bluetooth),
          label:  Text("Conectar Bluetooth"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
      ),
   
      //cor de fundo
      backgroundColor: Colors.black45,
    );
  }
}

