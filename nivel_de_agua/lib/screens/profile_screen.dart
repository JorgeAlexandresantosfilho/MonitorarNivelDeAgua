import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.black,
      body: const Center(
        child: Text(
          'Tela de Perfil do Usuário',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
