import 'package:flutter/material.dart';
import 'bluetooth_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          0,
        ), // Remove a barra padrão da AppBar.
        child: SizedBox.shrink(),
      ),
      body: Stack(
        children: [
          // Botão central
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NovaBluetoothScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(
                  40,
                ), // Aumenta o tamanho do botão.
                shape: const CircleBorder(), // Define o botão como circular.
              ),
              child: const Icon(
                Icons.bluetooth,
                size: 50, // Aumenta o tamanho do ícone.
              ),
            ),
          ),
          // Botão superior direito com a logo
          Positioned(
            top: 40, // Define a posição um pouco abaixo do topo.
            right: 20, // Define a margem à direita.
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              child: ClipOval(
                child: Container(
                  width: 100, // Define a largura maior.
                  height: 100, // Define a altura maior.
                  color: Colors.deepPurple, // Cor de fundo do botão.
                  child: Image.asset('assets/profile.jpg', fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black45,
    );
  }
}
