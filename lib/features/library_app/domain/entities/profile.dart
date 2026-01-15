import 'dart:io';

import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final int profileId;
  final int userId;
  final String fullName;
  final String? phone;
  final File? image;
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
    this.image,
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
    image,
    avatarUrl,
    address,
    dateOfBirth,
    createdAt,
    updatedAt,
  ];
}
