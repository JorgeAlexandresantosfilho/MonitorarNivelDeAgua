import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class NovaBluetoothScreen extends StatefulWidget {
  const NovaBluetoothScreen({super.key});

  @override
  State<NovaBluetoothScreen> createState() => _NovaBluetoothScreenState();
}

class _NovaBluetoothScreenState extends State<NovaBluetoothScreen> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? connectedDevice;

  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() {
    flutterBlue.startScan(timeout: const Duration(seconds: 4));
  }

  void connectToDevice(BluetoothDevice device) async {
    await device.connect();
    if (!mounted) return;
    setState(() {
      connectedDevice = device;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Conectado a: ${device.name}')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dispositivos Bluetooth')),
      body: StreamBuilder<List<ScanResult>>(
        stream: flutterBlue.scanResults,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();

          final results = snapshot.data!;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final device = results[index].device;
              return ListTile(
                title: Text(device.name.isNotEmpty ? device.name : 'Sem nome'),
                subtitle: Text(device.id.id),
                onTap: () => connectToDevice(device),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: startScan,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
