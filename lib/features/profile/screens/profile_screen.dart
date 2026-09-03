import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Hồ Sơ Cá Nhân',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.onSurface),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // User Card Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppTheme.primaryContainer.withValues(alpha: 0.2),
                      child: const Icon(Icons.person, size: 36, color: AppTheme.primaryContainer),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alex Nguyen',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'alex.nguyen@studydeck.ai',
                            style: TextStyle(fontSize: 13, color: AppTheme.onSurfaceVariant),
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.workspace_premium, size: 16, color: AppTheme.tertiary),
                              SizedBox(width: 4),
                              Text(
                                'Tài khoản Premium AI',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.tertiary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Gamification Stats Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('Level 5', 'Cấp Độ', Icons.military_tech, const Color(0xFFE67E22)),
                    Container(height: 32, width: 1, color: AppTheme.outlineVariant),
                    _buildStatColumn('1,250 XP', 'Kinh Nghiệm', Icons.bolt, AppTheme.primaryContainer),
                    Container(height: 32, width: 1, color: AppTheme.outlineVariant),
                    _buildStatColumn('5 Ngày', 'Streak', Icons.local_fire_department, const Color(0xFFE65100)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Settings & Menu items
              _buildMenuItem(
                icon: Icons.bookmark_outline,
                title: 'Từ Vựng Đã Lưu (Saved Words)',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.history,
                title: 'Lịch Sử Ôn Tập Flashcard',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.notifications_none,
                title: 'Nhắc Nhở Học Hàng Ngày',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.support_agent,
                title: 'Trợ Giúp & FAQ',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Đăng Xuất',
                titleColor: AppTheme.error,
                iconColor: AppTheme.error,
                onTap: () => context.go('/login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 4),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color)),
          ],
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: iconColor ?? AppTheme.onSurface),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: titleColor ?? AppTheme.onSurface,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, size: 20, color: AppTheme.outline),
      ),
    );
  }
}
