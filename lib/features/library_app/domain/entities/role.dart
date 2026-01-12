import 'package:equatable/equatable.dart';

/// Role entity for RBAC
/// Corresponds to `roles` table in database
class Role extends Equatable {
  final int roleId;
  final RoleType name;
  final String? description;
  final DateTime createdAt;

  const Role({
    required this.roleId,
    required this.name,
    this.description,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [roleId, name, description, createdAt];
}

/// Role types in the system
enum RoleType {
  admin,
  staff,
  member;

  String get value {
    switch (this) {
      case RoleType.admin:
        return 'ADMIN';
      case RoleType.staff:
        return 'STAFF';
      case RoleType.member:
        return 'MEMBER';
    }
  }

  static RoleType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'ADMIN':
        return RoleType.admin;
      case 'STAFF':
        return RoleType.staff;
      case 'MEMBER':
        return RoleType.member;
      default:
        throw ArgumentError('Invalid RoleType: $value');
    }
  }
}
