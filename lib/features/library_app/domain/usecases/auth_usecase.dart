import '../entities/login_request.dart';
import '../entities/login_response.dart';
import '../entities/register_request.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<LoginResponse> call(LoginRequest request) async {
    return await repository.login(request);
  }
}

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<void> call(RegisterRequest request) async {
    return await repository.register(request);
  }
}

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<void> call(String email, String otp) async {
    return await repository.verifyOtp(email, otp);
  }
}

class GetAccessTokenUseCase {
  final AuthRepository repository;

  GetAccessTokenUseCase(this.repository);

  Future<String?> call() async {
    return await repository.getAccessToken();
  }
}

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() async {
    return await repository.logout();
  }
}

class IsLoggedInUseCase {
  final AuthRepository repository;

  IsLoggedInUseCase(this.repository);

  Future<bool> call() async {
    return await repository.isLoggedIn();
  }
}

class GetUserDataUseCase {
  final AuthRepository repository;

  GetUserDataUseCase(this.repository);

  Future<User> call() async {
    return await repository.getUserData();
  }
}

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<void> call(String email) async {
    return await repository.forgotPassword(email);
  }
}

class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<String> call(String currentPassword, String newPassword) async {
    return await repository.changePassword(currentPassword, newPassword);
  }
}
