import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class MonitoramentoScreen extends StatefulWidget {
  final BluetoothDevice device;
  const MonitoramentoScreen({required this.device, super.key});

  @override
  State<MonitoramentoScreen> createState() => _MonitoramentoScreenState();
}

class _MonitoramentoScreenState extends State<MonitoramentoScreen> {
  BluetoothCharacteristic? characteristic;
  String nivelAgua = "N/A";

  @override
  void initState() {
    super.initState();
    discoverServices();
  }

  void discoverServices() async {
    List<BluetoothService> services = await widget.device.discoverServices();
    for (var service in services) {
      for (var char in service.characteristics) {
        if (char.properties.notify) {
          await char.setNotifyValue(true);
          if (!mounted) return;
          char.value.listen((data) {
            setState(() {
              nivelAgua = String.fromCharCodes(
                data,
              ); // ← Aqui lê os dados do Arduino
            });
          });
          characteristic = char;
        }
      }
    }
  }

  void sendCommand(String cmd) async {
    if (characteristic != null) {
      await characteristic!.write(cmd.codeUnits);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Comando "$cmd" enviado')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monitoramento em Tempo Real')),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Text(
              'Nível da Água:',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            Text(
              nivelAgua,
              style: const TextStyle(color: Colors.cyanAccent, fontSize: 48),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () => sendCommand("LIGAR_BOMBA"),
              icon: const Icon(Icons.power),
              label: const Text('Ligar Bomba'),
            ),
            ElevatedButton.icon(
              onPressed: () => sendCommand("DESLIGAR_BOMBA"),
              icon: const Icon(Icons.power_off),
              label: const Text('Desligar Bomba'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
