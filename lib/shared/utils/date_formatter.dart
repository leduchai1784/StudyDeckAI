class DateFormatter {
  /// Chuyển đổi định dạng ngày bất kỳ (VD: 2004-08-17 hoặc 2004-08-17T00:00:00Z)
  /// sang chuẩn Ngày / Tháng / Năm (dd/mm/yyyy - VD: 17/08/2004) để hiển thị trong App.
  static String toDisplayDate(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) return '';
    final str = rawDate.trim();

    // Nếu đã ở dạng dd/mm/yyyy thì giữ nguyên
    if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(str)) {
      return str;
    }

    // Nếu ở dạng yyyy-mm-dd
    if (RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(str)) {
      final cleanDate = str.split('T').first;
      final parts = cleanDate.split('-');
      if (parts.length == 3) {
        final year = parts[0];
        final month = parts[1].padLeft(2, '0');
        final day = parts[2].padLeft(2, '0');
        return '$day/$month/$year';
      }
    }

    return str;
  }

  /// Chuyển đổi Ngày / Tháng / Năm (dd/mm/yyyy) khi người dùng nhập
  /// sang chuẩn yyyy-mm-dd để gửi lên API backend.
  static String toApiDate(String? displayDate) {
    if (displayDate == null || displayDate.trim().isEmpty) return '';
    final str = displayDate.trim();

    // Nếu ở dạng dd/mm/yyyy
    if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(str)) {
      final parts = str.split('/');
      if (parts.length == 3) {
        final day = parts[0].padLeft(2, '0');
        final month = parts[1].padLeft(2, '0');
        final year = parts[2];
        return '$year-$month-$day';
      }
    }

    return str;
  }
}
