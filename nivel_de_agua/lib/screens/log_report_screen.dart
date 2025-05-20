import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class LogReportScreen extends StatefulWidget {
  const LogReportScreen({super.key});

  @override
  State<LogReportScreen> createState() => _LogReportScreenState();
}

class _LogReportScreenState extends State<LogReportScreen> {
  List<dynamic> logs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final loginUsuario = prefs.getString('login');

    final url = Uri.parse(
        'https://backendprojetouninassau-production.up.railway.app/api/logs');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final allLogs = jsonDecode(response.body) as List<dynamic>;
        final userLogs = allLogs
            .where((log) => log['login_usuario'] == loginUsuario)
            .toList();

        setState(() {
          logs = userLogs;
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
        _showError('Erro ao buscar logs');
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      _showError('Erro de conexão: $e');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Erro'),
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

  String formatarData(String? data) {
    if (data == null) return 'Sem data';
    try {
      final dateTime = DateTime.parse(data).toLocal();
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    } catch (e) {
      return 'Sem data';
    }
  }

  Widget _buildLogItem(Map<String, dynamic> log) {
    return Card(
      color: Colors.deepPurple.shade100,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ListTile(
        title: Text('Ação: ${log['tpacao'] ?? 'Desconhecida'}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Data: ${formatarData(log['datacao'])}'),
            if (log['dsregold'] != null && log['dsregnew'] != null)
              Text('Descrição: ${log['dsregold']} ➡ ${log['dsregnew']}'),
            if (log['nomeusuarioold'] != null && log['nomeusuarionew'] != null)
              Text('Usuário: ${log['nomeusuarioold']} ➡ ${log['nomeusuarionew']}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Relatório de Logs'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : logs.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum log encontrado.',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (_, index) {
                    return _buildLogItem(logs[index]);
                  },
                ),
    );
  }
}
