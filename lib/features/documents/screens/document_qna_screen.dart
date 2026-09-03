import 'package:flutter/material.dart';

class DocumentQnaScreen extends StatelessWidget {
  const DocumentQnaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hỏi đáp Tài liệu RAG')),
      body: const Center(child: Text('Document QnA Screen')),
    );
  }
}
