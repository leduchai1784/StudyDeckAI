class DocumentChunkModel {
  final String id;
  final String documentId;
  final int chunkIndex;
  final String chunkText;
  final List<double>? embedding; // Vector embedding (pgvector)
  final DateTime? createdAt;

  DocumentChunkModel({
    required this.id,
    required this.documentId,
    required this.chunkIndex,
    required this.chunkText,
    this.embedding,
    this.createdAt,
  });

  factory DocumentChunkModel.fromJson(Map<String, dynamic> json) {
    return DocumentChunkModel(
      id: json['id'] as String,
      documentId: json['document_id'] as String,
      chunkIndex: json['chunk_index'] as int,
      chunkText: json['chunk_text'] as String,
      embedding: json['embedding'] != null
          ? (json['embedding'] as List).map((e) => (e as num).toDouble()).toList()
          : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'document_id': documentId,
      'chunk_index': chunkIndex,
      'chunk_text': chunkText,
      'embedding': embedding,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
