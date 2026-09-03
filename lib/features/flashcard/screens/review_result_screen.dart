import 'package:flutter/material.dart';

class ReviewResultScreen extends StatelessWidget {
  const ReviewResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kết quả phiên ôn tập')),
      body: const Center(child: Text('Review Result Screen')),
    );
  }
}
