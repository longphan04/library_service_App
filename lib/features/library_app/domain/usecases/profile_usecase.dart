import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class GetProfileUsecase {
  final ProfileRepository repository;

  GetProfileUsecase(this.repository);

  Future<Profile> call() {
    return repository.getProfile();
  }
}

class UpdateProfileUsecase {
  final ProfileRepository repository;

  UpdateProfileUsecase(this.repository);

  Future<Profile> call(Profile profile) {
    return repository.updateProfile(profile);
  }
}
