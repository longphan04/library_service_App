import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated || state is LogoutSuccess) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final String? userRole = state is Authenticated
              ? state.user.roles.isNotEmpty
                    ? state.user.roles.first
                    : null
              : null;
          final isAdmin = userRole == 'ADMIN';

          if (!isAdmin) {
            return Scaffold(
              appBar: AppBar(title: const Text('Admin Page')),
              body: const Center(
                child: Text('Bạn không có quyền truy cập trang này.'),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Admin Page'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutEvent());
                  },
                ),
              ],
            ),
            body: const Center(child: Text('Welcome to the Admin Page!')),
          );
        },
      ),
    );
  }
}
