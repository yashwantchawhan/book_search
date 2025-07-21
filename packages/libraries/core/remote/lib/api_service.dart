
abstract class ApiService {
  Future<dynamic> get(
      String url, {
        String? baseUrl,
        Map<String, dynamic>? queryParameters = const {},
      });
}
