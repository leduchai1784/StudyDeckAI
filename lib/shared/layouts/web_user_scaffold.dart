import 'package:flutter/material.dart';

class WebUserScaffold extends StatelessWidget {
  final Widget child;

  const WebUserScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.home), label: Text('Trang chủ')),
              NavigationRailDestination(icon: Icon(Icons.style), label: Text('Bộ thẻ')),
              NavigationRailDestination(icon: Icon(Icons.menu_book), label: Text('Bài học')),
              NavigationRailDestination(icon: Icon(Icons.smart_toy), label: Text('AI Tutor')),
              NavigationRailDestination(icon: Icon(Icons.person), label: Text('Hồ sơ')),
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
