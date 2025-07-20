import 'dart:async';
import 'package:dashboard/platform_channels.dart';
import 'package:dashboard/sensor_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _loading = true;
  int? battery;
  String? deviceName;
  String? osVersion;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      errorMessage = null;
    });

    try {
      final b = await PlatformChannels.getBatteryLevel();
      final d = await PlatformChannels.getDeviceName();
      final os = await PlatformChannels.getOSVersion();

      setState(() {
        battery = b;
        deviceName = d;
        osVersion = os;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch data: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Screen"),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Lottie.asset(
            'assets/lottie/background.json',
            fit: BoxFit.contain,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: _loading
                      ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 150,
                        child: Lottie.asset(
                          'assets/lottie/loading.json',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Loading device information...",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                      : errorMessage != null
                      ? Text(
                    errorMessage!,
                    style: const TextStyle(
                        color: Colors.red, fontSize: 16),
                  )
                      : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _InfoTile(
                        icon: Icons.battery_full,
                        label: 'Battery',
                        value: '${battery ?? '-'}%',
                      ),
                      const SizedBox(height: 12),
                      _InfoTile(
                        icon: Icons.phone_android,
                        label: 'Device',
                        value: deviceName ?? '-',
                      ),
                      const SizedBox(height: 12),
                      _InfoTile(
                        icon: Icons.computer,
                        label: 'OS',
                        value: osVersion ?? '-',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SensorScreen()),
                  );
                },
                icon: const Icon(Icons.sensors),
                label: const Text("Go to Sensor Info"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Text(value,
                  style:
                  const TextStyle(fontSize: 14, color: Colors.black54)),
            ],
          ),
        )
      ],
    );
  }
}




