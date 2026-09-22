import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../network/supabase_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Register Supabase Client Singleton
  getIt.registerLazySingleton<SupabaseClient>(() => SupabaseService.instance.client);
  getIt.registerLazySingleton<SupabaseService>(() => SupabaseService.instance);
}
