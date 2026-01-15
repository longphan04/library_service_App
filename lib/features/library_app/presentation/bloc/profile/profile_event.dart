part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class GetProfileEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class RefreshProfileEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class UpdateProfileEvent extends ProfileEvent {
  final Profile profile;

  const UpdateProfileEvent(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ResetProfileEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}
