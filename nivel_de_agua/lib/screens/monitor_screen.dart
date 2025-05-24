import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:http/http.dart' as http;

class MonitoramentoScreen extends StatefulWidget {
  @override
  _MonitoramentoScreenState createState() => _MonitoramentoScreenState();
}

class _MonitoramentoScreenState extends State<MonitoramentoScreen> {
  BluetoothConnection? connection;
  bool isConnected = false;
  String nivelAgua = "Desconhecido";

  Future<void> conectarDispositivo() async {
    try {
      List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance.getBondedDevices();
      BluetoothDevice? hc05 = devices.firstWhere(
        (device) =>
            device.name != null &&
            device.name!.toLowerCase().contains("hc") &&
            device.name!.contains("05"),
        orElse: () => throw Exception("Nenhum módulo HC-05 pareado encontrado."),
      );

      await BluetoothConnection.toAddress(hc05.address).then((_connection) {
        connection = _connection;
        setState(() => isConnected = true);
        print("Conectado ao ${hc05.name}!");

        connection!.input!.listen((data) {
          String recebidos = utf8.decode(data).trim();
          print("Dado recebido: $recebidos");

          if (recebidos.contains(RegExp(r'[0-9]'))) {
            double? valor = double.tryParse(recebidos);
            if (valor != null) {
              setState(() {
                nivelAgua = "$valor cm";
              });
              enviarParaBackend(valor);
            }
          }
        });
      });
    } catch (e) {
      print("Erro ao conectar: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
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
      print("Enviado ao backend: ${response.statusCode}");
    } catch (e) {
      print("Erro ao enviar para backend: $e");
    }
  }

  @override
  void dispose() {
    connection?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Monitoramento")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Nível da água:", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text(nivelAgua, style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: isConnected ? null : conectarDispositivo,
              child: Text("Iniciar Monitoramento"),
            ),
          ],
        ),
      ),
    );
  }
}
