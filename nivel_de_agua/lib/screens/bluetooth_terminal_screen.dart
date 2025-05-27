import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:http/http.dart' as http;

class BluetoothTerminalScreen extends StatefulWidget {
  final BluetoothDevice device;

  const BluetoothTerminalScreen({Key? key, required this.device}) : super(key: key);

  @override
  _BluetoothTerminalScreenState createState() => _BluetoothTerminalScreenState();
}

class _BluetoothTerminalScreenState extends State<BluetoothTerminalScreen> {
  BluetoothConnection? connection;
  List<String> messages = [];
  TextEditingController messageController = TextEditingController();
  bool isConnected = false;
  bool isMonitoring = false;

  @override
  void initState() {
    super.initState();
    _connect();
  }

  void _connect() async {
    try {
      connection = await BluetoothConnection.toAddress(widget.device.address);
      setState(() => isConnected = true);
      print("Conectado com sucesso!");

      connection!.input!.listen((data) {
        if (isMonitoring) {
          final message = utf8.decode(data).trim();
          print("Mensagem recebida: $message");

          setState(() => messages.add('Arduino: $message'));

          final match = RegExp(r'(\d+(\.\d+)?)').firstMatch(message);
          if (match != null) {
            double valor = double.parse(match.group(0)!);
            print("Enviando para backend: $valor cm");
            enviarParaBackend(valor);
          }
        }
      }).onDone(() {
        print("Conexão encerrada");
        setState(() {
          isConnected = false;
          isMonitoring = false;
        });
      });
    } catch (e) {
      setState(() => messages.add('Erro ao conectar: $e'));
      print("Erro ao conectar: $e");
    }
  }

  void _sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty && connection != null && isConnected) {
      connection!.output.add(Uint8List.fromList(text.codeUnits));
      setState(() => messages.add('Você: $text'));
      messageController.clear();
    }
  }

  Future<void> enviarParaBackend(double valor) async {
    final url = Uri.parse("https://backendprojetouninassau-production.up.railway.app/monitoapi/registros");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"nivel_agua": valor}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Enviado ao backend com sucesso: $valor cm");
      } else {
        print("❌ Erro ao enviar. Código: ${response.statusCode}, Corpo: ${response.body}");
      }
    } catch (e) {
      print("❌ Erro de conexão ao backend: $e");
    }
  }

  void _startMonitoring() {
    setState(() {
      isMonitoring = true;
      messages.add("🔄 Monitoramento iniciado.");
    });
  }

  void _stopMonitoring() {
    setState(() {
      isMonitoring = false;
      messages.add("⏹️ Monitoramento pausado.");
    });
  }

  @override
  void dispose() {
    connection?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terminal - ${widget.device.name}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: messages
                  .map((msg) => Text(msg, style: const TextStyle(color: Colors.white)))
                  .toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: isConnected ? _startMonitoring : null,
                icon: const Icon(Icons.play_arrow),
                label: const Text("Iniciar"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              ElevatedButton.icon(
                onPressed: isConnected ? _stopMonitoring : null,
                icon: const Icon(Icons.stop),
                label: const Text("Parar"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            color: Colors.deepPurple.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Digite uma mensagem...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
