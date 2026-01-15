import '../entities/login_request.dart';
import '../entities/login_response.dart';
import '../entities/register_request.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(LoginRequest request);
  Future<void> register(RegisterRequest request);
  Future<void> forgotPassword(String email);
  Future<void> logout();
  Future<String?> getAccessToken();
  Future<bool> isLoggedIn();
  Future<User> getUserData();
}
