import 'package:flutter/material.dart';

class DeckDetailScreen extends StatelessWidget {
  const DeckDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết Bộ thẻ')),
      body: const Center(child: Text('Deck Detail Screen')),
    );
  }
}
