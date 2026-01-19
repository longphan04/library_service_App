import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/theme/app_colors.dart';
import 'features/library_app/presentation/bloc/auth/auth_bloc.dart';
import 'features/library_app/presentation/bloc/book/book_bloc.dart';
import 'features/library_app/presentation/bloc/borrow/borrow_bloc.dart';
import 'features/library_app/presentation/bloc/category/category_bloc.dart';
import 'features/library_app/presentation/bloc/profile/profile_bloc.dart';
import 'features/library_app/presentation/pages/admin/admin_page.dart';
import 'features/library_app/presentation/pages/auth/login_page.dart';
import 'features/library_app/presentation/pages/home/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) =>
              getIt<AuthBloc>()..add(const CheckLoginStatusEvent()),
        ),
        BlocProvider<ProfileBloc>(create: (context) => getIt<ProfileBloc>()),
        BlocProvider<CategoryBloc>(
          create: (context) =>
              getIt<CategoryBloc>()..add(LoadCategoriesEvent()),
        ),
        BlocProvider<BookBloc>(create: (context) => getIt<BookBloc>()),
        BlocProvider<BookDetailBloc>(
          create: (context) => getIt<BookDetailBloc>(),
        ),
        BlocProvider<BorrowBloc>(create: (context) => getIt<BorrowBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: const AuthWrapper(),
      ),
    );
  }
}

/// Wrapper widget to handle initial navigation based on auth status
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Load profile when user authenticates
        if (state is Authenticated) {
          context.read<ProfileBloc>().add(LoadProfileEvent());
        }
        // Reset profile when user logs out
        else if (state is Unauthenticated || state is LogoutSuccess) {
          context.read<ProfileBloc>().add(ResetProfileEvent());
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // Show loading while checking auth status
          if (state is AuthInitial || state is AuthLoading) {
            return const Scaffold(
              backgroundColor: AppColors.background,
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // User is authenticated, navigate based on role
          if (state is Authenticated) {
            final roles = state.user.roles;

            // Admin goes to AdminPage
            if (roles.contains('ADMIN')) {
              return const AdminPage();
            }

            // User goes to MainPage
            return const MainPage();
          }

          // Not authenticated, show login page
          return const LoginPage();
        },
      ),
    );
  }
}
