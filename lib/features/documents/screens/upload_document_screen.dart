import 'package:flutter/material.dart';

class UploadDocumentScreen extends StatelessWidget {
  const UploadDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tải lên Tài liệu')),
      body: const Center(child: Text('Upload Document Screen (Drag & Drop on Web)')),
    );
  }
}
