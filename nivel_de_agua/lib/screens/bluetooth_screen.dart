import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothScreen extends StatelessWidget {
  const BluetoothScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dispositivos Bluetooth")),
      body: StreamBuilder<List<ScanResult>>(
        stream: FlutterBluePlus.scanResults,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final results = snapshot.data!;
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return ListTile(
                  title: Text(result.device.name.isEmpty
                      ? "Dispositivo sem nome"
                      : result.device.name),
                  subtitle: Text(result.device.id.toString()),
                  onTap: () {
                    // Conectar no dispositivo, etc.
                  },
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
        },
      ),
    );
  }
}
