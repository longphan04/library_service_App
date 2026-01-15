import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/library_app/data/datasources/local/auth_local_datasource.dart';
import '../../features/library_app/data/datasources/remote/auth_remote_datasource.dart';
import '../../features/library_app/data/datasources/remote/category_remote_datasource.dart';
import '../../features/library_app/data/datasources/remote/profile_remote_datasource.dart';
import '../../features/library_app/data/repositories/auth_repository_impl.dart';
import '../../features/library_app/data/repositories/category_repository_impl.dart';
import '../../features/library_app/data/repositories/profile_repository_impl.dart';
import '../../features/library_app/domain/repositories/auth_repository.dart';
import '../../features/library_app/domain/repositories/category_repository.dart';
import '../../features/library_app/domain/repositories/profile_repository.dart';
import '../../features/library_app/domain/usecases/auth_usecase.dart';
import '../../features/library_app/domain/usecases/category_usecase.dart';
import '../../features/library_app/domain/usecases/profile_usecase.dart';
import '../../features/library_app/presentation/bloc/auth/auth_bloc.dart';
import '../../features/library_app/presentation/bloc/category/category_bloc.dart';
import '../../features/library_app/presentation/bloc/profile/profile_bloc.dart';
import '../config/dio_config.dart';
import '../network/auth_interceptor.dart';
import '../network/network_info.dart';
import '../network/network_info_impl.dart';

// Service locator / Dependency injection container
final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // Core dependencies
  const secureStorage = FlutterSecureStorage();
  final sharedPreferences = await SharedPreferences.getInstance();
  final appDocDir = await getApplicationDocumentsDirectory();
  final cookieJar = PersistCookieJar(
    storage: FileStorage('${appDocDir.path}/.cookies/'),
  );
  final dio = DioConfig.createDio(cookieJar: cookieJar);
  final connectivity = Connectivity();

  // Register dependencies
  getIt.registerSingleton<FlutterSecureStorage>(secureStorage);
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<CookieJar>(cookieJar);
  getIt.registerSingleton(dio);

  // Network Info
  getIt.registerSingleton<INetworkInfo>(NetworkInfoImpl(connectivity));

  // Datasources/remote
  getIt.registerSingleton<AuthRemoteDatasource>(
    AuthRemoteDatasourceImpl(dio: getIt<Dio>()),
  );
  getIt.registerSingleton<ProfileRemoteDatasource>(
    ProfileRemoteDatasourceImpl(dio: getIt<Dio>()),
  );
  getIt.registerSingleton<CategoryRemoteDataSource>(
    CategoryRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  // Datasources/local
  getIt.registerSingleton<AuthLocalDatasource>(
    AuthLocalDatasourceImpl(
      secureStorage: getIt<FlutterSecureStorage>(),
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );

  // Repositories
  getIt.registerSingleton<ProfileRepository>(
    ProfileRepositoryImpl(
      remoteDatasource: getIt<ProfileRemoteDatasource>(),
      localDatasource: getIt<AuthLocalDatasource>(),
    ),
  );
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      remoteDatasource: getIt<AuthRemoteDatasource>(),
      localDatasource: getIt<AuthLocalDatasource>(),
    ),
  );
  getIt.registerSingleton<CategoryRepository>(
    CategoryRepositoryImpl(remoteDataSource: getIt<CategoryRemoteDataSource>()),
  );

  // Dio Interceptor
  dio.interceptors.add(
    AuthInterceptor(
      dio: dio,
      localDataSource: getIt<AuthLocalDatasource>(),
      cookieJar: getIt<CookieJar>(),
      baseUrl: DioConfig.baseUrl,
    ),
  );

  // UseCases/auth
  getIt.registerSingleton<LoginUseCase>(LoginUseCase(getIt<AuthRepository>()));
  getIt.registerSingleton<RegisterUseCase>(
    RegisterUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<GetAccessTokenUseCase>(
    GetAccessTokenUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<LogoutUseCase>(
    LogoutUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<IsLoggedInUseCase>(
    IsLoggedInUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<GetUserDataUseCase>(
    GetUserDataUseCase(getIt<AuthRepository>()),
  );

  // UseCases/profile
  getIt.registerSingleton<GetProfileUsecase>(
    GetProfileUsecase(getIt<ProfileRepository>()),
  );
  getIt.registerSingleton<UpdateProfileUsecase>(
    UpdateProfileUsecase(getIt<ProfileRepository>()),
  );

  // UseCases/category
  getIt.registerSingleton<GetCategoriesUseCase>(
    GetCategoriesUseCase(getIt<CategoryRepository>()),
  );

  // Blocs
  getIt.registerSingleton<AuthBloc>(
    AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      isLoggedInUseCase: getIt<IsLoggedInUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      getUserDataUseCase: getIt<GetUserDataUseCase>(),
    ),
  );
  getIt.registerSingleton<ProfileBloc>(
    ProfileBloc(
      getUserDataUseCase: getIt<GetUserDataUseCase>(),
      getProfileUsecase: getIt<GetProfileUsecase>(),
      updateProfileUsecase: getIt<UpdateProfileUsecase>(),
    ),
  );
  getIt.registerSingleton<CategoryBloc>(
    CategoryBloc(getCategoriesUseCase: getIt<GetCategoriesUseCase>()),
  );
}
