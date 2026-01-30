part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

class LoginLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

class RegisterLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

class VerifyOtpLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

class LoginSuccess extends AuthState {
  final LoginResponse response;
  const LoginSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class LoginFailure extends AuthState {
  final String message;
  final dynamic error;
  const LoginFailure(this.message, this.error);

  @override
  List<Object?> get props => [message, error];
}

class RegisterSuccess extends AuthState {
  @override
  List<Object?> get props => [];
}

class RegisterFailure extends AuthState {
  final String message;
  final dynamic error;
  const RegisterFailure(this.message, this.error);

  @override
  List<Object?> get props => [message, error];
}

class VerifyOtpSuccess extends AuthState {
  @override
  List<Object?> get props => [];
}

class VerifyOtpFailure extends AuthState {
  final String message;
  final dynamic error;
  const VerifyOtpFailure(this.message, this.error);

  @override
  List<Object?> get props => [message, error];
}

class Authenticated extends AuthState {
  final User user;
  const Authenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

class LogoutSuccess extends AuthState {
  @override
  List<Object?> get props => [];
}

class ForgotPasswordLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

class ForgotPasswordSuccess extends AuthState {
  @override
  List<Object?> get props => [];
}

class ForgotPasswordFailure extends AuthState {
  final String message;
  final dynamic error;
  const ForgotPasswordFailure(this.message, this.error);

  @override
  List<Object?> get props => [message, error];
}

class ChangePasswordLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

class ChangePasswordSuccess extends AuthState {
  @override
  List<Object?> get props => [];
}

class ChangePasswordFailure extends AuthState {
  final String message;
  final dynamic error;
  const ChangePasswordFailure(this.message, this.error);

  @override
  List<Object?> get props => [message, error];
}
