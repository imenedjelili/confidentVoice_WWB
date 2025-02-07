class Slide {
  final String id;
  final String title;
  final String? description;
  final String url;
  final String category;
  final String uploadedBy;
  final DateTime uploadedAt;

  Slide({
    required this.id,
    required this.title,
    this.description,
    required this.url,
    required this.category,
    required this.uploadedBy,
    required this.uploadedAt,
  });

  factory Slide.fromJson(Map<String, dynamic> json) {
    return Slide(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      url: json['url'] as String,
      category: json['category'] as String,
      uploadedBy: json['uploaded_by'] as String,
      uploadedAt: DateTime.parse(json['uploaded_at'] as String),
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
      'uploaded_at': uploadedAt.toIso8601String(),
    };
  }
}
