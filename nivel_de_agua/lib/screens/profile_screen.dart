import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'log_report_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('id');
      _nomeController.text = prefs.getString('nomeusuario') ?? '';
      _loginController.text = prefs.getString('login') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
    });
  }

  Future<void> _updateUser() async {
    if (userId == null) return;

    final url = Uri.parse('https://backendprojetouninassau-production.up.railway.app/monitoapi/usuarios/$userId');
    final body = jsonEncode({
      "usuario": _usuarioController.text,
      "nomeusuario": _nomeController.text,
      "telefone": _telefoneController.text,
      "email": _emailController.text,
      "login": _loginController.text,
      "senha": _senhaController.text,
    });

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        _showDialog('Sucesso', 'Dados atualizados com sucesso!');
      } else {
        final data = jsonDecode(response.body);
        _showDialog('Erro', data['message'] ?? 'Erro ao atualizar dados');
      }
    } catch (e) {
      _showDialog('Erro', 'Falha na conexão: $e');
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildTextField(_usuarioController, 'Usuário'),
            _buildTextField(_nomeController, 'Nome do Usuário'),
            _buildTextField(_telefoneController, 'Telefone'),
            _buildTextField(_emailController, 'E-mail'),
            _buildTextField(_loginController, 'Login'),
            _buildTextField(_senhaController, 'Senha', obscure: true),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              onPressed: _updateUser,
              child: const Text('Salvar Alterações'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LogReportScreen())
                );
              },
              child: const Text('Ver Relatório de Logs'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
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
    );
  }
}
