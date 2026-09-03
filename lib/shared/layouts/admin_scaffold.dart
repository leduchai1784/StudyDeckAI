import 'package:flutter/material.dart';

class AdminScaffold extends StatelessWidget {
  final Widget child;

  const AdminScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: true,
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Dashboard')),
              NavigationRailDestination(icon: Icon(Icons.people), label: Text('Người dùng')),
              NavigationRailDestination(icon: Icon(Icons.book), label: Text('Bài học')),
              NavigationRailDestination(icon: Icon(Icons.fact_check), label: Text('Kiểm duyệt AI')),
              NavigationRailDestination(icon: Icon(Icons.bar_chart), label: Text('Thống kê')),
            ],
            selectedIndex: 0,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}
