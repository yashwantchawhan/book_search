import 'package:get_it/get_it.dart';
import 'package:remote/api_service.dart';
import 'package:remote/api_service_impl.dart';
void setupApiService(GetIt getIt) {
  if (!getIt.isRegistered<ApiService>()) {
    getIt.registerLazySingleton<ApiService>(
          () =>
          ApiServiceImpl(
            dio: getIt(),
          ),
    );
  }
}