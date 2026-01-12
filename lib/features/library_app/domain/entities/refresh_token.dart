import 'package:equatable/equatable.dart';

/// Refresh token entity for JWT token refresh
/// Corresponds to `refresh_tokens` table in database
class RefreshToken extends Equatable {
  final int rtId;
  final int userId;
  final String tokenHash;
  final DateTime expiresAt;
  final DateTime? revokedAt;
  final String? userAgent;
  final String? ipAddress;
  final DateTime createdAt;

  const RefreshToken({
    required this.rtId,
    required this.userId,
    required this.tokenHash,
    required this.expiresAt,
    this.revokedAt,
    this.userAgent,
    this.ipAddress,
    required this.createdAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isRevoked => revokedAt != null;
  bool get isValid => !isExpired && !isRevoked;

  @override
  List<Object?> get props => [
    rtId,
    userId,
    tokenHash,
    expiresAt,
    revokedAt,
    userAgent,
    ipAddress,
    createdAt,
  ];
}
