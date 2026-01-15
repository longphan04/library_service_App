import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';

abstract class AuthLocalDatasource {
  Future<void> saveAccessToken(String token);
  Future<String?> getAccessToken();
  Future<void> clearTokens();
  Future<bool> hasTokens();
  Future<void> saveUserData(UserModel response);
  Future<UserModel?> getUserData();
  Future<void> clearUserData();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  // Keys
  static const String _accessTokenKey = 'access_token';
  static const String _userDataKey = 'user_data';

  final FlutterSecureStorage secureStorage; // Lưu token
  final SharedPreferences sharedPreferences; // Lưu user data

  AuthLocalDatasourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  @override
  Future<void> saveAccessToken(String token) async {
    await secureStorage.write(key: _accessTokenKey, value: token);
  }

  @override
  Future<String?> getAccessToken() async {
    final token = await secureStorage.read(key: _accessTokenKey);
    return token;
  }

  @override
  Future<void> clearTokens() async {
    await secureStorage.delete(key: _accessTokenKey);
  }

  @override
  Future<bool> hasTokens() async {
    final accessToken = await getAccessToken();
    final hasTokens = accessToken != null;
    return hasTokens;
  }

  @override
  Future<void> saveUserData(UserModel response) async {
    // Store as API-shaped JSON (snake_case) to keep parsing consistent.
    final jsonString = jsonEncode(response.toJson());
    await sharedPreferences.setString(_userDataKey, jsonString);
  }

  @override
  Future<UserModel?> getUserData() async {
    final jsonString = sharedPreferences.getString(_userDataKey);
    if (jsonString == null) {
      return null;
    }

    final Map<String, dynamic> raw = jsonDecode(jsonString);

    // Backward-compat: older cached format used "userId" instead of "user_id".
    raw['user_id'] ??= raw['userId'];

    // If still missing, treat as no cached user.
    if (raw['user_id'] == null) {
      return null;
    }

    // Roles could be stored as ["MEMBER"] or [{"name":"MEMBER"}] — UserModel handles both.
    return UserModel.fromJson(raw);
  }

  @override
  Future<void> clearUserData() async {
    await sharedPreferences.remove(_userDataKey);
  }
}
