part of 'services.dart';

class Client {
  String token;

  Client(this.token);
  Dio init() {
    Dio _dio = Dio();
    if (!kIsWeb) {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
    _dio.interceptors.add(ApiInterceptors());
    _dio.options.baseUrl = "http://localhost:3133/api/v1/";
    // _dio.options.baseUrl = const String.fromEnvironment("URL");
    _dio.options.headers['Authorization'] = "Bearer $token";
    _dio.options.headers['enc'] = "1";
    _dio.options.headers['ignore'] = "[]";
    return _dio;
  }
}

class ApiInterceptors extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    await Sentry.captureMessage(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
        level: SentryLevel.debug,
        hint: "ERROR DIO");
    return super.onError(err, handler);
  }
}
