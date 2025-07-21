import 'package:dashboard/presentation/bloc/sensor_bloc.dart';
import 'package:dashboard/presentation/bloc/sensor_event.dart';
import 'package:dashboard/presentation/bloc/sensor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class SensorScreen extends StatefulWidget {
  const SensorScreen({super.key});

  @override
  State<SensorScreen> createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  bool _flashlightOn = false;
  late SensorBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<SensorBloc>();
    fetchSensorInformation();
  }

  Future<void> fetchSensorInformation() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    _bloc.add(FetchSensorInformationEvent());
  }

  Future<void> _toggleFlashlight(bool value) async {
    _bloc.add(TriggeredFlashLightEvent(currentValue: value));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SensorBloc, SensorState>(
      bloc: _bloc,
      buildWhen: (prev, curr) => curr is SensorLoadedState || curr is SensorErrorState,
      listenWhen: (prev, curr) => true,
      listener: _onStateChangeListener,
      builder: (context, state) => _buildState(context, state),
    );
  }

  void _onStateChangeListener(BuildContext context, SensorState state) {
    if (state is FlashLightLoadedState) {
      _flashlightOn = !state.newValue;
      setState(() {});
    }
  }

  Widget _gyroTile(String axis, String value) {
    return Row(
      children: [
        Text("$axis-axis:", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(width: 8),
        Text(value, style: const TextStyle(fontSize: 16, color: Colors.black54)),
      ],
    );
  }

  Widget _buildState(BuildContext context, SensorState state) {
    if (state is SensorLoadedState) {
      final gyroScopeModel = state.gyroScopeModel;

      return Scaffold(
        appBar: AppBar(
          title: const Text("Sensor Info"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Flashlight", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Switch.adaptive(
                        value: _flashlightOn,
                        onChanged: (value) => _toggleFlashlight(value),
                        activeColor: Colors.blueAccent,
                      ),
                      Text(
                        _flashlightOn ? "ON" : "OFF",
                        style: TextStyle(color: _flashlightOn ? Colors.green : Colors.grey),
                      )
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Gyroscope", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            tooltip: "Refresh Gyroscope",
                            onPressed: fetchSensorInformation,
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      _gyroTile("X", gyroScopeModel.gyroX),
                      const SizedBox(height: 8),
                      _gyroTile("Y", gyroScopeModel.gyroY),
                      const SizedBox(height: 8),
                      _gyroTile("Z", gyroScopeModel.gyroZ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    else if (state is SensorErrorState) {
      return Scaffold(
        appBar: AppBar(title: const Text("Sensor Info"), centerTitle: true),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(state.errorMessage, style: const TextStyle(fontSize: 16, color: Colors.red)),
            ],
          ),
        ),
      );
    }
    else {
      return Scaffold(
        appBar: AppBar(title: const Text("Sensor Info"), centerTitle: true),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 300,
                width: 500,
                child: Lottie.asset(
                  'assets/lottie/scanner.json',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              const Text("Scanning information...", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      );
    }
  }
}
