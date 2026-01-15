part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileLoaded extends ProfileState {
  final Profile profile;
  final User? user;
  const ProfileLoaded(this.profile, {this.user});

  @override
  List<Object?> get props => [profile, user];
}

class ProfileFailure extends ProfileState {
  final String message;
  final dynamic error;
  const ProfileFailure(this.message, this.error);

  @override
  List<Object?> get props => [message, error];
}
