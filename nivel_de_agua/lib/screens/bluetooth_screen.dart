import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

/// Tela responsável por listar e selecionar dispositivos Bluetooth disponíveis.
/// Solicita permissões necessárias, ativa o Bluetooth e permite ao usuário
/// selecionar um dispositivo da lista descoberta.
class BluetoothScreen extends StatefulWidget {
  /// Cria uma instância da tela de Bluetooth.
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  /// Lista de dispositivos Bluetooth encontrados.
  List<BluetoothDevice> devices = [];
  /// Dispositivo atualmente selecionado.
  BluetoothDevice? selectedDevice;
  /// Indica se a busca por dispositivos está em andamento.
  bool isDiscovering = false;

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  /// Inicializa o Bluetooth, solicita permissões e inicia a descoberta de dispositivos.
  Future<void> _initBluetooth() async {
    // Solicita permissões
    await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.locationWhenInUse,
    ].request();

    // Ativa Bluetooth se não estiver ligado
    final isEnabled = await FlutterBluetoothSerial.instance.isEnabled;
    if (isEnabled == false) {
      await FlutterBluetoothSerial.instance.requestEnable();
    }

    _startDiscovery();
  }

  /// Inicia a descoberta de dispositivos Bluetooth próximos.
  void _startDiscovery() {
    setState(() {
      isDiscovering = true;
      devices.clear();
    });

    FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
      if (!devices.any((d) => d.address == result.device.address)) {
        setState(() => devices.add(result.device));
      }
    }, onDone: () => setState(() => isDiscovering = false));
  }

  /// Seleciona um dispositivo Bluetooth da lista.
  /// [device] Dispositivo selecionado.
  void _selectDevice(BluetoothDevice device) {
    setState(() => selectedDevice = device);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selecionado: ${device.name ?? device.address}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispositivos Bluetooth'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _startDiscovery,
          ),
        ],
      ),
      body: Column(
        children: [
          if (isDiscovering) const LinearProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return ListTile(
                  title: Text(device.name ?? 'Dispositivo desconhecido'),
                  subtitle: Text(device.address),
                  onTap: () => _selectDevice(device),
                  trailing: selectedDevice?.address == device.address
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
