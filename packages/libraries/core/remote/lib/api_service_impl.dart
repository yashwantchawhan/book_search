import 'dart:async';

import 'package:dio/dio.dart';
import 'package:remote/api_service.dart';

class ApiServiceImpl extends ApiService {
  final Dio dio;

  ApiServiceImpl({
    required this.dio,
  });

  @override
  Future get(String url,
      {String? baseUrl,
      Map<String, dynamic>? queryParameters = const {}}) async {
      final apiUrl = '${baseUrl ?? ""}$url';
    try {
      final response = await dio.get(
        apiUrl,
        queryParameters: queryParameters,
      );
      return response;
    } catch (error) {
      final DioException dioException = error as DioException;
      return dioException.response;
    }
  }
}
