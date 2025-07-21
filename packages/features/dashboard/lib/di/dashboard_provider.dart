import 'package:dashboard/di/dashboard_multiple_bloc_provider.dart';
import 'package:dashboard/presentation/widgets/dashboard_screen.dart';
import 'package:flutter/material.dart';

class DashboardProvider extends StatelessWidget {
  const DashboardProvider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const DashboardMultipleBlocProvider(
      child: DashboardScreen(),
    );
  }
}
