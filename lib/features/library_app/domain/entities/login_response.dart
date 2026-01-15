import 'package:equatable/equatable.dart';
import 'user.dart';

class LoginResponse extends Equatable {
  final String accessToken;
  final String? refreshToken;
  final User user;

  const LoginResponse({
    required this.accessToken,
    this.refreshToken,
    required this.user,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, user];
}
