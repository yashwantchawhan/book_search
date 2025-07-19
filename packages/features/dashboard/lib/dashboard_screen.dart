import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _loading = false;
    });
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
                      : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      _InfoTile(
                        icon: Icons.battery_full,
                        label: 'Battery',
                        value: '83%',
                      ),
                      SizedBox(height: 12),
                      _InfoTile(
                        icon: Icons.phone_android,
                        label: 'Device',
                        value: 'Pixel 6 Pro',
                      ),
                      SizedBox(height: 12),
                      _InfoTile(
                        icon: Icons.computer,
                        label: 'OS',
                        value: 'Android 14',
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

// dummy screen just to navigate

class SensorScreen extends StatefulWidget {
  const SensorScreen({super.key});

  @override
  State<SensorScreen> createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  bool _flashlightOn = false;
  String _gyroX = "0.00";
  String _gyroY = "0.00";
  String _gyroZ = "0.00";
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSensors();
  }

  Future<void> _loadSensors() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _loading = false;
    });
    // TODO: Start listening to gyroscope stream & platform channels here
  }

  void _toggleFlashlight() {
    setState(() {
      _flashlightOn = !_flashlightOn;
    });
    // TODO: Call platform channel to toggle flashlight here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sensor Info"),
        centerTitle: true,
      ),
      body: _loading
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              "Fetching sensor data...",
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Flashlight",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Switch.adaptive(
                      value: _flashlightOn,
                      onChanged: (_) => _toggleFlashlight(),
                      activeColor: Colors.blueAccent,
                    ),
                    Text(
                      _flashlightOn ? "ON" : "OFF",
                      style: TextStyle(
                          color: _flashlightOn
                              ? Colors.green
                              : Colors.grey),
                    )
                  ],
                ),
              ),
            ),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Gyroscope",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _gyroTile("X", _gyroX),
                    const SizedBox(height: 8),
                    _gyroTile("Y", _gyroY),
                    const SizedBox(height: 8),
                    _gyroTile("Z", _gyroZ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gyroTile(String axis, String value) {
    return Row(
      children: [
        Text(
          "$axis-axis:",
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }
}

