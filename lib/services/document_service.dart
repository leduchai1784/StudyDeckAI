import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/supabase_tables.dart';
import '../core/network/supabase_service.dart';
import '../models/document.dart';

class DocumentService {
  final SupabaseClient _client = SupabaseService.instance.client;

  // Fetch documents uploaded by user
  Future<List<DocumentModel>> fetchUserDocuments(String userId) async {
    final response = await _client
        .from(SupabaseTables.documents)
        .select()
        .eq('user_id', userId)
        .order('uploaded_at', ascending: false);

    return (response as List).map((json) => DocumentModel.fromJson(json)).toList();
  }

  // Insert new document record for RAG processing
  Future<DocumentModel> createDocumentRecord({
    required String userId,
    required String fileName,
    required String filePath,
    required String fileType,
    int? fileSize,
  }) async {
    final response = await _client
        .from(SupabaseTables.documents)
        .insert({
          'user_id': userId,
          'file_name': fileName,
          'file_path': filePath,
          'file_type': fileType,
          'file_size': fileSize,
          'status': 'processing',
          'uploaded_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    return DocumentModel.fromJson(response);
  }
}
