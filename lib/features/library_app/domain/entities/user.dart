import 'package:equatable/equatable.dart';

/// User entity for authentication
/// Corresponds to `users` table in database
class User extends Equatable {
  final int userId;
  final String email;
  final UserStatus status;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.userId,
    required this.email,
    required this.status,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    userId,
    email,
    status,
    lastLoginAt,
    createdAt,
    updatedAt,
  ];
}

/// User account status
enum UserStatus {
  pending,
  active,
  banned;

  String get value {
    switch (this) {
      case UserStatus.pending:
        return 'PENDING';
      case UserStatus.active:
        return 'ACTIVE';
      case UserStatus.banned:
        return 'BANNED';
    }
  }

  static UserStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING':
        return UserStatus.pending;
      case 'ACTIVE':
        return UserStatus.active;
      case 'BANNED':
        return UserStatus.banned;
      default:
        throw ArgumentError('Invalid UserStatus: $value');
    }
  }
}
