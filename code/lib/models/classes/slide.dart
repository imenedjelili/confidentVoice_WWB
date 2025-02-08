import 'package:cloud_firestore/cloud_firestore.dart';

class Slide {
  final String id;
  final String title;
  final String? description;
  final String url;
  final String category;
  final String uploadedBy;
  final String uploaderName;
  final DateTime uploadedAt;
  final String type;
  final int? size;
  final Map<String, dynamic>? metadata;

  Slide({
    required this.id,
    required this.title,
    this.description,
    required this.url,
    required this.category,
    required this.uploadedBy,
    required this.uploaderName,
    required this.uploadedAt,
    required this.type,
    this.size,
    this.metadata,
  });

  factory Slide.fromJson(Map<String, dynamic> json) {
    return Slide(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      url: json['url'] as String,
      category: json['category'] as String,
      uploadedBy: json['uploaded_by'] as String,
      uploaderName: json['uploader_name'] as String? ?? 'Unknown User',
      uploadedAt: (json['uploaded_at'] as Timestamp).toDate(),
      type: json['type'] as String? ?? 'unknown',
      size: json['size'] as int?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'category': category,
      'uploaded_by': uploadedBy,
      'uploader_name': uploaderName,
      'uploaded_at': uploadedAt.toIso8601String(),
      'type': type,
      'size': size,
      'metadata': metadata,
    };
  }
}
