import 'package:equatable/equatable.dart';

/// Auth token entity for email verification and password reset
/// Corresponds to `auth_tokens` table in database
class AuthToken extends Equatable {
  final int tokenId;
  final int userId;
  final TokenPurpose purpose;
  final String tokenHash;
  final DateTime expiresAt;
  final DateTime? usedAt;
  final DateTime createdAt;

  const AuthToken({
    required this.tokenId,
    required this.userId,
    required this.purpose,
    required this.tokenHash,
    required this.expiresAt,
    this.usedAt,
    required this.createdAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isUsed => usedAt != null;
  bool get isValid => !isExpired && !isUsed;

  @override
  List<Object?> get props => [
    tokenId,
    userId,
    purpose,
    tokenHash,
    expiresAt,
    usedAt,
    createdAt,
  ];
}

/// Token purpose types
enum TokenPurpose {
  verifyEmail,
  resetPassword;

  String get value {
    switch (this) {
      case TokenPurpose.verifyEmail:
        return 'VERIFY_EMAIL';
      case TokenPurpose.resetPassword:
        return 'RESET_PASSWORD';
    }
  }

  static TokenPurpose fromString(String value) {
    switch (value.toUpperCase()) {
      case 'VERIFY_EMAIL':
        return TokenPurpose.verifyEmail;
      case 'RESET_PASSWORD':
        return TokenPurpose.resetPassword;
      default:
        throw ArgumentError('Invalid TokenPurpose: $value');
    }
  }
}
