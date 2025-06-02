import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bluetoothdiscoveryscreen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String nomeUsuario = '';
  String saudacao = '';
  String? imagePath;
  int? userId;

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    final nome = prefs.getString('nomeusuario') ?? '';

    String? caminhoImagem;
    if (id != null) {
      caminhoImagem = prefs.getString('profile_image_path_$id');
    }

    setState(() {
      userId = id;
      nomeUsuario = nome;
      saudacao = _obterSaudacao();
      imagePath = caminhoImagem;
    });
  }

  String _obterSaudacao() {
    final hora = DateTime.now().hour;
    if (hora >= 5 && hora < 12) {
      return 'Bom dia';
    } else if (hora >= 12 && hora < 18) {
      return 'Boa tarde';
    } else {
      return 'Boa noite';
    }
  }

  Widget _avatarDinamico() {
    if (imagePath != null && File(imagePath!).existsSync()) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: FileImage(File(imagePath!)),
      );
    } else if (nomeUsuario.isNotEmpty) {
      return _iniciaisAvatar();
    } else {
      return const CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white24,
        child: Icon(Icons.person, color: Colors.white),
      );
    }
  }

  Widget _iniciaisAvatar() {
    List<String> nomes = nomeUsuario.split(' ');
    String iniciais = '';
    if (nomes.isNotEmpty) {
      iniciais += nomes[0].isNotEmpty ? nomes[0][0] : '';
    }
    if (nomes.length > 1) {
      iniciais += nomes[1].isNotEmpty ? nomes[1][0] : '';
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.deepPurple,
      child: Text(
        iniciais.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          '$saudacao, $nomeUsuario! 👋',
          style: const TextStyle(fontSize: 20),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              ).then((_) {
                _carregarUsuario();
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _avatarDinamico(),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black45,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BluetoothDiscoveryScreen()),
                );
              },
              icon: const Icon(Icons.bluetooth),
              label: const Text("Conectar e Monitorar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text("Sair"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
