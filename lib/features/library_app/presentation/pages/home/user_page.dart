import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../widgets/navigation_item.dart';
import '../borrow/borrow_history_page.dart';
import '../profile/profile_page.dart';
import 'blank_page.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _UserPageContent();
  }
}

class _UserPageContent extends StatelessWidget {
  const _UserPageContent();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated || state is LogoutSuccess) {
          // Navigate to login when user logs out
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<ProfileBloc>().add(RefreshProfileEvent());
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cá nhân',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleText,
                  ),
                ),
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, profileState) {
                    return BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, authState) {
                        String displayName = 'Guest';
                        String displayEmail = 'Chưa đăng nhập';
                        String? avatarUrl;

                        if (profileState is ProfileLoaded) {
                          displayName = profileState.profile.fullName;
                          displayEmail = profileState.user?.email ?? '';
                          avatarUrl = profileState.profile.avatarUrl;
                        } else if (profileState is ProfileLoading) {
                          displayName = 'Đang tải...';
                          displayEmail = '';
                        } else if (profileState is ProfileFailure) {
                          displayName = 'Lỗi tải dữ liệu';
                          displayEmail = '';
                        }

                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 20.0),
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            bottom: 20.0,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.sectionBackground,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[300],
                                backgroundImage: avatarUrl != null
                                    ? NetworkImage(avatarUrl)
                                    : null,
                                child: avatarUrl == null
                                    ? Icon(
                                        Icons.person,
                                        size: 60,
                                        color: AppColors.icon,
                                      )
                                    : null,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                displayName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.titleText,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                displayEmail,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.subText,
                                ),
                              ),
                              if (profileState is ProfileFailure)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    profileState.message,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Thư viện của tôi',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleText,
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: AppColors.sectionBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NavigationItem(
                        icon: Icons.history,
                        title: 'Lịch sử mượn sách',
                        page: BorrowHistoryPage(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Cài đặt',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleText,
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: AppColors.sectionBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, profileState) {
                          return NavigationItem(
                            icon: Icons.person_outline,
                            title: 'Thông tin cá nhân',
                            page: ProfilePage(
                              profile: (profileState is ProfileLoaded)
                                  ? profileState.profile
                                  : null,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      NavigationItem(
                        icon: Icons.notifications_none_outlined,
                        title: 'Thông báo',
                        page: const BlankPage(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Hỗ trợ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleText,
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: AppColors.sectionBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NavigationItem(
                        icon: Icons.help_outline,
                        title: 'Trung tâm hỗ trợ',
                        page: const BlankPage(),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutEvent());
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: Colors.red),
                        const SizedBox(width: 5),
                        Text(
                          'Logout',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
