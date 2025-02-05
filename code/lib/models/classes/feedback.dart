class Feedback {
  final int id;
  final int userId;
  final String? comments;
  final int? rating;
  final String createdAt;

  const Feedback({
    required this.id,
    required this.userId,
    this.comments,
    this.rating,
    required this.createdAt,
  });

  factory Feedback.fromMap(Map<String, dynamic> map) {
    return Feedback(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      comments: map['comments'] as String?,
      rating: map['rating'] as int?,
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'comments': comments,
      'rating': rating,
      'created_at': createdAt,
    };
  }

  @override
  String toString() {
    return 'Feedback{id: $id, userId: $userId, comments: $comments, rating: $rating, createdAt: $createdAt}';
  }
}
