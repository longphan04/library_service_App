import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/profile_remote_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRemoteDatasource remoteDatasource;
  AuthLocalDatasource localDatasource;

  ProfileRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<Profile> getProfile() async {
    try {
      final profileModel = await remoteDatasource.getProfile();
      final user = profileModel.user;
      if (user != null) {
        await localDatasource.saveUserData(user);
      }
      return profileModel.toEntity();
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<Profile> updateProfile(Profile profile) {
    try {
      final updateRequest = UpdateProfileRequest.fromProfile(profile);
      return remoteDatasource.updateProfile(updateRequest).then((profileModel) {
        final user = profileModel.user;
        if (user != null) {
          localDatasource.saveUserData(user);
        }
        return profileModel.toEntity();
      });
    } on Exception {
      rethrow;
    }
  }
}
