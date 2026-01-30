import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class DioConfig {
  static const String baseUrl =
      'https://surplus-comparison-aerospace-jpg.trycloudflare.com';
  static Dio createDio({CookieJar? cookieJar}) {
    final jar = cookieJar ?? CookieJar();

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
        contentType: 'application/json',
        validateStatus: (status) =>
            status != null && status >= 200 && status < 300,
      ),
    );

    dio.interceptors.add(CookieManager(jar));

    return dio;
  }
}

class AIDioConfig {
  static const String baseUrl =
      'https://unpractised-unmilitant-cherly.ngrok-free.dev';

  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
        validateStatus: (status) =>
            status != null && status >= 200 && status < 300,
      ),
    );

    return dio;
  }
}
