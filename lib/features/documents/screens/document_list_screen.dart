import 'package:flutter/material.dart';

class DocumentListScreen extends StatelessWidget {
  const DocumentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tài liệu RAG')),
      body: const Center(child: Text('Document List Screen')),
    );
  }
}
