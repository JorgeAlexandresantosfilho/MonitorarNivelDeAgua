import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'alterpass_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _currentEmailController = TextEditingController();
  final TextEditingController _currentUsernameController =
      TextEditingController();

  File? _profileImage;

  @override
  void initState() {
    super.initState();
    // Removido o preenchimento automático dos campos atuais
    // _currentUsernameController.text = 'usuario_atual';
    // _currentEmailController.text = 'email@atual.com';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _currentEmailController.dispose();
    _currentUsernameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _saveChanges() {
    final newUsername = _usernameController.text.trim();
    final newEmail = _emailController.text.trim();

    if (newUsername.isEmpty || newEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    // Aqui você implementaria a lógica de salvar no backend, etc.

    // Apenas para demonstração:
    log('Salvando dados: $newUsername, $newEmail');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Alterações salvas!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage('assets/profile.jpg')
                              as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: const CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.deepPurple,
                      child: Icon(
                        Icons.camera_alt,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _currentUsernameController,
              style: const TextStyle(color: Colors.white),
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration('Nome de Usuário Atual'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              style: const TextStyle(color: Colors.white),
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration('Nome de Usuário'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _currentEmailController,
              style: const TextStyle(color: Colors.white),
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration('Email Atual'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _saveChanges(),
              decoration: _inputDecoration('Email'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Salvar Alterações'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EsqueceuSenhaScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Alterar Senha'),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.black54,
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
    );
  }
}
