import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'log_report_screen.dart';
import 'edit_profile_screen.dart';
import '../services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  String? _imagePath;
  String _nomeUsuario = '';
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    final nome = prefs.getString('nomeusuario') ?? '';

    setState(() {
      _userId = id;
      _nomeUsuario = nome;
    });

    if (_userId != null) {
      await _loadImagePath();
    }
  }

  Future<void> _loadImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profile_image_path_$_userId');

    setState(() {
      _imagePath = path;
    });
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final profileImagesDir = Directory('${appDir.path}/profile_images');
    if (!profileImagesDir.existsSync()) {
      profileImagesDir.createSync();
    }

    final fileName = 'profile_${_userId ?? 'default'}.png';
    final savedImage = await File(pickedFile.path).copy('${profileImagesDir.path}/$fileName');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path_${_userId ?? 0}', savedImage.path);

    setState(() {
      _imagePath = savedImage.path;
    });
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('id');
    if (userId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não encontrado')),
      );
      return;
    }

    final success = await UserService.deleteUser(userId);

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao deletar conta')),
      );
      return;
    }

    await prefs.clear();

    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
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
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.deepPurple,
                    backgroundImage: _imagePath != null
                        ? FileImage(File(_imagePath!))
                        : null,
                    child: _imagePath == null
                        ? const Icon(Icons.person, size: 60, color: Colors.white)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                _nomeUsuario,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
                if (result == true) {
                  _loadUserData();
                }
              },
              child: const Text('Alterar Dados'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LogReportScreen()),
                );
              },
              child: const Text('Ver Relatório de Logs'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _deleteAccount,
              child: const Text('Deletar Conta'),
            ),
          ],
        ),
      ),
    );
  }
}
