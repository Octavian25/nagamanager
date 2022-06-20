part of 'services.dart';

class Client {
  String token;

  Client(this.token);
  Dio init() {
    Dio _dio = Dio();
    _dio.interceptors.add(ApiInterceptors());
    _dio.options.baseUrl = "http://147.139.193.169:3133/api/v1/";
    // _dio.options.baseUrl = "http://192.168.0.14:3133/api/v1/";
    _dio.options.headers['Authorization'] = "Bearer ${token}";
    return _dio;
  }
}

class ApiInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    print("<----- DATA : ${response.data}");
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
