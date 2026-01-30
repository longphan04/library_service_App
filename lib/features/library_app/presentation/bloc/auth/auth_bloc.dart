import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/error_handler.dart';
import '../../../domain/entities/login_request.dart';
import '../../../domain/entities/login_response.dart';
import '../../../domain/entities/register_request.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/auth_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final IsLoggedInUseCase isLoggedInUseCase;
  final LogoutUseCase logoutUseCase;
  final GetUserDataUseCase getUserDataUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ChangePasswordUseCase changePasswordUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.verifyOtpUseCase,
    required this.isLoggedInUseCase,
    required this.logoutUseCase,
    required this.getUserDataUseCase,
    required this.forgotPasswordUseCase,
    required this.changePasswordUseCase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<CheckLoginStatusEvent>(_onCheckLoginStatus);
    on<LogoutEvent>(_onLogout);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<ChangePasswordEvent>(_onChangePassword);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(LoginLoading());
    try {
      final response = await loginUseCase(
        LoginRequest(email: event.email, password: event.password),
      );
      if (response.user.roles.contains('STAFF')) {
        await logoutUseCase();
        emit(const LoginFailure('Không được phép đăng nhập.', null));
        return;
      }
      emit(Authenticated(user: response.user));
    } on DioException catch (e) {
      final message = ErrorHandler.getErrorMessage(e);
      emit(LoginFailure(message, e));
    } catch (e) {
      emit(LoginFailure('Lỗi không xác định', e));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(RegisterLoading());
    try {
      await registerUseCase(
        RegisterRequest(
          email: event.email,
          password: event.password,
          fullName: event.fullName,
        ),
      );
      emit(RegisterSuccess());
    } on DioException catch (e) {
      final message = ErrorHandler.getErrorMessage(e);
      emit(RegisterFailure(message, e));
    } catch (e) {
      emit(RegisterFailure('Lỗi không xác định', e));
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(VerifyOtpLoading());
    try {
      await verifyOtpUseCase(event.email, event.otp);
      emit(VerifyOtpSuccess());
    } on DioException catch (e) {
      final message = ErrorHandler.getErrorMessage(e);
      emit(VerifyOtpFailure(message, e));
    } catch (e) {
      emit(VerifyOtpFailure('Lỗi không xác định', e));
    }
  }

  Future<void> _onCheckLoginStatus(
    CheckLoginStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final isLoggedIn = await isLoggedInUseCase();
      if (isLoggedIn) {
        final userData = await getUserDataUseCase();
        emit(Authenticated(user: userData));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await logoutUseCase();
      emit(LogoutSuccess());
      emit(Unauthenticated());
    } catch (e) {
      emit(LoginFailure('Lỗi đăng xuất', e));
    }
  }

  Future<void> _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    try {
      await forgotPasswordUseCase(event.email);
      emit(ForgotPasswordSuccess());
    } on DioException catch (e) {
      final message = ErrorHandler.getErrorMessage(e);
      emit(ForgotPasswordFailure(message, e));
    } catch (e) {
      emit(ForgotPasswordFailure('Lỗi không xác định', e));
    }
  }

  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(ChangePasswordLoading());
    try {
      await changePasswordUseCase(event.currentPassword, event.newPassword);
      emit(ChangePasswordSuccess());
      // Re-emit Authenticated to maintain login state
      final userData = await getUserDataUseCase();
      emit(Authenticated(user: userData));
    } on DioException catch (e) {
      final message = ErrorHandler.getErrorMessage(e);
      emit(ChangePasswordFailure(message, e));
    } catch (e) {
      emit(ChangePasswordFailure('Lỗi không xác định', e));
    }
  }
}
