import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../services/auth_service.dart';
import '../../../../shared/utils/avatar_helper.dart';
import '../../../../shared/widgets/studydeck_logo_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final AuthService _authService = AuthService();

  List<Map<String, dynamic>> _savedAccounts = [];
  Map<String, dynamic>? _selectedAccount;
  bool _isManualEntry = false;
  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedAccounts();
  }

  Future<void> _loadSavedAccounts() async {
    final isLoggedIn = await _authService.isUserLoggedIn();
    if (isLoggedIn && mounted) {
      context.go('/');
      return;
    }
    final list = await _authService.getSavedAccounts();
    if (!mounted) return;
    setState(() {
      _savedAccounts = list;
      if (list.isNotEmpty) {
        _selectedAccount = list.first;
        _emailController.text = _selectedAccount!['email'] as String? ?? '';
      }
    });
  }

  Future<void> _removeSavedAccount(String email) async {
    await _authService.removeSavedAccount(email);
    await _loadSavedAccounts();
    if (!mounted) return;
    if (_savedAccounts.isEmpty) {
      setState(() {
        _isManualEntry = true;
        _selectedAccount = null;
        _emailController.clear();
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã gỡ tài khoản $email'), duration: const Duration(seconds: 2)),
    );
  }

  void _showSavedAccountsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Đổi tài khoản đăng nhập',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppTheme.onSurface,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          tooltip: 'Đóng',
                          onPressed: () => Navigator.pop(sheetContext),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _savedAccounts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final acc = _savedAccounts[index];
                          final email = acc['email'] as String? ?? '';
                          final name = acc['name'] as String? ?? email;
                          final avatar = acc['avatar'] as String?;
                          final isSelected = _selectedAccount?['email'] == email;

                          return Container(
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFF0ECFF) : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade300,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                              horizontalTitleGap: 10,
                              leading: CircleAvatar(
                                radius: 18,
                                backgroundColor: const Color(0xFF4F46E5).withValues(alpha: 0.2),
                                backgroundImage: AvatarHelper.formatUrl(avatar) != null
                                    ? NetworkImage(AvatarHelper.formatUrl(avatar)!)
                                    : null,
                                child: AvatarHelper.formatUrl(avatar) == null
                                    ? const Icon(Icons.person, size: 20, color: Color(0xFF4F46E5))
                                    : null,
                              ),
                              title: Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                  fontSize: 13,
                                  color: isSelected ? const Color(0xFF4F46E5) : AppTheme.onSurface,
                                ),
                              ),
                              subtitle: Text(
                                email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 11, color: AppTheme.onSurfaceVariant),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isSelected)
                                    const Padding(
                                      padding: EdgeInsets.only(right: 6),
                                      child: Icon(Icons.check_circle, size: 20, color: Color(0xFF4F46E5)),
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                                    tooltip: 'Gỡ tài khoản',
                                    onPressed: () async {
                                      await _removeSavedAccount(email);
                                      if (!sheetContext.mounted) return;
                                      if (_savedAccounts.isEmpty) {
                                        Navigator.pop(sheetContext);
                                      } else {
                                        setModalState(() {});
                                      }
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedAccount = acc;
                                  _emailController.text = email;
                                  _isManualEntry = false;
                                });
                                Navigator.pop(sheetContext);
                                _passwordFocusNode.requestFocus();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(height: 1),
                    const SizedBox(height: 6),
                    ListTile(
                      dense: true,
                      leading: const CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFFEEF2FF),
                        child: Icon(Icons.add, size: 18, color: Color(0xFF4F46E5)),
                      ),
                      title: const Text(
                        'Đăng nhập bằng tài khoản khác',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _isManualEntry = true;
                          _emailController.clear();
                        });
                        Navigator.pop(sheetContext);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final usernameOrEmail = _emailController.text.trim();
    final password = _passwordController.text;

    if (usernameOrEmail.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đầy đủ Email/Tên đăng nhập và Mật khẩu.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final res = await _authService.loginWithNksApi(
      usernameOrEmail: usernameOrEmail,
      password: password,
      rememberMe: _rememberMe,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (res['success'] == true) {
      Map<String, dynamic>? userMap;
      if (res['data'] is Map<String, dynamic>) {
        final data = res['data'] as Map<String, dynamic>;
        userMap = (data['user'] is Map<String, dynamic>) ? data['user'] as Map<String, dynamic> : data;
      }
      final userName = userMap?['name'] as String? ?? userMap?['firstname'] as String? ?? 'bạn';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Chào mừng $userName đăng nhập thành công!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to Home or Starting Point (if coming from Survey)
      final fromSurvey = GoRouterState.of(context).uri.queryParameters['fromSurvey'] == 'true';
      if (fromSurvey) {
        context.go('/survey-start');
      } else {
        context.go('/');
      }
    } else {
      String errorMsg = 'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin.';
      if (res['error'] != null && res['error'].toString().isNotEmpty) {
        errorMsg = res['error'].toString();
      } else if (res['message'] != null && res['message'].toString().isNotEmpty) {
        if (res['message'] == 'Unauthorized') {
          errorMsg = 'Tài khoản hoặc mật khẩu không chính xác.';
        } else {
          errorMsg = res['message'].toString();
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ $errorMsg'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showSavedAccountView = _savedAccounts.isNotEmpty && !_isManualEntry;

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppTheme.brandTextPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: AppTheme.brandSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.brandBorder),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Unified App Brand Logo Badge
                    const Center(
                      child: StudyDeckHeaderBadge(iconSize: 32),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Chào mừng quay trở lại',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.brandTextPrimary,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Đăng nhập để tiếp tục học tập cùng AI.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.brandTextSecondary,
                          ),
                    ),
                    const SizedBox(height: 24),

                    // Saved Accounts View Mode (Active Selected Account Card)
                    if (showSavedAccountView) ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Tài khoản đăng nhập',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.brandPrimary),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Currently Selected Active Account Card
                      if (_selectedAccount != null) ...[
                        Builder(builder: (context) {
                          final email = _selectedAccount!['email'] as String? ?? '';
                          final name = _selectedAccount!['name'] as String? ?? email;
                          final avatar = _selectedAccount!['avatar'] as String?;

                          return Container(
                            decoration: BoxDecoration(
                              color: AppTheme.chipIndigoBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.brandPrimary, width: 1.5),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                              horizontalTitleGap: 10,
                              leading: CircleAvatar(
                                radius: 18,
                                backgroundColor: AppTheme.brandPrimaryLight,
                                backgroundImage: AvatarHelper.formatUrl(avatar) != null
                                    ? NetworkImage(AvatarHelper.formatUrl(avatar)!)
                                    : null,
                                child: AvatarHelper.formatUrl(avatar) == null
                                    ? const Icon(Icons.person, size: 20, color: AppTheme.brandPrimary)
                                    : null,
                              ),
                              title: Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.brandTextPrimary),
                              ),
                              subtitle: Text(
                                email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12, color: AppTheme.brandTextSecondary),
                              ),
                              trailing: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.switch_account_rounded, size: 22, color: AppTheme.brandPrimary),
                                tooltip: 'Đổi tài khoản',
                                onPressed: _showSavedAccountsBottomSheet,
                              ),
                              onTap: _showSavedAccountsBottomSheet,
                            ),
                          );
                        }),
                      ],
                      const SizedBox(height: 16),
                    ],

                    // Manual Email Entry Form (Only shown if NO saved accounts OR user clicked "Đăng nhập bằng tài khoản khác")
                    if (_isManualEntry || _savedAccounts.isEmpty) ...[
                      Text(
                        'Email / Tên đăng nhập',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppTheme.brandTextPrimary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Nhập email hoặc tên đăng nhập',
                          hintStyle: const TextStyle(color: AppTheme.brandTextMuted, fontSize: 13),
                          prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.brandTextMuted),
                          filled: true,
                          fillColor: AppTheme.brandSurface,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppTheme.brandBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppTheme.brandBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppTheme.brandPrimary, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Password Input Field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mật khẩu',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: AppTheme.brandTextPrimary,
                              ),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/forgot-password'),
                          child: Text(
                            'Quên mật khẩu?',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppTheme.brandPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Nhập mật khẩu',
                        hintStyle: const TextStyle(color: AppTheme.brandTextMuted, fontSize: 13),
                        prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.brandTextMuted),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: AppTheme.brandTextMuted,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: AppTheme.brandSurface,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppTheme.brandBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppTheme.brandBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppTheme.brandPrimary, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Remember Me Checkbox
                    InkWell(
                      onTap: () {
                        setState(() {
                          _rememberMe = !_rememberMe;
                        });
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            activeColor: AppTheme.brandPrimary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            onChanged: (val) {
                              setState(() {
                                _rememberMe = val ?? false;
                              });
                            },
                          ),
                          const Text(
                            'Ghi nhớ đăng nhập',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.brandTextPrimary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Submit Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.brandPrimary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Đăng nhập'),
                                SizedBox(width: 8),
                                Icon(Icons.login, size: 20),
                              ],
                            ),
                    ),
                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        const Expanded(child: Divider(color: AppTheme.brandBorder)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            'Hoặc đăng nhập bằng',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 12,
                                  color: AppTheme.brandTextMuted,
                                ),
                          ),
                        ),
                        const Expanded(child: Divider(color: AppTheme.brandBorder)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Social Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _handleLogin,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: AppTheme.brandBorder),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.g_mobiledata, size: 24, color: Colors.red),
                            label: const Text('Google', style: TextStyle(color: AppTheme.brandTextPrimary)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _handleLogin,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: AppTheme.brandBorder),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.facebook, size: 22, color: Color(0xFF1877F2)),
                            label: const Text('Facebook', style: TextStyle(color: AppTheme.brandTextPrimary)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Sign up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Chưa có tài khoản? ',
                          style: TextStyle(color: AppTheme.brandTextSecondary),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/register'),
                          child: const Text(
                            'Đăng ký ngay',
                            style: TextStyle(
                              color: AppTheme.brandPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
