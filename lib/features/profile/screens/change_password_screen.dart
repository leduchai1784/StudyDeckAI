import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../services/user_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final UserService _userService = UserService();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  // Generator State matching App Theme UI
  bool _showGenerator = false;
  bool _obscureGeneratedPassword = false;
  double _passwordLength = 12.0;
  bool _includeNumbers = true;
  bool _includeLowercase = true;
  bool _includeUppercase = true;
  bool _includeSymbols = true;
  bool _hasSavedPassword = false;
  String _generatedPassword = '';

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Generate random password dynamically based on selected checkboxes and length
  void _generateRandomPassword() {
    final length = _passwordLength.round();
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const digits = '0123456789';
    const symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String allowedChars = '';
    final requiredChars = <String>[];
    final rand = Random.secure();

    if (_includeUppercase) {
      allowedChars += uppercase;
      requiredChars.add(uppercase[rand.nextInt(uppercase.length)]);
    }
    if (_includeLowercase) {
      allowedChars += lowercase;
      requiredChars.add(lowercase[rand.nextInt(lowercase.length)]);
    }
    if (_includeNumbers) {
      allowedChars += digits;
      requiredChars.add(digits[rand.nextInt(digits.length)]);
    }
    if (_includeSymbols) {
      allowedChars += symbols;
      requiredChars.add(symbols[rand.nextInt(symbols.length)]);
    }

    if (allowedChars.isEmpty) {
      allowedChars = lowercase + digits;
      requiredChars.add(lowercase[rand.nextInt(lowercase.length)]);
    }

    final chars = List<String>.from(requiredChars);
    while (chars.length < length) {
      chars.add(allowedChars[rand.nextInt(allowedChars.length)]);
    }

    chars.shuffle(rand);
    setState(() {
      _generatedPassword = chars.join();
      _hasSavedPassword = false; // Reset confirmation when password regenerated
    });
  }

  Future<void> _handleChangePassword() async {
    final oldPass = _oldPasswordController.text;
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đầy đủ Mật khẩu hiện tại và Mật khẩu mới.'),
          backgroundColor: AppTheme.brandAccent,
        ),
      );
      return;
    }

    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu xác nhận không trùng khớp.'),
          backgroundColor: AppTheme.brandError,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final res = await _userService.updatePassword(
      oldPassword: oldPass,
      password: newPass,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Cập nhật mật khẩu thành công!'),
          backgroundColor: AppTheme.brandSuccess,
        ),
      );
      context.pop();
    } else {
      final msg = res['message'] as String? ?? 'Đổi mật khẩu thất bại. Mật khẩu cũ không chính xác.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ $msg'),
          backgroundColor: AppTheme.brandError,
        ),
      );
    }
  }

  InputDecoration _buildPasswordInputDecoration({
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppTheme.brandTextMuted),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppTheme.brandSurface,
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
        title: const Text('Đổi Mật Khẩu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppTheme.brandSurface,
        foregroundColor: AppTheme.brandTextPrimary,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppTheme.brandBorder, height: 1),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.brandSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.brandBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mật khẩu hiện tại
                    const Text('Mật khẩu hiện tại', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.brandTextPrimary)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _oldPasswordController,
                      obscureText: _obscureOld,
                      style: const TextStyle(color: AppTheme.brandTextPrimary),
                      decoration: _buildPasswordInputDecoration(
                        hintText: 'Nhập mật khẩu hiện tại',
                        prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.brandTextMuted),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureOld ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppTheme.brandTextMuted),
                          onPressed: () => setState(() => _obscureOld = !_obscureOld),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Mật khẩu mới Header & Small Top-Right Trigger Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Mật khẩu mới', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.brandTextPrimary)),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _showGenerator = !_showGenerator;
                              if (_showGenerator && _generatedPassword.isEmpty) {
                                _generateRandomPassword();
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: _showGenerator ? AppTheme.chipIndigoBg : AppTheme.brandBackground,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: _showGenerator ? AppTheme.brandPrimary : AppTheme.brandBorder),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _showGenerator ? Icons.keyboard_arrow_up : Icons.auto_awesome,
                                  size: 14,
                                  color: AppTheme.brandPrimary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _showGenerator ? 'Đóng' : 'Sinh mật khẩu ngẫu nhiên 🎲',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Dropdown Popup matching Template UI & App Theme
                    if (_showGenerator) _buildPasswordGeneratorDropdown(),

                    // Mật khẩu mới TextField
                    TextField(
                      controller: _newPasswordController,
                      obscureText: _obscureNew,
                      style: const TextStyle(color: AppTheme.brandTextPrimary),
                      decoration: _buildPasswordInputDecoration(
                        hintText: 'Nhập hoặc sinh mật khẩu mới',
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.lock_outline, color: AppTheme.brandTextMuted),
                          onPressed: () {
                            setState(() {
                              _showGenerator = !_showGenerator;
                              if (_showGenerator && _generatedPassword.isEmpty) {
                                _generateRandomPassword();
                              }
                            });
                          },
                          tooltip: 'Sinh mật khẩu ngẫu nhiên',
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureNew ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppTheme.brandTextMuted),
                          onPressed: () => setState(() => _obscureNew = !_obscureNew),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Xác nhận mật khẩu mới
                    const Text('Xác nhận mật khẩu mới', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.brandTextPrimary)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirm,
                      style: const TextStyle(color: AppTheme.brandTextPrimary),
                      decoration: _buildPasswordInputDecoration(
                        hintText: 'Nhập lại mật khẩu mới',
                        prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.brandTextMuted),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppTheme.brandTextMuted),
                          onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleChangePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.brandPrimary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                              )
                            : const Text('Cập Nhật Mật Khẩu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
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

  // Template-matched Dropdown Popup Widget (Without "Generate Password" header and "X" close button)
  Widget _buildPasswordGeneratorDropdown() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.brandSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.brandBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Password Display Box with Eye and Copy Icons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.brandBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.brandBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _obscureGeneratedPassword ? '•' * _generatedPassword.length : _generatedPassword,
                    style: TextStyle(
                      fontFamily: _obscureGeneratedPassword ? null : 'monospace',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brandTextPrimary,
                      letterSpacing: _obscureGeneratedPassword ? 2.0 : 1.1,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _obscureGeneratedPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: AppTheme.brandTextMuted,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscureGeneratedPassword = !_obscureGeneratedPassword),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.copy, color: AppTheme.brandPrimary, size: 20),
                  onPressed: () {
                    if (_generatedPassword.isNotEmpty) {
                      Clipboard.setData(ClipboardData(text: _generatedPassword));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('📋 Đã sao chép mật khẩu vào bộ nhớ tạm!'),
                          backgroundColor: AppTheme.brandPrimary,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. SỐ LƯỢNG KÝ TỰ & Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SỐ LƯỢNG KÝ TỰ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brandTextMuted,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '${_passwordLength.round()}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brandTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.brandPrimary,
              inactiveTrackColor: AppTheme.brandBorder,
              thumbColor: AppTheme.brandPrimary,
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: _passwordLength,
              min: 8.0,
              max: 32.0,
              divisions: 24,
              onChanged: (val) {
                setState(() {
                  _passwordLength = val;
                  _generateRandomPassword();
                });
              },
            ),
          ),
          const SizedBox(height: 12),

          // 3. Character Set Options Checkboxes
          _buildCheckboxOption(
            label: 'Có ký tự số',
            value: _includeNumbers,
            onChanged: (val) {
              setState(() {
                _includeNumbers = val ?? true;
                _generateRandomPassword();
              });
            },
          ),
          _buildCheckboxOption(
            label: 'Có ký tự thường',
            value: _includeLowercase,
            onChanged: (val) {
              setState(() {
                _includeLowercase = val ?? true;
                _generateRandomPassword();
              });
            },
          ),
          _buildCheckboxOption(
            label: 'Có ký tự hoa',
            value: _includeUppercase,
            onChanged: (val) {
              setState(() {
                _includeUppercase = val ?? true;
                _generateRandomPassword();
              });
            },
          ),
          _buildCheckboxOption(
            label: 'Có ký tự đặc biệt',
            value: _includeSymbols,
            onChanged: (val) {
              setState(() {
                _includeSymbols = val ?? true;
                _generateRandomPassword();
              });
            },
          ),
          const SizedBox(height: 16),
          const Divider(color: AppTheme.brandBorder, thickness: 1),
          const SizedBox(height: 12),

          // 4. Tích xác nhận "Tôi đã lưu lại mật khẩu mới"
          InkWell(
            onTap: () => setState(() => _hasSavedPassword = !_hasSavedPassword),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: Checkbox(
                      value: _hasSavedPassword,
                      activeColor: AppTheme.brandPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      side: const BorderSide(color: AppTheme.brandBorder, width: 1.5),
                      onChanged: (val) => setState(() => _hasSavedPassword = val ?? false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Tôi đã lưu lại mật khẩu mới',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.brandTextPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 5. Nút "Xác nhận" (Tự động copy & điền vào cả 2 ô Mật khẩu mới & Xác nhận mật khẩu)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _hasSavedPassword
                  ? () {
                      Clipboard.setData(ClipboardData(text: _generatedPassword));
                      setState(() {
                        _newPasswordController.text = _generatedPassword;
                        _confirmPasswordController.text = _generatedPassword;
                        _obscureNew = false;
                        _obscureConfirm = false;
                        _showGenerator = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('🎉 Đã sao chép & áp dụng mật khẩu mới thành công!'),
                          backgroundColor: AppTheme.brandSuccess,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.brandPrimary,
                disabledBackgroundColor: AppTheme.brandBackground,
                disabledForegroundColor: AppTheme.brandTextMuted,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Xác nhận',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxOption({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: value,
                activeColor: AppTheme.brandPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                side: const BorderSide(color: AppTheme.brandBorder, width: 1.5),
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.brandTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
