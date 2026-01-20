import 'dart:async';
import 'dart:developer' as dev;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:get_it/get_it.dart';

import '../../features/library_app/data/datasources/local/auth_local_datasource.dart';
import '../../features/library_app/presentation/bloc/auth/auth_bloc.dart';

/// Interceptor to attach access token and auto-refresh on 401.
class AuthInterceptor extends QueuedInterceptorsWrapper {
  final Dio dio;
  final AuthLocalDatasource localDataSource;
  final CookieJar cookieJar;
  final String baseUrl;

  AuthInterceptor({
    required this.dio,
    required this.localDataSource,
    required this.cookieJar,
    required this.baseUrl,
  });

  Dio? _refreshDio;
  Future<String?>? _refreshing;

  void _log(String message) {
    dev.log('[AuthInterceptor] $message', name: 'AUTH');
  }

  Dio get _tokenDio {
    _refreshDio ??= Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        contentType: 'application/json',
        validateStatus: (status) => status != null,
      ),
    )..interceptors.add(CookieManager(cookieJar));
    return _refreshDio!;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final requiresAuth = options.extra['requiresAuth'] as bool? ?? true;
    if (!requiresAuth) {
      _log('Request [${options.method}] ${options.path} - No auth required');
      return super.onRequest(options, handler);
    }

    final token = await localDataSource.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      _log(
        'Request [${options.method}] ${options.path} - Token attached (${token.substring(0, 20)}...)',
      );
    } else {
      _log(
        'Request [${options.method}] ${options.path} - WARNING: No token available!',
      );
    }

    return super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    _log(
      'Response [${response.requestOptions.method}] ${response.requestOptions.path} - Status: ${response.statusCode}',
    );
    if (response.statusCode != null && response.statusCode! >= 400) {
      _log('  Response data: ${response.data}');
    }
    return super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final options = err.requestOptions;
    final hasRetried = options.extra['retried'] == true;
    final skipRefresh = options.extra['skipRefresh'] == true;
    final isRefreshCall = options.path.contains('/auth/refresh');

    _log('Error [${options.method}] ${options.path} - Status: $statusCode');
    _log('  Error type: ${err.type}');
    _log('  Error message: ${err.message}');
    _log(
      '  hasRetried: $hasRetried, skipRefresh: $skipRefresh, isRefreshCall: $isRefreshCall',
    );

    if (err.response?.data != null) {
      _log('  Response data: ${err.response?.data}');
    } else if (err.error != null) {
      _log('  Error detail: ${err.error}');
    }

    if (statusCode == 403) {
      final responseData = err.response?.data;
      if (responseData is Map<String, dynamic>) {
        final message = responseData['message'] as String?;
        if (message?.contains('khóa') == true) {
          _log('  => Account locked detected!');

          // Kiểm tra xem có token không (user đang logged in)
          final hasToken = await localDataSource.getAccessToken();
          final isLoggedIn = hasToken != null && hasToken.isNotEmpty;

          await localDataSource.clearTokens();
          _log('  => Tokens cleared.');

          if (isLoggedIn) {
            _log('  => User was logged in. Triggering logout event...');
            try {
              final authBloc = GetIt.instance<AuthBloc>();
              authBloc.add(const LogoutEvent());
              _log('  => LogoutEvent emitted successfully.');
            } catch (e) {
              _log('  => ERROR emitting LogoutEvent: $e');
            }
          } else {
            _log('  => User not logged in. Showing error to user.');
          }

          return super.onError(err, handler);
        }
      }
    }

    final shouldRefresh =
        statusCode == 401 && !hasRetried && !skipRefresh && !isRefreshCall;

    if (!shouldRefresh) {
      _log('  => Not refreshing token (shouldRefresh: false)');
      return super.onError(err, handler);
    }

    _log('  => Token expired! Starting refresh...');

    try {
      final newToken = await _getNewAccessToken();
      if (newToken != null && newToken.isNotEmpty) {
        _log(
          '  => Refresh SUCCESS! New token: ${newToken.substring(0, 20)}...',
        );
        await localDataSource.saveAccessToken(newToken);
        options
          ..headers['Authorization'] = 'Bearer $newToken'
          ..extra['retried'] = true;

        _log('  => Retrying original request...');
        final retryResponse = await dio.fetch(options);
        _log('  => Retry SUCCESS! Status: ${retryResponse.statusCode}');
        return handler.resolve(retryResponse);
      } else {
        _log('  => Refresh FAILED: newToken is null or empty');
      }
    } catch (e) {
      _log('  => Refresh ERROR: $e');
      await localDataSource.clearTokens();
      _log('  => Tokens cleared from local storage');
    }

    return super.onError(err, handler);
  }

  Future<String?> _getNewAccessToken() async {
    if (_refreshing != null) {
      _log('  => Refresh already in progress, waiting...');
      return _refreshing!;
    }

    _refreshing = _performRefresh();
    try {
      return await _refreshing!;
    } finally {
      _refreshing = null;
    }
  }

  Future<String?> _performRefresh() async {
    _log('  => Calling POST /auth/refresh...');

    // Log cookies before refresh
    final uri = Uri.parse('$baseUrl/auth/refresh');
    final cookies = await cookieJar.loadForRequest(uri);
    _log(
      '  => Cookies for refresh: ${cookies.map((c) => '${c.name}=${c.value.substring(0, 10)}...').join(', ')}',
    );

    final response = await _tokenDio.post(
      '/auth/refresh',
      options: Options(
        extra: const {'requiresAuth': false, 'skipRefresh': true},
      ),
    );

    _log('  => Refresh response status: ${response.statusCode}');
    _log('  => Refresh response data: ${response.data}');

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final newAccessToken = data['accessToken'] as String?;
      if (newAccessToken != null) {
        _log('  => Got new accessToken from response');
        return newAccessToken;
      } else {
        _log('  => ERROR: accessToken not found in response');
      }
    } else {
      _log('  => ERROR: Response data is not a Map');
    }

    return null;
  }
}
