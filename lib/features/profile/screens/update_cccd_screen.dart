import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/theme.dart';
import '../../../models/nks_user.dart';
import '../../../services/user_service.dart';
import '../../../shared/utils/avatar_helper.dart';
import '../../../shared/utils/date_formatter.dart';

class UpdateCccdScreen extends StatefulWidget {
  const UpdateCccdScreen({super.key});

  @override
  State<UpdateCccdScreen> createState() => _UpdateCccdScreenState();
}

class _UpdateCccdScreenState extends State<UpdateCccdScreen> {
  final UserService _userService = UserService();
  final ImagePicker _picker = ImagePicker();

  final _numberController = TextEditingController();
  final _dateController = TextEditingController();
  final _placeController = TextEditingController();

  String? _frontBase64;
  String? _backBase64;
  String? _frontUrl;
  String? _backUrl;

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCccdData();
  }

  Future<void> _loadCccdData() async {
    final res = await _userService.getUserInfo();
    final u = _userService.parseUserData(res);
    if (u != null) {
      final nksUser = NksUserModel.fromJson(u);
      if (nksUser.idNumber != null && nksUser.idNumber!.isNotEmpty) {
        _numberController.text = nksUser.idNumber!;
      }
      if (nksUser.displayCccdDate.isNotEmpty) {
        _dateController.text = nksUser.displayCccdDate;
      }
      if (nksUser.idPlace != null && nksUser.idPlace!.isNotEmpty) {
        _placeController.text = nksUser.idPlace!;
      }
      if (nksUser.cccdFront != null && nksUser.cccdFront!.isNotEmpty) {
        _frontUrl = nksUser.cccdFront;
      }
      if (nksUser.cccdBack != null && nksUser.cccdBack!.isNotEmpty) {
        _backUrl = nksUser.cccdBack;
      }
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage(bool isFront, ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64String = 'data:image/jpeg;base64,${base64Encode(bytes)}';
        setState(() {
          if (isFront) {
            _frontBase64 = base64String;
          } else {
            _backBase64 = base64String;
          }
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi chọn/chụp ảnh: $e'), backgroundColor: AppTheme.brandError),
      );
    }
  }

  void _showImagePickerModal(bool isFront) {
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
            Text(
              isFront ? 'Chụp / Chọn Mặt Trước CCCD' : 'Chụp / Chọn Mặt Sau CCCD',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.brandTextPrimary),
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
                _pickImage(isFront, ImageSource.camera);
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
                _pickImage(isFront, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final number = _numberController.text.trim();
    final date = DateFormatter.toApiDate(_dateController.text.trim());
    final place = _placeController.text.trim();

    if (number.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập Số CCCD.'), backgroundColor: AppTheme.brandAccent),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final res = await _userService.updateCccd(
      number: number,
      date: date,
      place: place,
      frontBase64: _frontBase64,
      backBase64: _backBase64,
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Cập nhật thông tin định danh CCCD thành công!'),
          backgroundColor: AppTheme.brandSuccess,
        ),
      );
      context.pop();
    } else {
      final msg = res['message'] as String? ?? 'Cập nhật thất bại. Vui lòng kiểm tra lại.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ $msg'), backgroundColor: AppTheme.brandError),
      );
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _dateController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppTheme.brandTextMuted),
      prefixIcon: Icon(prefixIcon, color: AppTheme.brandTextMuted),
      filled: true,
      fillColor: AppTheme.brandSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.brandBorder)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.brandBorder)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.brandPrimary, width: 1.5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        title: const Text('Cập Nhật Định Danh CCCD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                      const Text('Số CCCD / CMND', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.brandTextPrimary)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _numberController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: AppTheme.brandTextPrimary),
                        decoration: _buildInputDecoration(hintText: '070204001704', prefixIcon: Icons.badge_outlined),
                      ),
                      const SizedBox(height: 16),

                      const Text('Ngày cấp (Ngày/Tháng/Năm)', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.brandTextPrimary)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _dateController,
                        keyboardType: TextInputType.datetime,
                        style: const TextStyle(color: AppTheme.brandTextPrimary),
                        decoration: _buildInputDecoration(hintText: '31/03/2021', prefixIcon: Icons.calendar_today_outlined),
                      ),
                      const SizedBox(height: 16),

                      const Text('Nơi cấp CCCD', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.brandTextPrimary)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _placeController,
                        style: const TextStyle(color: AppTheme.brandTextPrimary),
                        decoration: _buildInputDecoration(hintText: 'Cục Cảnh sát QLHC về TTXH', prefixIcon: Icons.account_balance_outlined),
                      ),
                      const SizedBox(height: 24),

                      // Section Mặt Trước CCCD
                      const Text('Mặt Trước CCCD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.brandTextPrimary)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _showImagePickerModal(true),
                        child: Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                            color: AppTheme.brandSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.brandBorder),
                          ),
                          child: _frontBase64 != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.memory(
                                    base64Decode(_frontBase64!.split(',').last),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : AvatarHelper.formatUrl(_frontUrl) != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        AvatarHelper.formatUrl(_frontUrl)!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => _buildUploadPlaceholder('Mặt Trước CCCD'),
                                      ),
                                    )
                                  : _buildUploadPlaceholder('Mặt Trước CCCD'),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Section Mặt Sau CCCD
                      const Text('Mặt Sau CCCD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.brandTextPrimary)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _showImagePickerModal(false),
                        child: Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                            color: AppTheme.brandSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.brandBorder),
                          ),
                          child: _backBase64 != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.memory(
                                    base64Decode(_backBase64!.split(',').last),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : AvatarHelper.formatUrl(_backUrl) != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        AvatarHelper.formatUrl(_backUrl)!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => _buildUploadPlaceholder('Mặt Sau CCCD'),
                                      ),
                                    )
                                  : _buildUploadPlaceholder('Mặt Sau CCCD'),
                        ),
                      ),
                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _handleSubmit,
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
                              : const Text('Lưu Thông Tin Định Danh CCCD', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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

  Widget _buildUploadPlaceholder(String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.add_a_photo_outlined, size: 36, color: AppTheme.brandPrimary),
        const SizedBox(height: 8),
        Text('Chụp hoặc tải ảnh $label', style: const TextStyle(color: AppTheme.brandPrimary, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
