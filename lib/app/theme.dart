import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ============================================================
  // StudyDeck Design System Core Tokens (design-system.md)
  // ============================================================
  static const Color primary = Color(0xFF4F46E5);           // Indigo — CTA chính, active state
  static const Color primaryContainer = Color(0xFF4F46E5);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFC7D2FE);

  static const Color secondary = Color(0xFF525D83);
  static const Color secondaryContainer = Color(0xFFC8D3FF);
  static const Color onSecondaryContainer = Color(0xFF4F5A80);

  static const Color tertiary = Color(0xFF684000);
  static const Color tertiaryFixedDim = Color(0xFFFFB95F);
  static const Color tertiaryContainer = Color(0xFF885500);

  static const Color background = Color(0xFFF9FAFB);        // Nền màn hình mặc định (#F9FAFB)
  static const Color surface = Color(0xFFFFFFFF);           // Nền card, surface (#FFFFFF)
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF6F2FF);
  static const Color surfaceContainer = Color(0xFFEFEBFF);
  static const Color surfaceContainerHigh = Color(0xFFE9E5FF);
  static const Color surfaceContainerHighest = Color(0xFFE3DFFF);

  static const Color onSurface = Color(0xFF1E1B4B);
  static const Color onSurfaceVariant = Color(0xFF6B7280);
  static const Color outline = Color(0xFF9AA0AE);
  static const Color outlineVariant = Color(0xFFE2E2EA);
  static const Color error = Color(0xFFEF4444);

  // ============================================================
  // StudyDeck Brand Palette (Theo bảng màu chuẩn thiết kế)
  // ============================================================
  static const Color brandPrimary = Color(0xFF4F46E5);      // Nút chính, thanh điều hướng, logo
  static const Color brandPrimaryLight = Color(0xFFC7D2FE); // Nền avatar, hover state
  static const Color brandAccent = Color(0xFFF59E0B);       // Amber — streak, nhắc nhở, huy hiệu AI
  static const Color brandAccentLight = Color(0xFFFAEEDA);  // Nền pill streak, chip nhắc nhở
  static const Color brandSuccess = Color(0xFF10B981);      // Đáp án đúng, hoàn thành nhiệm vụ
  static const Color brandError = Color(0xFFEF4444);        // Đáp án sai, cảnh báo
  static const Color brandTextPrimary = Color(0xFF1E1B4B);  // Tiêu đề, văn bản quan trọng
  static const Color brandTextSecondary = Color(0xFF6B7280);// Mô tả phụ, placeholder
  static const Color brandTextMuted = Color(0xFF9AA0AE);    // Caption, timestamp, icon inactive
  static const Color brandBackground = Color(0xFFF9FAFB);   // Nền màn hình mặc định
  static const Color brandSurface = Color(0xFFFFFFFF);      // Nền card mặc định
  static const Color brandBorder = Color(0xFFE2E2EA);       // Viền card 1px mặc định

  // 4 Pastel Tints (design-system.md section 1.2)
  static const Color tintIndigoBg = Color(0xFFEAF2FE);
  static const Color tintIndigoText = Color(0xFF2563EB);
  static const Color tintGreenBg = Color(0xFFE9F7EF);
  static const Color tintGreenText = Color(0xFF0F9D58);
  static const Color tintAmberBg = Color(0xFFFDF1DD);
  static const Color tintAmberText = Color(0xFFB45309);
  static const Color tintPurpleBg = Color(0xFFF3EAFB);
  static const Color tintPurpleText = Color(0xFF7C3AED);
  static const Color chipIndigoBg = Color(0xFFEEEDFE);
  static const Color chipIndigoText = Color(0xFF4F46E5);

  // Standard Border Radius Tokens (design-system.md section 3)
  static const double radiusXs = 6.0;   // Badge nhỏ, tag
  static const double radiusSm = 8.0;   // Nút bấm, icon-chip nhỏ
  static const double radiusMd = 12.0;  // Card nội dung, icon-chip lớn
  static const double radiusLg = 14.0;  // Card nổi bật, thẻ pastel
  static const double radiusXl = 20.0;  // Khung ngoài cùng, modal lớn
  static const double radiusFull = 999.0;// Pill/badge tròn hoàn toàn

  /// Phonetic / IPA text style ensuring complete support for IPA Extension characters
  /// (e.g. /jʌŋ/, /əˈdʒʌst/, /æ/, /θ/, /ʃ/, /ʒ/, etc.) without missing-glyph tofu boxes.
  static TextStyle ipaStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w500,
    Color? color,
    double? letterSpacing,
  }) {
    return GoogleFonts.notoSans(
      textStyle: const TextStyle(
        fontFamilyFallback: [
          'Segoe UI',
          'Roboto',
          'Lucida Sans Unicode',
          'Arial Unicode MS',
          'sans-serif',
        ],
      ),
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? onSurfaceVariant,
      letterSpacing: letterSpacing ?? 0.5,
    );
  }

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.beVietnamProTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: Color(0xFFFFFFFF),
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: Color(0xFFFFFFFF),
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
        error: error,
        onError: Color(0xFFFFFFFF),
      ),
      scaffoldBackgroundColor: surface,
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: onSurface,
        ),
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: onSurface,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: onSurface,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          fontSize: 18,
          color: onSurface,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          fontSize: 16,
          color: onSurfaceVariant,
        ),
        labelLarge: baseTextTheme.labelLarge?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryContainer,
          foregroundColor: onPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.beVietnamPro(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: Color(0xFFC3C0FF)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.beVietnamPro(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.beVietnamPro(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: outlineVariant.withValues(alpha: 0.3)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: outlineVariant.withValues(alpha: 0.4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: outlineVariant.withValues(alpha: 0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryContainer, width: 1.5),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get darkTheme {
    return lightTheme; // Defaulting dark theme to inherit light for consistent design
  }
}

