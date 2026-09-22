import 'package:supabase_flutter/supabase_flutter.dart';
import '../../app/config/supabase_config.dart';
import '../utils/logger.dart';

class SupabaseService {
  static SupabaseService? _instance;

  SupabaseService._();

  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }

  static Future<void> init() async {
    try {
      await Supabase.initialize(
        url: SupabaseConfig.url,
        // ignore: deprecated_member_use
        anonKey: SupabaseConfig.anonKey,
        debug: false,
      );
      AppLogger.log('Supabase successfully initialized with URL: ${SupabaseConfig.url}');
    } catch (e) {
      AppLogger.log('Failed to initialize Supabase: $e');
    }
  }

  SupabaseClient get client => Supabase.instance.client;
  GoTrueClient get auth => Supabase.instance.client.auth;
  SupabaseStorageClient get storage => Supabase.instance.client.storage;
}
