import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  bool _notificationsEnabled = true;

  Future<void> _handleSignOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng Xuất', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Bạn có chắc chắn muốn đăng xuất khỏi tài khoản StudyDeck AI?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy', style: TextStyle(color: AppTheme.brandTextMuted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.brandError,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Đăng Xuất', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authService.signOut();
      if (!mounted) return;
      context.go('/login');
    }
  }

  void _showSupportModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.brandSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const Row(
              children: [
                Icon(Icons.headset_mic, color: AppTheme.brandPrimary, size: 28),
                SizedBox(width: 12),
                Text(
                  'Hỗ Trợ & Trợ Giúp 24/7',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.brandTextPrimary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Đội ngũ hỗ trợ StudyDeck AI luôn sẵn sàng đồng hành và giải đáp thắc mắc của bạn.',
              style: TextStyle(color: AppTheme.brandTextSecondary, fontSize: 14),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.email_outlined, color: AppTheme.brandPrimary),
              title: const Text('Email hỗ trợ kỹ thuật', style: TextStyle(color: AppTheme.brandTextPrimary, fontWeight: FontWeight.w600)),
              subtitle: const Text('support@studydeck.ai', style: TextStyle(color: AppTheme.brandTextSecondary)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppTheme.brandBorder),
              ),
              tileColor: AppTheme.brandBackground,
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.phone_in_talk_outlined, color: AppTheme.brandPrimary),
              title: const Text('Hotline CSKH', style: TextStyle(color: AppTheme.brandTextPrimary, fontWeight: FontWeight.w600)),
              subtitle: const Text('1900 6868 (8:00 - 22:00)', style: TextStyle(color: AppTheme.brandTextSecondary)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppTheme.brandBorder),
              ),
              tileColor: AppTheme.brandBackground,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.brandPrimary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Đóng', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoModal(String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.brandSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.brandTextPrimary),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Text(
                    content,
                    style: const TextStyle(fontSize: 14, height: 1.6, color: AppTheme.brandTextSecondary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brandPrimary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Đã hiểu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        title: const Text('Cài Đặt Tài Khoản', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppTheme.brandSurface,
        foregroundColor: AppTheme.brandTextPrimary,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppTheme.brandBorder, height: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NHÓM 1: TÀI KHOẢN & ĐỊNH DANH
                  _buildSectionHeader('TÀI KHOẢN & ĐỊNH DANH'),
                  const SizedBox(height: 10),
                  _buildMenuItem(
                    icon: Icons.edit_note,
                    title: 'Thông Tin Hồ Sơ',
                    onTap: () => context.push('/edit-profile'),
                  ),
                  _buildMenuItem(
                    icon: Icons.badge_outlined,
                    title: 'Định Danh Cá Nhân',
                    onTap: () => context.push('/update-cccd'),
                  ),
                  _buildMenuItem(
                    icon: Icons.lock_reset,
                    title: 'Đổi Mật Khẩu',
                    onTap: () => context.push('/change-password'),
                  ),
                  const SizedBox(height: 24),

                  // NHÓM 2: ỨNG DỤNG & HỖ TRỢ
                  _buildSectionHeader('CÀI ĐẶT ỨNG DỤNG & HỖ TRỢ'),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.brandSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.brandBorder),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.notifications_active_outlined, color: AppTheme.brandTextPrimary),
                      title: const Text('Thông Báo Học Tập', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.brandTextPrimary)),
                      trailing: Switch(
                        value: _notificationsEnabled,
                        activeThumbColor: AppTheme.brandPrimary,
                        activeTrackColor: AppTheme.chipIndigoBg,
                        onChanged: (val) {
                          setState(() {
                            _notificationsEnabled = val;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(val ? '🔔 Đã bật thông báo nhắc học!' : '🔕 Đã tắt thông báo nhắc học.'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  _buildMenuItem(
                    icon: Icons.headset_mic_outlined,
                    title: 'Hỗ Trợ & Trợ Giúp',
                    onTap: _showSupportModal,
                  ),
                  _buildMenuItem(
                    icon: Icons.gavel_outlined,
                    title: 'Điều Khoản Sử Dụng',
                    onTap: () => _showInfoModal(
                      'Điều Khoản Sử Dụng StudyDeck AI',
                      '1. Quyền sở hữu và Mục đích sử dụng:\nStudyDeck AI cung cấp công cụ học tập thông minh dựa trên trí tuệ nhân tạo. Người dùng cam kết sử dụng dịch vụ cho mục đích học tập cá nhân chính đáng.\n\n2. Quyền riêng tư & Tài khoản:\nNgười dùng có trách nhiệm bảo mật thông tin đăng nhập tài khoản cá nhân. Không chia sẻ tài khoản cho người khác.\n\n3. Cập nhật nội dung:\nStudyDeck AI liên tục cải tiến hệ thống và có quyền cập nhật tính năng nhằm nâng cao trải nghiệm học tập.',
                    ),
                  ),
                  _buildMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Chính Sách Bảo Mật',
                    onTap: () => _showInfoModal(
                      'Chính Sách Bảo Mật StudyDeck AI',
                      '1. Thu thập thông tin:\nChúng tôi thu thập thông tin tài khoản (Họ tên, Email, SĐT, Ngày sinh, CCCD) để cung cấp tính năng cá nhân hóa bài học và định danh tài khoản.\n\n2. Bảo mật dữ liệu:\nToàn bộ dữ liệu cá nhân và ảnh CCCD được mã hóa và truyền tải an toàn qua phương thức mã hóa SSL/TLS.\n\n3. Cam kết không chia sẻ:\nStudyDeck AI tuyệt đối không bán hoặc chia sẻ dữ liệu cá nhân của người dùng cho bên thứ ba vì mục đích thương mại.',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // NHÓM 3: PHIÊN ĐĂNG NHẬP
                  _buildSectionHeader('PHIÊN ĐĂNG NHẬP'),
                  const SizedBox(height: 10),
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'Đăng Xuất Tài Khoản',
                    titleColor: AppTheme.brandError,
                    iconColor: AppTheme.brandError,
                    onTap: _handleSignOut,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppTheme.brandTextMuted,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.brandSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.brandBorder),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: iconColor ?? AppTheme.brandTextPrimary),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: titleColor ?? AppTheme.brandTextPrimary,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: AppTheme.brandTextSecondary),
              )
            : null,
        trailing: const Icon(Icons.chevron_right, size: 20, color: AppTheme.brandTextMuted),
      ),
    );
  }
}
