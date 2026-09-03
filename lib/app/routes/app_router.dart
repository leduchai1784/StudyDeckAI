import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app.dart';
import 'user_routes.dart';
import 'admin_routes.dart';

class AppRouter {
  static GoRouter getRouter(AppFlavor flavor) {
    return GoRouter(
      initialLocation: flavor == AppFlavor.admin ? '/admin/dashboard' : '/onboarding',
      routes: flavor == AppFlavor.admin ? adminRoutes : userRoutes,
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Trang không tồn tại: ${state.uri.path}'),
        ),
      ),
    );
  }
}
