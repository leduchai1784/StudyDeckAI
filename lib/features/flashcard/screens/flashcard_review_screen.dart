import 'package:flutter/material.dart';

class FlashcardReviewScreen extends StatelessWidget {
  const FlashcardReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ôn tập Flashcard (SM-2)')),
      body: const Center(child: Text('Flashcard Review Screen')),
    );
  }
}
