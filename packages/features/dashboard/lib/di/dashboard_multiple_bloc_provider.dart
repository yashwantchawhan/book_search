import 'package:dashboard/data/get_device_details_repository_impl.dart';
import 'package:dashboard/data/get_sensor_information_repository_impl.dart';
import 'package:dashboard/domain/flash_light_usecase_impl.dart';
import 'package:dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:dashboard/presentation/bloc/sensor_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardMultipleBlocProvider extends StatelessWidget {
  final Widget child;

  const DashboardMultipleBlocProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => DashboardBloc(GetDeviceDetailsRepositoryImpl(
            platformService: context.read(),
          )),
        ),
        Provider<SensorBloc>(
          create: (context) => SensorBloc(
              GetSensorInformationRepositoryImpl(
                platformService: context.read(),
              ),
              FlashLightUseCaseImpl()),
        ),
      ],
      builder: (context, _) => child,
    );
  }
}
