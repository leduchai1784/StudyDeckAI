import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/supabase_tables.dart';
import '../core/network/supabase_service.dart';
import '../models/user.dart';

class AuthService {
  final SupabaseClient _client = SupabaseService.instance.client;
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    ),
  );

  User? get currentSupabaseUser => _client.auth.currentUser;
  Session? get currentSession => _client.auth.currentSession;
  bool get isAuthenticated => _client.auth.currentUser != null;

  // Check if session is persisted and active
  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('nks_access_token');
    if (token != null && token.isNotEmpty) {
      return true;
    }
    return isAuthenticated;
  }

  // Manage maximum 3 saved accounts in SharedPreferences
  Future<List<Map<String, dynamic>>> getSavedAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('saved_accounts_list');
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final List<dynamic> rawList = jsonDecode(jsonString);
        return rawList.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      } catch (_) {}
    }
    return [];
  }

  Future<void> saveAccount({
    required String usernameOrEmail,
    required String name,
    String? avatar,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final currentList = await getSavedAccounts();

    // Remove if account with same email already exists
    currentList.removeWhere(
      (acc) => (acc['email'] as String? ?? '').toLowerCase() == usernameOrEmail.toLowerCase().trim(),
    );

    // Insert new account at top (index 0)
    currentList.insert(0, {
      'email': usernameOrEmail.trim(),
      'name': name,
      'avatar': avatar ?? '',
      'lastLogin': DateTime.now().toIso8601String(),
    });

    // Enforce strict limit: Maximum 3 saved accounts!
    final limitedList = currentList.take(3).toList();

    await prefs.setString('saved_accounts_list', jsonEncode(limitedList));
  }

  Future<void> removeSavedAccount(String usernameOrEmail) async {
    final prefs = await SharedPreferences.getInstance();
    final currentList = await getSavedAccounts();

    currentList.removeWhere(
      (acc) => (acc['email'] as String? ?? '').toLowerCase() == usernameOrEmail.toLowerCase().trim(),
    );

    await prefs.setString('saved_accounts_list', jsonEncode(currentList));
  }

  // NKS System API Login (https://account.nks.vn/api/nks/user/login)
  // Note: Request param key is 'username', which accepts email/username input for ALL valid accounts
  Future<Map<String, dynamic>> loginWithNksApi({
    required String usernameOrEmail,
    required String password,
    bool rememberMe = true,
  }) async {
    try {
      final response = await _dio.post(
        'https://account.nks.vn/api/nks/user/login',
        data: {
          'username': usernameOrEmail.trim(),
          'password': password,
        },
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {'Accept': 'application/json'},
        ),
      );

      final dynamic rawData = response.data;
      Map<String, dynamic> responseData;
      if (rawData is Map<String, dynamic>) {
        responseData = rawData;
      } else if (rawData is Map) {
        responseData = Map<String, dynamic>.from(rawData);
      } else if (rawData is String) {
        try {
          final decoded = jsonDecode(rawData);
          responseData = decoded is Map<String, dynamic>
              ? decoded
              : Map<String, dynamic>.from(decoded as Map);
        } catch (_) {
          return {
            'success': false,
            'message': 'Phản hồi từ máy chủ không đúng định dạng.',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Không thể đọc dữ liệu phản hồi từ máy chủ.',
        };
      }

      if (responseData['success'] == true && responseData['data'] != null) {
        final dataMap = responseData['data'] is Map
            ? Map<String, dynamic>.from(responseData['data'] as Map)
            : null;
        final accessToken = (dataMap?['access_token'] as String?) ?? (dataMap?['token'] as String?);

        Map<String, dynamic>? userData;
        if (dataMap != null) {
          if (dataMap['user'] is Map) {
            userData = Map<String, dynamic>.from(dataMap['user'] as Map);
          } else {
            userData = dataMap;
          }
        }

        final prefs = await SharedPreferences.getInstance();
        if (accessToken != null && accessToken.isNotEmpty) {
          await prefs.setString('nks_access_token', accessToken);
        }

        if (userData != null) {
          final first = userData['firstname'] as String? ?? '';
          final last = userData['lastname'] as String? ?? '';
          final combinedName = '$first $last'.trim();

          final userName = (userData['name'] as String?) ??
              (combinedName.isNotEmpty ? combinedName : 'Thành viên StudyDeck');
          final userEmail = (userData['email'] as String?) ?? usernameOrEmail.trim();
          final userAvatar = (userData['avatar'] as String?) ?? '';

          await prefs.setString('user_name', userName);
          await prefs.setString('user_email', userEmail);
          await prefs.setString('user_avatar', userAvatar);

          // Save account ONLY if Remember Me checkbox is checked (limit max 3)
          if (rememberMe) {
            await saveAccount(
              usernameOrEmail: userEmail,
              name: userName,
              avatar: userAvatar,
            );
          }

          // Optionally sync user profile with Supabase 'users' table
          try {
            await _client.from(SupabaseTables.users).upsert({
              'email': userEmail,
              'full_name': userName,
              'avatar_url': userAvatar,
              'last_login_at': DateTime.now().toIso8601String(),
            });
          } catch (_) {
            // Ignore if Supabase RLS requires auth session
          }
        }
      }

      return responseData;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final dynamic errData = e.response!.data;
        if (errData is Map<String, dynamic>) {
          return errData;
        } else if (errData is Map) {
          return Map<String, dynamic>.from(errData);
        } else if (errData is String) {
          try {
            final decoded = jsonDecode(errData);
            if (decoded is Map<String, dynamic>) return decoded;
            if (decoded is Map) return Map<String, dynamic>.from(decoded);
          } catch (_) {}
        }
      }
      String friendlyMessage = 'Không thể kết nối đến máy chủ NKS. Vui lòng kiểm tra lại kết nối mạng.';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        friendlyMessage = 'Kết nối mạng quá thời gian chờ (timeout). Vui lòng thử lại sau giây lát.';
      } else if (e.type == DioExceptionType.connectionError) {
        friendlyMessage = 'Không thể kết nối máy chủ (Failed host lookup/lỗi mạng). Vui lòng kiểm tra kết nối Internet trên thiết bị.';
      } else if (e.message != null && e.message!.isNotEmpty) {
        friendlyMessage = e.message!;
      }
      return {
        'success': false,
        'message': friendlyMessage,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Đã xảy ra lỗi không xác định: $e',
      };
    }
  }

  // Sign Up with Email and Password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );

    if (response.user != null) {
      // Sync profile with 'users' table
      await _client.from(SupabaseTables.users).upsert({
        'id': response.user!.id,
        'email': email,
        'full_name': fullName,
        'role': 'Learner',
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    return response;
  }

  // Sign In with Email and Password (Supabase Auth Fallback)
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user != null) {
      await _client.from(SupabaseTables.users).update({
        'last_login_at': DateTime.now().toIso8601String(),
      }).eq('id', response.user!.id);
    }

    return response;
  }

  // Sign In with OAuth (Google)
  Future<bool> signInWithGoogle() async {
    return await _client.auth.signInWithOAuth(
      OAuthProvider.google,
    );
  }

  // Sign Out (Clear active session token & user info)
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('nks_access_token');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_avatar');
    await _client.auth.signOut();
  }

  // Get current user model profile
  Future<UserModel?> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final nksName = prefs.getString('user_name');
    final nksEmail = prefs.getString('user_email');
    final nksAvatar = prefs.getString('user_avatar');

    if (nksEmail != null && nksEmail.isNotEmpty) {
      return UserModel(
        id: 'nks_user',
        email: nksEmail,
        fullName: nksName,
        avatarUrl: nksAvatar,
        role: 'Learner',
      );
    }

    final user = currentSupabaseUser;
    if (user == null) return null;

    final response = await _client
        .from(SupabaseTables.users)
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (response != null) {
      return UserModel.fromJson(response);
    }
    return null;
  }
}
