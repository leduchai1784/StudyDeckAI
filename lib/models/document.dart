class DocumentModel {
  final String id;
  final String userId;
  final String fileName;
  final String filePath;
  final String fileType; // pdf, docx
  final int? fileSize;
  final String status; // processing, ready, failed
  final DateTime? uploadedAt;

  DocumentModel({
    required this.id,
    required this.userId,
    required this.fileName,
    required this.filePath,
    required this.fileType,
    this.fileSize,
    this.status = 'processing',
    this.uploadedAt,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fileName: json['file_name'] as String,
      filePath: json['file_path'] as String,
      fileType: json['file_type'] as String,
      fileSize: json['file_size'] as int?,
      status: json['status'] as String? ?? 'processing',
      uploadedAt: json['uploaded_at'] != null ? DateTime.parse(json['uploaded_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'file_name': fileName,
      'file_path': filePath,
      'file_type': fileType,
      'file_size': fileSize,
      'status': status,
      'uploaded_at': uploadedAt?.toIso8601String(),
    };
  }
}
