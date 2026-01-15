import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/error_handler.dart';
import '../../../domain/entities/profile.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/auth_usecase.dart';
import '../../../domain/usecases/profile_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserDataUseCase getUserDataUseCase;
  final GetProfileUsecase getProfileUsecase;
  final UpdateProfileUsecase updateProfileUsecase;

  ProfileBloc({
    required this.getUserDataUseCase,
    required this.getProfileUsecase,
    required this.updateProfileUsecase,
  }) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<RefreshProfileEvent>(_onRefreshProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<ResetProfileEvent>(_onResetProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is! ProfileLoaded) {
      emit(ProfileLoading());
    }
    try {
      final profile = await getProfileUsecase();
      final user = await getUserDataUseCase();
      emit(ProfileLoaded(profile, user: user));
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(ProfileFailure(error, e));
    } catch (e) {
      emit(ProfileFailure('Không thể tải thông tin cá nhân', e));
    }
  }

  Future<void> _onRefreshProfile(
    RefreshProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final profile = await getProfileUsecase();
      final user = await getUserDataUseCase();
      emit(ProfileLoaded(profile, user: user));
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(ProfileFailure(error, e));
    } catch (e) {
      emit(ProfileFailure('Không thể tải thông tin cá nhân', e));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final updatedProfile = await updateProfileUsecase(event.profile);
      final user = await getUserDataUseCase();
      emit(ProfileLoaded(updatedProfile, user: user));
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(ProfileFailure(error, e));
    } catch (e) {
      emit(ProfileFailure('Không thể cập nhật thông tin cá nhân', e));
    }
  }

  Future<void> _onResetProfile(
    ResetProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileInitial());
  }
}
