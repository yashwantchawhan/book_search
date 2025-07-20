import 'package:dio/dio.dart';

abstract class ApiService {
  Future<dynamic> get(
      String url, {
        String? baseUrl,
        Map<String, dynamic>? queryParameters = const {},
      });
}
