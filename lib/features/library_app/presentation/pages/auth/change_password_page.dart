import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../widgets/my_button.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _currentPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _currentPasswordError = null;
      _newPasswordError = null;
      _confirmPasswordError = null;
    });

    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    bool hasError = false;

    if (currentPassword.isEmpty) {
      setState(() {
        _currentPasswordError = 'Mật khẩu hiện tại không được để trống';
      });
      hasError = true;
    }

    if (newPassword.isEmpty) {
      setState(() {
        _newPasswordError = 'Mật khẩu mới không được để trống';
      });
      hasError = true;
    } else if (newPassword.length < 6) {
      setState(() {
        _newPasswordError = 'Mật khẩu mới phải có ít nhất 6 ký tự';
      });
      hasError = true;
    }

    if (confirmPassword.isEmpty) {
      setState(() {
        _confirmPasswordError = 'Xác nhận mật khẩu không được để trống';
      });
      hasError = true;
    } else if (confirmPassword != newPassword) {
      setState(() {
        _confirmPasswordError = 'Mật khẩu không khớp';
      });
      hasError = true;
    }

    if (hasError) return;

    FocusScope.of(context).unfocus();
    context.read<AuthBloc>().add(
      ChangePasswordEvent(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.navBackground,
        title: const Text(
          'Đổi mật khẩu',
          style: TextStyle(
            color: AppColors.titleText,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đổi mật khẩu thành công'),
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.pop(context);
          } else if (state is ChangePasswordFailure) {
            setState(() {
              _currentPasswordError = state.message;
            });
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: AppColors.sectionBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Password
                Text(
                  'Mật khẩu hiện tại',
                  style: TextStyle(fontSize: 16, color: AppColors.subText),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _currentPasswordController,
                  obscureText: _obscureCurrentPassword,
                  decoration: InputDecoration(
                    hintText: 'Nhập mật khẩu hiện tại',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.grey[400],
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureCurrentPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey[400],
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureCurrentPassword = !_obscureCurrentPassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    errorText: _currentPasswordError,
                  ),
                ),
                const SizedBox(height: 20),

                // New Password
                Text(
                  'Mật khẩu mới',
                  style: TextStyle(fontSize: 16, color: AppColors.subText),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  onChanged: (value) {
                    if (_confirmPasswordController.text.isNotEmpty) {
                      setState(() {
                        _confirmPasswordError =
                            value == _confirmPasswordController.text
                            ? null
                            : 'Mật khẩu không khớp';
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Nhập mật khẩu mới',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.grey[400],
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey[400],
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    errorText: _newPasswordError,
                  ),
                ),
                const SizedBox(height: 20),

                // Confirm Password
                Text(
                  'Xác nhận mật khẩu mới',
                  style: TextStyle(fontSize: 16, color: AppColors.subText),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  onChanged: (value) {
                    setState(() {
                      _confirmPasswordError =
                          _newPasswordController.text == value
                          ? null
                          : 'Mật khẩu không khớp';
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Xác nhận mật khẩu mới',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.grey[400],
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey[400],
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    errorText: _confirmPasswordError,
                  ),
                ),
                const SizedBox(height: 30),

                // Submit Button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is ChangePasswordLoading;
                    return MyButton(
                      text: isLoading ? 'Đang xử lý...' : 'Đổi mật khẩu',
                      onPressed: isLoading ? null : _submit,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
