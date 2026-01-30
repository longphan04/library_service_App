import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/library_app/data/datasources/local/auth_local_datasource.dart';
import '../../features/library_app/data/datasources/remote/auth_remote_datasource.dart';
import '../../features/library_app/data/datasources/remote/book_remote_datasource.dart';
import '../../features/library_app/data/datasources/remote/borrow_remote_datasource.dart';
import '../../features/library_app/data/datasources/remote/category_remote_datasource.dart';
import '../../features/library_app/data/datasources/remote/message_remote_datasource.dart';
import '../../features/library_app/data/datasources/remote/profile_remote_datasource.dart';
import '../../features/library_app/data/repositories/auth_repository_impl.dart';
import '../../features/library_app/data/repositories/book_repository_impl.dart';
import '../../features/library_app/data/repositories/borrow_repository_impl.dart';
import '../../features/library_app/data/repositories/category_repository_impl.dart';
import '../../features/library_app/data/repositories/message_repository_impl.dart';
import '../../features/library_app/data/repositories/profile_repository_impl.dart';
import '../../features/library_app/domain/repositories/auth_repository.dart';
import '../../features/library_app/domain/repositories/book_repository.dart';
import '../../features/library_app/domain/repositories/borrow_repository.dart';
import '../../features/library_app/domain/repositories/category_repository.dart';
import '../../features/library_app/domain/repositories/message_repository.dart';
import '../../features/library_app/domain/repositories/profile_repository.dart';
import '../../features/library_app/domain/usecases/auth_usecase.dart';
import '../../features/library_app/domain/usecases/book_usecase.dart';
import '../../features/library_app/domain/usecases/borrow_ticket_usecase.dart';
import '../../features/library_app/domain/usecases/borrow_usecase.dart';
import '../../features/library_app/domain/usecases/category_usecase.dart';
import '../../features/library_app/domain/usecases/message_usecase.dart';
import '../../features/library_app/domain/usecases/profile_usecase.dart';
import '../../features/library_app/presentation/bloc/message/ai_chat_bloc.dart';
import '../../features/library_app/presentation/bloc/auth/auth_bloc.dart';
import '../../features/library_app/presentation/bloc/book/book_bloc.dart';
import '../../features/library_app/presentation/bloc/book/search_bloc.dart';
import '../../features/library_app/presentation/bloc/borrow/borrow_bloc.dart';
import '../../features/library_app/presentation/bloc/borrow/borrow_ticket_bloc.dart';
import '../../features/library_app/presentation/bloc/category/category_bloc.dart';
import '../../features/library_app/presentation/bloc/home/home_bloc.dart';
import '../../features/library_app/presentation/bloc/message/notification_bloc.dart';
import '../../features/library_app/presentation/bloc/profile/profile_bloc.dart';
import '../config/dio_config.dart';
import '../network/auth_interceptor.dart';
import '../network/network_info.dart';
import '../network/network_info_impl.dart';
import '../services/data_refresh_service.dart';

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
  final aiDio = AIDioConfig.createDio(); // Separate Dio for AI API
  final connectivity = Connectivity();

  // Register dependencies
  getIt.registerSingleton<FlutterSecureStorage>(secureStorage);
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<CookieJar>(cookieJar);
  getIt.registerSingleton(dio);
  getIt.registerSingleton<Dio>(aiDio, instanceName: 'aiDio');

  // Network Info
  getIt.registerSingleton<INetworkInfo>(NetworkInfoImpl(connectivity));

  // Data Refresh Service (singleton for real-time updates)
  getIt.registerSingleton<DataRefreshService>(DataRefreshService());

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
  getIt.registerSingleton<BookRemoteDatasource>(
    BookRemoteDatasourceImpl(dio: getIt<Dio>()),
  );
  getIt.registerSingleton<BorrowRemoteDatasource>(
    BorrowRemoteDatasourceImpl(dio: getIt<Dio>()),
  );
  getIt.registerSingleton<MessageRemoteDataSource>(
    MessageRemoteDataSourceImpl(
      dio: getIt<Dio>(),
      aiDio: getIt<Dio>(instanceName: 'aiDio'),
    ),
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
  getIt.registerSingleton<BookRepository>(
    BookRepositoryImpl(remoteDataSource: getIt<BookRemoteDatasource>()),
  );
  getIt.registerSingleton<BorrowRepository>(
    BorrowRepositoryImpl(remoteDatasource: getIt<BorrowRemoteDatasource>()),
  );
  getIt.registerSingleton<MessageRepository>(
    MessageRepositoryImpl(remoteDataSource: getIt<MessageRemoteDataSource>()),
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
  getIt.registerSingleton<VerifyOtpUseCase>(
    VerifyOtpUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<IsLoggedInUseCase>(
    IsLoggedInUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<GetUserDataUseCase>(
    GetUserDataUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<ForgotPasswordUseCase>(
    ForgotPasswordUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<ChangePasswordUseCase>(
    ChangePasswordUseCase(getIt<AuthRepository>()),
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
  getIt.registerSingleton<GetPopularCategoriesUseCase>(
    GetPopularCategoriesUseCase(getIt<CategoryRepository>()),
  );

  // UseCases/book
  getIt.registerSingleton<GetBookDetailsUseCase>(
    GetBookDetailsUseCase(getIt<BookRepository>()),
  );
  getIt.registerSingleton<GetAllBooksUseCase>(
    GetAllBooksUseCase(getIt<BookRepository>()),
  );
  getIt.registerSingleton<SearchBooksUseCase>(
    SearchBooksUseCase(getIt<BookRepository>()),
  );
  getIt.registerSingleton<GetRecommendedBooksUseCase>(
    GetRecommendedBooksUseCase(getIt<BookRepository>()),
  );
  getIt.registerSingleton<GetBooksByIdUseCase>(
    GetBooksByIdUseCase(getIt<BookRepository>()),
  );

  // UseCases/borrow
  getIt.registerSingleton<GetBookHoldsUseCase>(
    GetBookHoldsUseCase(getIt<BorrowRepository>()),
  );
  getIt.registerSingleton<AddBookHoldUseCase>(
    AddBookHoldUseCase(getIt<BorrowRepository>()),
  );
  getIt.registerSingleton<RemoveBookHoldUseCase>(
    RemoveBookHoldUseCase(getIt<BorrowRepository>()),
  );
  getIt.registerSingleton<BorrowNowUseCase>(
    BorrowNowUseCase(getIt<BorrowRepository>()),
  );
  getIt.registerSingleton<BorrowFromHoldsUseCase>(
    BorrowFromHoldsUseCase(getIt<BorrowRepository>()),
  );

  // UseCases/borrow_ticket
  getIt.registerSingleton<GetBorrowTicketsUseCase>(
    GetBorrowTicketsUseCase(getIt<BorrowRepository>()),
  );
  getIt.registerSingleton<GetBorrowTicketDetailUseCase>(
    GetBorrowTicketDetailUseCase(getIt<BorrowRepository>()),
  );
  getIt.registerSingleton<CancelBorrowTicketUseCase>(
    CancelBorrowTicketUseCase(getIt<BorrowRepository>()),
  );
  getIt.registerSingleton<RenewBorrowTicketUseCase>(
    RenewBorrowTicketUseCase(getIt<BorrowRepository>()),
  );

  // UseCases/message
  getIt.registerSingleton<GetNotificationsUseCase>(
    GetNotificationsUseCase(getIt<MessageRepository>()),
  );
  getIt.registerSingleton<GetUnreadCountUseCase>(
    GetUnreadCountUseCase(getIt<MessageRepository>()),
  );
  getIt.registerSingleton<MarkAllAsReadUseCase>(
    MarkAllAsReadUseCase(getIt<MessageRepository>()),
  );
  getIt.registerSingleton<SendAIChatMessageUseCase>(
    SendAIChatMessageUseCase(getIt<MessageRepository>()),
  );
  getIt.registerSingleton<ClearAIChatHistoryUseCase>(
    ClearAIChatHistoryUseCase(getIt<MessageRepository>()),
  );

  // Blocs
  getIt.registerSingleton<AuthBloc>(
    AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      verifyOtpUseCase: getIt<VerifyOtpUseCase>(),
      isLoggedInUseCase: getIt<IsLoggedInUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      getUserDataUseCase: getIt<GetUserDataUseCase>(),
      forgotPasswordUseCase: getIt<ForgotPasswordUseCase>(),
      changePasswordUseCase: getIt<ChangePasswordUseCase>(),
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
  // Factory để tạo instance mới mỗi lần (tránh "Cannot add new events after calling close")
  getIt.registerFactory<BookAIBloc>(
    () => BookAIBloc(getIt<GetBooksByIdUseCase>()),
  );
  getIt.registerSingleton<BookBloc>(BookBloc(getIt<GetAllBooksUseCase>()));
  getIt.registerSingleton<BookDetailBloc>(
    BookDetailBloc(getIt<GetBookDetailsUseCase>()),
  );
  getIt.registerSingleton<HomeBloc>(
    HomeBloc(
      getIt<GetAllBooksUseCase>(),
      getIt<GetPopularCategoriesUseCase>(),
      getIt<GetRecommendedBooksUseCase>(),
    ),
  );
  getIt.registerSingleton<SearchBloc>(SearchBloc(getIt<SearchBooksUseCase>()));
  getIt.registerSingleton<BorrowBloc>(
    BorrowBloc(
      getIt<GetBookHoldsUseCase>(),
      getIt<AddBookHoldUseCase>(),
      getIt<RemoveBookHoldUseCase>(),
      getIt<BorrowNowUseCase>(),
      getIt<BorrowFromHoldsUseCase>(),
    ),
  );
  getIt.registerSingleton<BorrowTicketListBloc>(
    BorrowTicketListBloc(getIt<GetBorrowTicketsUseCase>()),
  );
  getIt.registerSingleton<BorrowTicketBloc>(
    BorrowTicketBloc(getIt<GetBorrowTicketDetailUseCase>()),
  );
  getIt.registerSingleton<BorrowTicketActionBloc>(
    BorrowTicketActionBloc(
      getIt<CancelBorrowTicketUseCase>(),
      getIt<RenewBorrowTicketUseCase>(),
    ),
  );
  getIt.registerSingleton<NotificationBloc>(
    NotificationBloc(
      getNotificationsUseCase: getIt<GetNotificationsUseCase>(),
      getUnreadCountUseCase: getIt<GetUnreadCountUseCase>(),
      markAllAsReadUseCase: getIt<MarkAllAsReadUseCase>(),
    ),
  );
  getIt.registerSingleton<AIChatBloc>(
    AIChatBloc(
      sendAIChatMessageUseCase: getIt<SendAIChatMessageUseCase>(),
      clearAIChatHistoryUseCase: getIt<ClearAIChatHistoryUseCase>(),
    ),
  );
}
