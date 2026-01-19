import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class DioConfig {
  static const String baseUrl = 'http://10.0.5.101:3000'; // Api
  static Dio createDio({CookieJar? cookieJar}) {
    final jar = cookieJar ?? CookieJar();

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl, // Api base URL
        connectTimeout: Duration(seconds: 10), // Connection timeout
        receiveTimeout: Duration(seconds: 10), // Receive timeout
        contentType: 'application/json', // Content type
        validateStatus: (status) =>
            status != null && status >= 200 && status < 300, // Only 2xx success
      ),
    );

    dio.interceptors.add(CookieManager(jar));

    return dio;
  }
}
