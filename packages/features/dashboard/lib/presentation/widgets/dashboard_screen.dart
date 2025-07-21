import 'package:dashboard/di/dashboard_multiple_bloc_provider.dart';
import 'package:dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:dashboard/presentation/bloc/dashboard_event.dart';
import 'package:dashboard/presentation/bloc/dashboard_state.dart';
import 'package:dashboard/presentation/widgets/sensor_screen.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<DashboardBloc>();
    _bloc.add(FetchDeviceInformationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      bloc: _bloc,
      buildWhen: _buildWhen,
      listenWhen: _listenWhen,
      listener: _onStateChangeListener,
      builder: (context, state) => _onStateChangeBuilder(
        context,
        state,
      ),
    );
  }


  bool _listenWhen(
      DashboardState previous,
      DashboardState current,
      ) =>
      true;
  bool _buildWhen(
      DashboardState previous,
      DashboardState current,
      ) =>
      current is DashboardLoadedState || current is DashboardErrorState;

  void _onStateChangeListener(BuildContext context, DashboardState state) {
    if(state is NavigateToSensorScreenState) {
      Navigator.of(context).pop();
    }
  }

  _onStateChangeBuilder(BuildContext context, DashboardState state) {
          if (state is DashboardLoadedState) {
            final deviceDetailsModel = state.deviceDetailsModel;
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
                          child:
                           Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InfoTile(
                                icon: Icons.battery_full,
                                label: 'Battery',
                                value: '${deviceDetailsModel.batteryLevel}%',
                              ),
                              const SizedBox(height: 12),
                              InfoTile(
                                icon: Icons.phone_android,
                                label: 'Device',
                                value: deviceDetailsModel.deviceName,
                              ),
                              const SizedBox(height: 12),
                              InfoTile(
                                icon: Icons.computer,
                                label: 'OS',
                                value: deviceDetailsModel.osName,
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
                              builder: (_) => const DashboardMultipleBlocProvider(
                                child: SensorScreen(),
                              ),
                            ),
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
          } else if (state is DashboardErrorState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  state.errorMessage,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            );
          } else {
            return Column(
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
            );
          }
  }
}




