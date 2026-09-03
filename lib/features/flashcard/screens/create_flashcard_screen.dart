import 'package:flutter/material.dart';

class CreateFlashcardScreen extends StatelessWidget {
  const CreateFlashcardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tạo thẻ Flashcard mới')),
      body: const Center(child: Text('Create Flashcard Screen')),
    );
  }
}
