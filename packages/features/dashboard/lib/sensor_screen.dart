
import 'package:dashboard/platform_channels.dart';
import 'package:flutter/material.dart';

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
    setState(() => _loading = true);

    // simulate initial load
    await Future.delayed(const Duration(seconds: 2));

    // load gyro data from platform channel
    await _readGyro();

    setState(() {
      _loading = false;
    });
  }

  Future<void> _toggleFlashlight() async {
    _flashlightOn = !_flashlightOn;
    await PlatformChannels.toggleFlashlight(_flashlightOn);
    setState(() {});
  }

  Future<void> _readGyro() async {
    final data = await PlatformChannels.getGyroscopeData();

    setState(() {
      _gyroX = data['x'].toStringAsFixed(2);
      _gyroY = data['y'].toStringAsFixed(2);
      _gyroZ = data['z'].toStringAsFixed(2);
    });
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Gyroscope",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          tooltip: "Refresh Gyroscope",
                          onPressed: _readGyro,
                        )
                      ],
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