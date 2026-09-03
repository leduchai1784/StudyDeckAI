import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Web Admin Dashboard')),
      body: const Center(child: Text('Bảng điều khiển Quản trị viên')),
    );
  }
}
