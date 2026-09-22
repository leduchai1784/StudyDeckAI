import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    ),
  );

  // Helper to safely extract user data map regardless of response wrapping format
  Map<String, dynamic>? parseUserData(Map<String, dynamic> responseData) {
    dynamic target = responseData['data'];
    if (target == null) {
      if (responseData['user'] is Map<String, dynamic>) {
        return responseData['user'] as Map<String, dynamic>;
      }
      if (responseData['result'] is Map<String, dynamic>) {
        return responseData['result'] as Map<String, dynamic>;
      }
      return responseData;
    }
    if (target is Map<String, dynamic>) {
      if (target['user'] is Map<String, dynamic>) {
        return target['user'] as Map<String, dynamic>;
      }
      if (target['profile'] is Map<String, dynamic>) {
        return target['profile'] as Map<String, dynamic>;
      }
      if (target['info'] is Map<String, dynamic>) {
        return target['info'] as Map<String, dynamic>;
      }
      if (target['data'] is Map<String, dynamic>) {
        return target['data'] as Map<String, dynamic>;
      }
      return target;
    }
    return null;
  }

  // Helper to get stored access token
  Future<String?> _getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nks_access_token');
  }

  // 1. Lấy thông tin thành viên (POST https://account.nks.vn/api/nks/user)
  Future<Map<String, dynamic>> getUserInfo({String? accessToken}) async {
    try {
      final token = accessToken ?? await _getStoredToken();
      if (token == null || token.isEmpty) {
        return {'success': false, 'message': 'Chưa đăng nhập hoặc thiếu access_token'};
      }

      final response = await _dio.post(
        'https://account.nks.vn/api/nks/user',
        data: {'access_token': token},
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {'Accept': 'application/json'},
        ),
      );

      final responseData = response.data as Map<String, dynamic>;
      if (responseData['success'] == true && responseData['data'] != null) {
        final userData = parseUserData(responseData);
        if (userData != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_name', userData['name'] ?? '');
          await prefs.setString('user_email', userData['email'] ?? '');
          await prefs.setString('user_avatar', userData['avatar'] ?? '');
        }
      }

      return responseData;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        return e.response!.data as Map<String, dynamic>;
      }
      return {'success': false, 'message': e.message ?? 'Lỗi kết nối máy chủ.'};
    } catch (e) {
      return {'success': false, 'message': 'Lỗi không xác định: $e'};
    }
  }

  // 2. Cập nhật thông tin thành viên (POST https://account.nks.vn/api/nks/user/updateInfo)
  Future<Map<String, dynamic>> updateUserInfo({
    String? accessToken,
    required String firstname,
    required String lastname,
    String? intro,
    String? phone,
    int? gender, // 0 | 1
    String? website,
    String? dob, // yyyy-mm-dd
    String? pob,
    String? idNumber,
    String? idDate,
    String? idPlace,
    String? province,
  }) async {
    try {
      final token = accessToken ?? await _getStoredToken();
      if (token == null || token.isEmpty) {
        return {'success': false, 'message': 'Chưa đăng nhập hoặc thiếu access_token'};
      }

      final payload = <String, dynamic>{
        'access_token': token,
        'firstname': firstname,
        'lastname': lastname,
        if (intro != null) 'intro': intro,
        if (phone != null) 'phone': phone,
        if (gender != null) 'gender': gender,
        if (website != null) 'website': website,
        if (dob != null) 'dob': dob,
        if (pob != null) 'pob': pob,
        if (idNumber != null) 'id_number': idNumber,
        if (idDate != null) 'id_date': idDate,
        if (idPlace != null) 'id_place': idPlace,
        if (province != null) 'province': province,
      };

      final response = await _dio.post(
        'https://account.nks.vn/api/nks/user/updateInfo',
        data: payload,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {'Accept': 'application/json'},
        ),
      );

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] == true && responseData['data'] != null) {
        final userData = parseUserData(responseData);
        if (userData != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_name', userData['name'] ?? '$firstname $lastname');
        }
      }

      return responseData;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        return e.response!.data as Map<String, dynamic>;
      }
      return {'success': false, 'message': e.message ?? 'Lỗi cập nhật thông tin.'};
    } catch (e) {
      return {'success': false, 'message': 'Lỗi không xác định: $e'};
    }
  }

  // 3. Cập nhật thông tin mật khẩu (POST https://account.nks.vn/api/nks/user/updatePass)
  Future<Map<String, dynamic>> updatePassword({
    String? accessToken,
    required String oldPassword,
    required String password,
  }) async {
    try {
      final token = accessToken ?? await _getStoredToken();
      if (token == null || token.isEmpty) {
        return {'success': false, 'message': 'Chưa đăng nhập hoặc thiếu access_token'};
      }

      final response = await _dio.post(
        'https://account.nks.vn/api/nks/user/updatePass',
        data: {
          'access_token': token,
          'old_password': oldPassword,
          'password': password,
        },
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {'Accept': 'application/json'},
        ),
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        return e.response!.data as Map<String, dynamic>;
      }
      return {'success': false, 'message': e.message ?? 'Lỗi cập nhật mật khẩu.'};
    } catch (e) {
      return {'success': false, 'message': 'Lỗi không xác định: $e'};
    }
  }

  // 4. Cập nhật ảnh đại diện (POST https://account.nks.vn/api/nks/user/updateAvatar)
  Future<Map<String, dynamic>> updateAvatar({
    String? accessToken,
    required String base64Avatar,
  }) async {
    try {
      final token = accessToken ?? await _getStoredToken();
      if (token == null || token.isEmpty) {
        return {'success': false, 'message': 'Chưa đăng nhập hoặc thiếu access_token'};
      }

      final response = await _dio.post(
        'https://account.nks.vn/api/nks/user/updateAvatar',
        data: {
          'access_token': token,
          'avatar': base64Avatar,
        },
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {'Accept': 'application/json'},
        ),
      );

      final responseData = response.data as Map<String, dynamic>;
      if (responseData['success'] == true && responseData['data'] != null) {
        final userData = parseUserData(responseData);
        final newAvatarUrl = userData?['avatar'] as String?;
        if (newAvatarUrl != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_avatar', newAvatarUrl);
        }
      }

      return responseData;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        return e.response!.data as Map<String, dynamic>;
      }
      return {'success': false, 'message': e.message ?? 'Lỗi cập nhật avatar.'};
    } catch (e) {
      return {'success': false, 'message': 'Lỗi không xác định: $e'};
    }
  }

  // 5. Cập nhật CCCD (POST https://account.nks.vn/api/nks/user/updateCccd)
  Future<Map<String, dynamic>> updateCccd({
    String? accessToken,
    String? frontBase64,
    String? backBase64,
    String? number,
    String? date,
    String? place,
  }) async {
    try {
      final token = accessToken ?? await _getStoredToken();
      if (token == null || token.isEmpty) {
        return {'success': false, 'message': 'Chưa đăng nhập hoặc thiếu access_token'};
      }

      final payload = <String, dynamic>{
        'access_token': token,
        if (frontBase64 != null) 'front': frontBase64,
        if (backBase64 != null) 'back': backBase64,
        if (number != null) 'number': number,
        if (date != null) 'date': date,
        if (place != null) 'place': place,
      };

      final response = await _dio.post(
        'https://account.nks.vn/api/nks/user/updateCccd',
        data: payload,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {'Accept': 'application/json'},
        ),
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        return e.response!.data as Map<String, dynamic>;
      }
      return {'success': false, 'message': e.message ?? 'Lỗi cập nhật CCCD.'};
    } catch (e) {
      return {'success': false, 'message': 'Lỗi không xác định: $e'};
    }
  }
}
