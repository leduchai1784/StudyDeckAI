import 'package:flutter/material.dart';
import 'theme.dart';
import 'routes/app_router.dart';

enum AppFlavor { mobile, web, admin }

class StudyDeckApp extends StatelessWidget {
  final AppFlavor flavor;

  const StudyDeckApp({super.key, required this.flavor});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.getRouter(flavor);

    return MaterialApp.router(
      title: _getAppTitle(flavor),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }

  String _getAppTitle(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.mobile:
        return 'StudyDeckAI Mobile';
      case AppFlavor.web:
        return 'StudyDeckAI Web';
      case AppFlavor.admin:
        return 'StudyDeckAI Admin';
    }
  }
}
