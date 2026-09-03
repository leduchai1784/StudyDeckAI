import 'package:go_router/go_router.dart';
import '../../admin/dashboard/screens/admin_dashboard_screen.dart';
import '../../shared/layouts/admin_scaffold.dart';

final List<RouteBase> adminRoutes = [
  GoRoute(
    path: '/admin/dashboard',
    builder: (context, state) => const AdminScaffold(child: AdminDashboardScreen()),
  ),
];
