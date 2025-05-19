import 'package:flutter/material.dart';

class AlterPassScreen extends StatefulWidget {
  const AlterPassScreen({super.key});

  @override
  State<AlterPassScreen> createState() => _AlterPassScreenState();
}

class _AlterPassScreenState extends State<AlterPassScreen> {
  final TextEditingController _emailOrPhoneController = TextEditingController();

  // Função para buscar a conta
  void _findAccount() {
    FocusScope.of(context).unfocus(); // Fecha o teclado
    final input = _emailOrPhoneController.text.trim();

    if (input.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Erro"),
          content: const Text("Por favor, insira um e-mail válido."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      // Aqui, você pode implementar a lógica para buscar a conta
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Conta encontrada"),
          content: Text("Enviaremos instruções para $input."),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Esqueci minha senha"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            ClipOval(
              child: Image.asset(
                'assets/logo.png',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Insira seu e-mail para buscar sua conta",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailOrPhoneController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "E-mail",
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.deepPurple),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.deepPurple),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.deepPurple),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _findAccount,
              child: const Text("Buscar conta"),
            ),
            const SizedBox(height: 25),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text(
                "Voltar para o login",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
