class AvatarHelper {
  /// Format and sanitize raw avatar URLs returned from the API
  /// Handles double slashes (e.g. https://data.nks.vn//storage/...), relative paths, etc.
  static String? formatUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.trim().isEmpty) return null;
    String url = rawUrl.trim();

    // Fix double slashes in domain/path
    url = url.replaceAll('https://data.nks.vn//', 'https://data.nks.vn/');
    url = url.replaceAll('http://data.nks.vn//', 'http://data.nks.vn/');
    url = url.replaceAll('data.nks.vn//', 'data.nks.vn/');

    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }

    if (url.startsWith('/')) {
      return 'https://data.nks.vn$url';
    }

    return 'https://data.nks.vn/$url';
  }
}
