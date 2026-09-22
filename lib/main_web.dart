import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/network/supabase_service.dart';
import 'core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.init();
  await setupServiceLocator();
  runApp(const StudyDeckApp(flavor: AppFlavor.web));
}
