import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';

class AiAssessmentScreen extends StatefulWidget {
  const AiAssessmentScreen({super.key});

  @override
  State<AiAssessmentScreen> createState() => _AiAssessmentScreenState();
}

class _AiAssessmentScreenState extends State<AiAssessmentScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate AI model processing time
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: _isLoading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(
                            color: AppTheme.chipIndigoBg,
                            shape: BoxShape.circle,
                          ),
                          child: const CircularProgressIndicator(
                            color: AppTheme.brandPrimary,
                            strokeWidth: 3,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'AI đang phân tích mục tiêu & trình độ...',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.brandTextPrimary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Đang lập bản đồ tri thức và tối ưu hóa thuật toán lặp lại ngắt quãng (SM-2)...',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.brandTextSecondary,
                              ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Spacer(),
                        // Success Badge
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.tintGreenBg,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.brandSuccess.withValues(alpha: 0.4)),
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              size: 48,
                              color: AppTheme.brandSuccess,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Lộ trình cá nhân hóa sẵn sàng!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.brandTextPrimary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Dựa trên khảo sát, StudyDeck AI đã thiết kế riêng cho bạn:',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.brandTextSecondary,
                              ),
                        ),
                        const SizedBox(height: 24),

                        // Recommendation Cards
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.brandSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.brandBorder),
                          ),
                          child: Column(
                            children: [
                              _buildResultRow(
                                icon: Icons.workspace_premium,
                                title: 'Trình độ khởi đầu',
                                subtitle: 'B1 Intermediate - Tiếng Anh Giao Tiếp & Công Việc',
                                color: AppTheme.brandPrimary,
                                bgColor: AppTheme.tintIndigoBg,
                              ),
                              const Divider(height: 24, color: AppTheme.brandBorder),
                              _buildResultRow(
                                icon: Icons.timer,
                                title: 'Mục tiêu hàng ngày',
                                subtitle: '15 phút / ngày • 15 từ vựng mới & 1 bài tập AI',
                                color: AppTheme.brandAccent,
                                bgColor: AppTheme.tintAmberBg,
                              ),
                              const Divider(height: 24, color: AppTheme.brandBorder),
                              _buildResultRow(
                                icon: Icons.psychology,
                                title: 'Thuật toán ghi nhớ',
                                subtitle: 'Tự động nhắc lịch ôn tập theo đường cong quên SuperMemo-2',
                                color: AppTheme.tintPurpleText,
                                bgColor: AppTheme.tintPurpleBg,
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        // Button Go to Home
                        ElevatedButton(
                          onPressed: () => context.go('/login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.brandPrimary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Tiếp Tục Tới Đăng Nhập', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color bgColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.brandTextPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: AppTheme.brandTextSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
