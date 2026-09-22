import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/theme.dart';
import '../../../models/nks_user.dart';
import '../../../services/user_service.dart';
import '../../../shared/utils/avatar_helper.dart';
import '../../../shared/utils/date_formatter.dart';
import '../widgets/avatar_editor_dialog.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UserService _userService = UserService();
  final ImagePicker _picker = ImagePicker();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _pobController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _provinceController = TextEditingController();
  final _websiteController = TextEditingController();
  final _introController = TextEditingController();

  String? _avatarUrl;
  int _gender = 0; // 0: Nam, 1: Nữ
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isUpdatingAvatar = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    // 1. Pre-fill from SharedPreferences for instant UI rendering
    final prefs = await SharedPreferences.getInstance();
    final cachedName = prefs.getString('user_name');
    final cachedEmail = prefs.getString('user_email');
    final cachedAvatar = prefs.getString('user_avatar');

    if (cachedName != null && cachedName.isNotEmpty) {
      _nameController.text = cachedName;
    }
    if (cachedEmail != null && cachedEmail.isNotEmpty) {
      _emailController.text = cachedEmail;
    }
    if (cachedAvatar != null && cachedAvatar.isNotEmpty) {
      _avatarUrl = cachedAvatar;
    }

    // 2. Fetch fresh user info from API
    final res = await _userService.getUserInfo();
    final u = _userService.parseUserData(res);
    if (u != null) {
      final nksUser = NksUserModel.fromJson(u);
      
      final first = (u['firstname'] as String? ?? u['first_name'] as String? ?? '').trim();
      final last = (u['lastname'] as String? ?? u['last_name'] as String? ?? '').trim();
      final combined = '$first $last'.trim();

      if (combined.isNotEmpty) {
        _nameController.text = combined;
      } else if (nksUser.fullName.isNotEmpty && nksUser.fullName != 'Thành viên StudyDeck') {
        _nameController.text = nksUser.fullName;
      }
      if (nksUser.email != null && nksUser.email!.isNotEmpty) {
        _emailController.text = nksUser.email!;
      }
      if (nksUser.phone != null) {
        _phoneController.text = nksUser.phone!;
      }
      if (nksUser.displayDob.isNotEmpty) {
        _dobController.text = nksUser.displayDob;
      }
      if (nksUser.pob != null) {
        _pobController.text = nksUser.pob!;
      }
      if (nksUser.idNumber != null) {
        _idNumberController.text = nksUser.idNumber!;
      }
      if (nksUser.province != null) {
        _provinceController.text = nksUser.province!;
      }
      if (nksUser.website != null) {
        _websiteController.text = nksUser.website!;
      }
      if (nksUser.intro != null) {
        _introController.text = nksUser.intro!;
      }
      if (nksUser.gender != null) {
        _gender = nksUser.gender!;
      }
      if (nksUser.avatar != null && nksUser.avatar!.isNotEmpty) {
        _avatarUrl = nksUser.avatar;
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickAndUploadAvatar(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 92,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        if (!mounted) return;

        await AvatarEditorDialog.show(
          context,
          imageBytes: bytes,
          onConfirm: (croppedBytes) async {
            setState(() {
              _isUpdatingAvatar = true;
            });

            final base64String = 'data:image/png;base64,${base64Encode(croppedBytes)}';
            final res = await _userService.updateAvatar(base64Avatar: base64String);

            if (!mounted) return false;

            setState(() {
              _isUpdatingAvatar = false;
            });

            if (res['success'] == true) {
              final u = _userService.parseUserData(res);
              final newAvatar = u?['avatar'] as String? ?? u?['avatar_url'] as String?;
              if (newAvatar != null && mounted) {
                setState(() {
                  _avatarUrl = newAvatar;
                });
              }
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🎉 Cập nhật ảnh đại diện thành công!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
              return true;
            } else {
              final msg = res['message'] as String? ?? 'Cập nhật avatar thất bại.';
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('❌ $msg'), backgroundColor: Colors.red),
                );
              }
              return false;
            }
          },
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isUpdatingAvatar = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải/chụp ảnh: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _showAvatarPickerModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.brandSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.brandBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Thay Đổi Ảnh Đại Diện',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.brandTextPrimary),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: AppTheme.brandPrimary),
              title: const Text('Chụp ảnh mới bằng Camera', style: TextStyle(color: AppTheme.brandTextPrimary, fontWeight: FontWeight.w600)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppTheme.brandBorder),
              ),
              tileColor: AppTheme.brandBackground,
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadAvatar(ImageSource.camera);
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AppTheme.brandPrimary),
              title: const Text('Chọn ảnh từ Thư viện ảnh', style: TextStyle(color: AppTheme.brandTextPrimary, fontWeight: FontWeight.w600)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppTheme.brandBorder),
              ),
              tileColor: AppTheme.brandBackground,
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadAvatar(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    final fullName = _nameController.text.trim();

    if (fullName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập Họ và Tên của bạn.'),
          backgroundColor: AppTheme.brandAccent,
        ),
      );
      return;
    }

    final parts = fullName.split(RegExp(r'\s+'));
    final String firstname;
    final String lastname;
    if (parts.length == 1) {
      firstname = parts.first;
      lastname = parts.first;
    } else {
      firstname = parts.first;
      lastname = parts.sublist(1).join(' ');
    }

    setState(() {
      _isSaving = true;
    });

    final res = await _userService.updateUserInfo(
      firstname: firstname,
      lastname: lastname,
      phone: _phoneController.text.trim(),
      gender: _gender,
      dob: DateFormatter.toApiDate(_dobController.text.trim()),
      pob: _pobController.text.trim(),
      idNumber: _idNumberController.text.trim(),
      province: _provinceController.text.trim(),
      website: _websiteController.text.trim(),
      intro: _introController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Cập nhật thông tin hồ sơ thành công!'),
          backgroundColor: AppTheme.brandSuccess,
        ),
      );
      context.pop();
    } else {
      final msg = res['message'] as String? ?? 'Cập nhật thất bại. Vui lòng thử lại.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ $msg'),
          backgroundColor: AppTheme.brandError,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _pobController.dispose();
    _idNumberController.dispose();
    _provinceController.dispose();
    _websiteController.dispose();
    _introController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    bool readOnly = false,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppTheme.brandTextMuted),
      prefixIcon: Icon(prefixIcon, color: AppTheme.brandTextMuted),
      filled: true,
      fillColor: readOnly ? AppTheme.brandBackground : AppTheme.brandSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.brandBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.brandBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.brandPrimary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        title: const Text('Chỉnh Sửa Hồ Sơ Cá Nhân', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppTheme.brandSurface,
        foregroundColor: AppTheme.brandTextPrimary,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppTheme.brandBorder, height: 1),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.brandPrimary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar Picker Widget
                      Center(
                        child: Stack(
                          children: [
                            InkWell(
                              onTap: _showAvatarPickerModal,
                              borderRadius: BorderRadius.circular(50),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: AppTheme.chipIndigoBg,
                                backgroundImage: AvatarHelper.formatUrl(_avatarUrl) != null
                                    ? NetworkImage(AvatarHelper.formatUrl(_avatarUrl)!)
                                    : null,
                                child: AvatarHelper.formatUrl(_avatarUrl) == null
                                    ? const Icon(Icons.person, size: 54, color: AppTheme.brandPrimary)
                                    : null,
                              ),
                            ),
                            if (_isUpdatingAvatar)
                              Positioned.fill(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black45,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(color: Colors.white),
                                  ),
                                ),
                              ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: _showAvatarPickerModal,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: AppTheme.brandPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Họ và tên
                      const Text('Họ và tên', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.brandTextPrimary)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _nameController,
                        style: const TextStyle(color: AppTheme.brandTextPrimary),
                        decoration: _buildInputDecoration(hintText: 'Nhập họ và tên đầy đủ', prefixIcon: Icons.person_outline),
                      ),
                      const SizedBox(height: 16),

                      // Email (Tài khoản) - Read only
                      const Text('Email tài khoản', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.brandTextPrimary)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _emailController,
                        readOnly: true,
                        style: const TextStyle(color: AppTheme.brandTextSecondary),
                        decoration: _buildInputDecoration(hintText: 'Email đăng ký', prefixIcon: Icons.email_outlined, readOnly: true),
                      ),
                      const SizedBox(height: 16),

                      const Text('Số điện thoại', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.brandTextPrimary)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: AppTheme.brandTextPrimary),
                        decoration: _buildInputDecoration(hintText: 'Nhập số điện thoại', prefixIcon: Icons.phone_outlined),
                      ),
                      const SizedBox(height: 16),

                      // Giới tính (Ô tích chọn Nam / Nữ)
                      const Text('Giới tính', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.brandTextPrimary)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _gender = 0),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: _gender == 0 ? AppTheme.chipIndigoBg : AppTheme.brandSurface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _gender == 0 ? AppTheme.brandPrimary : AppTheme.brandBorder,
                                    width: _gender == 0 ? 1.5 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: _gender == 0 ? AppTheme.brandPrimary : AppTheme.brandBorder,
                                          width: _gender == 0 ? 6 : 2,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Nam',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: AppTheme.brandTextPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _gender = 1),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: _gender == 1 ? AppTheme.chipIndigoBg : AppTheme.brandSurface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _gender == 1 ? AppTheme.brandPrimary : AppTheme.brandBorder,
                                    width: _gender == 1 ? 1.5 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: _gender == 1 ? AppTheme.brandPrimary : AppTheme.brandBorder,
                                          width: _gender == 1 ? 6 : 2,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Nữ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: AppTheme.brandTextPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Ngày sinh formatted dd/mm/yyyy (Ngày / Tháng / Năm)
                      const Text('Ngày sinh (Ngày/Tháng/Năm)', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.brandTextPrimary)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _dobController,
                        keyboardType: TextInputType.datetime,
                        style: const TextStyle(color: AppTheme.brandTextPrimary),
                        decoration: _buildInputDecoration(hintText: '17/08/2004', prefixIcon: Icons.calendar_today_outlined),
                      ),
                      const SizedBox(height: 16),

                      const Text('Quê quán / Nơi sinh (POB)', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.brandTextPrimary)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _pobController,
                        style: const TextStyle(color: AppTheme.brandTextPrimary),
                        decoration: _buildInputDecoration(hintText: 'Quê quán', prefixIcon: Icons.location_city_outlined),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Số CCCD / CMND', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.brandTextPrimary)),
                          TextButton.icon(
                            onPressed: () => context.push('/update-cccd'),
                            icon: const Icon(Icons.badge_outlined, size: 16, color: AppTheme.brandPrimary),
                            label: const Text('Cập nhật CCCD 2 mặt →', style: TextStyle(color: AppTheme.brandPrimary, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _idNumberController,
                        style: const TextStyle(color: AppTheme.brandTextPrimary),
                        decoration: _buildInputDecoration(hintText: 'Số CCCD/CMND', prefixIcon: Icons.badge_outlined),
                      ),
                      const SizedBox(height: 16),

                      const Text('Tỉnh / Thành phố', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.brandTextPrimary)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _provinceController,
                        style: const TextStyle(color: AppTheme.brandTextPrimary),
                        decoration: _buildInputDecoration(hintText: 'Tỉnh/Thành phố', prefixIcon: Icons.map_outlined),
                      ),
                      const SizedBox(height: 16),

                      const Text('Website / Link cá nhân', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.brandTextPrimary)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _websiteController,
                        style: const TextStyle(color: AppTheme.brandTextPrimary),
                        decoration: _buildInputDecoration(hintText: 'https://...', prefixIcon: Icons.link_outlined),
                      ),
                      const SizedBox(height: 16),

                      const Text('Giới thiệu bản thân (Intro)', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.brandTextPrimary)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _introController,
                        maxLines: 3,
                        style: const TextStyle(color: AppTheme.brandTextPrimary),
                        decoration: InputDecoration(
                          hintText: 'Mô tả ngắn về bạn...',
                          hintStyle: const TextStyle(color: AppTheme.brandTextMuted),
                          filled: true,
                          fillColor: AppTheme.brandSurface,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.brandBorder)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.brandBorder)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.brandPrimary, width: 1.5)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _handleSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.brandPrimary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                )
                              : const Text('Lưu Thay Đổi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
