import 'package:equatable/equatable.dart';

/// User profile entity
/// Corresponds to `profiles` table in database
class Profile extends Equatable {
  final int profileId;
  final int userId;
  final String fullName;
  final String? phone;
  final String? avatarUrl;
  final String? address;
  final DateTime? dateOfBirth;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Profile({
    required this.profileId,
    required this.userId,
    required this.fullName,
    this.phone,
    this.avatarUrl,
    this.address,
    this.dateOfBirth,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    profileId,
    userId,
    fullName,
    phone,
    avatarUrl,
    address,
    dateOfBirth,
    createdAt,
    updatedAt,
  ];
}
