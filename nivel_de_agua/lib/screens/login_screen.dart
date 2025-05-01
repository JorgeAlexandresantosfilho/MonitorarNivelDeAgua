import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  void _login() {
    if (_userController.text == 'admin' && _passController.text == '123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Erro"),
          content: const Text("Usuário ou senha inválidos"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar removido!
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView( // Adicionei pra evitar erro em telas pequenas
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              // imagem do logo
              ClipOval(
                child: Image.asset(
                  'assets/logo.png',
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
              // Campos de usuário e senha
              const SizedBox(height: 60), // Espaçamento maior entre a imagem e as caixas
              // Campos de entrada de usuário e senha
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _userController,
                  style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    labelText: "Usuário",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _passController,
                  style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    labelText: "Senha",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 32),
              // Botões
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Fundo preto
                      foregroundColor: Colors.deepPurple, // Texto roxo
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: _login,
                    child: const Text("Entrar"),
                  ),
                  const SizedBox(width: 16), // Espaço entre os botões
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Fundo preto
                      foregroundColor: Colors.deepPurple, // Texto roxo
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: _navigateToRegister,
                    child: const Text("Cadastrar"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Botão "Esqueci a senha" centralizado abaixo
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Funcionalidade ainda não implementada"),
                    ),
                  );
                },
                child: const Text(
                  "Esqueci a senha",
                  style: TextStyle(
                    color: Colors.deepPurple, // Texto roxo
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}