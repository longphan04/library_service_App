import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../widgets/my_button.dart';
import '../../../domain/entities/profile.dart';

class ProfilePage extends StatefulWidget {
  final Profile? profile;
  const ProfilePage({super.key, this.profile});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _dobController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(
      text: widget.profile?.fullName ?? '',
    );
    _phoneController = TextEditingController(text: widget.profile?.phone ?? '');
    _addressController = TextEditingController(
      text: widget.profile?.address ?? '',
    );
    _dobController = TextEditingController(
      text: widget.profile?.dateOfBirth != null
          ? widget.profile!.dateOfBirth!.toIso8601String().split('T').first
          : '',
    );

    if (widget.profile != null) {
      _currentProfile = widget.profile;
      _hasInitialized = true;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<ProfileBloc>().state;
      if (state is! ProfileLoaded && state is! ProfileLoading) {
        context.read<ProfileBloc>().add(LoadProfileEvent());
      }
    });
  }

  Profile? _currentProfile;
  File? _pickedImage;
  bool _hasInitialized = false;
  bool _isUpdating = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _populateControllers(Profile profile) {
    _currentProfile = profile;
    _fullNameController.text = profile.fullName;
    _phoneController.text = profile.phone ?? '';
    _addressController.text = profile.address ?? '';
    _dobController.text = profile.dateOfBirth != null
        ? profile.dateOfBirth!.toIso8601String().split('T').first
        : '';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() {
      _pickedImage = File(file.path);
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final currentDate = _currentProfile?.dateOfBirth ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    setState(() {
      _dobController.text = picked.toIso8601String().split('T').first;
    });
  }

  void _submit() {
    final profile = _currentProfile;
    if (profile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang tải dữ liệu, vui lòng thử lại')),
      );
      context.read<ProfileBloc>().add(LoadProfileEvent());
      return;
    }

    final fullName = _fullNameController.text.trim();
    if (fullName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Họ và tên không được để trống')),
      );
      return;
    }

    final phone = _phoneController.text.trim();

    if (phone.isNotEmpty) {
      final digits = phone.replaceAll(RegExp(r'\D'), '');
      if (digits.length != 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Số điện thoại phải có đúng 10 chữ số')),
        );
        return;
      }
    }

    final dobText = _dobController.text.trim();
    final dob = dobText.isNotEmpty ? DateTime.tryParse(dobText) : null;

    final updatedProfile = Profile(
      profileId: profile.profileId,
      userId: profile.userId,
      fullName: fullName,
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      image: _pickedImage ?? profile.image,
      avatarUrl: profile.avatarUrl,
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      dateOfBirth: dob,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );

    FocusScope.of(context).unfocus();
    setState(() {
      _isUpdating = true;
    });
    context.read<ProfileBloc>().add(UpdateProfileEvent(updatedProfile));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.navBackground,
        title: const Text(
          'Thông tin cá nhân',
          style: TextStyle(
            color: AppColors.titleText,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, profileState) {
          if (profileState is ProfileLoaded) {
            if (!_hasInitialized || _isUpdating) {
              _populateControllers(profileState.profile);
              _pickedImage = null;
              _hasInitialized = true;
            }
            if (_isUpdating) {
              _isUpdating = false;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cập nhật thành công'),
                  duration: Duration(seconds: 1, milliseconds: 500),
                ),
              );
            }
          }

          if (profileState is ProfileFailure && _isUpdating) {
            _isUpdating = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(profileState.message),
                duration: const Duration(seconds: 1, milliseconds: 500),
              ),
            );
          }
        },
        builder: (context, profileState) {
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

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 20.0),
                    padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      color: AppColors.sectionBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: _pickedImage != null
                                  ? FileImage(_pickedImage!)
                                  : (avatarUrl != null
                                        ? NetworkImage(avatarUrl)
                                        : null),
                              child: _pickedImage == null && avatarUrl == null
                                  ? Icon(
                                      Icons.person,
                                      size: 60,
                                      color: AppColors.icon,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryButton,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Thông tin cơ bản',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.sectionBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Họ và tên',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.subText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _fullNameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: 'Nhập họ và tên',
                            filled: true,
                            fillColor: AppColors.sectionBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: AppColors.primaryButton,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Số điện thoại',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.subText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Nhập số điện thoại',
                            fillColor: AppColors.sectionBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: AppColors.primaryButton,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Địa chỉ',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.subText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _addressController,
                          keyboardType: TextInputType.streetAddress,
                          decoration: InputDecoration(
                            hintText: 'Nhập địa chỉ',
                            filled: true,
                            fillColor: AppColors.sectionBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: AppColors.primaryButton,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Ngày sinh',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.subText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _dobController,
                          readOnly: true,
                          keyboardType: TextInputType.datetime,
                          onTap: () => _pickDate(context),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.sectionBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: AppColors.primaryButton,
                                width: 1,
                              ),
                            ),
                            suffixIcon: const Icon(Icons.calendar_month),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    text: _isUpdating
                        ? 'Đang cập nhật...'
                        : 'Cập nhật thông tin',
                    onPressed: _isUpdating || profileState is ProfileLoading
                        ? null
                        : _submit,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
