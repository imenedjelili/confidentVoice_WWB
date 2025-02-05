class RecordedData {
  final int id;
  final int userId;
  final String recordingPath;
  final String createdAt;

  const RecordedData({
    required this.id,
    required this.userId,
    required this.recordingPath,
    required this.createdAt,
  });

  factory RecordedData.fromMap(Map<String, dynamic> map) {
    return RecordedData(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      recordingPath: map['recording_path'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'recording_path': recordingPath,
      'created_at': createdAt,
    };
  }

  @override
  String toString() {
    return 'RecordedData{id: $id, userId: $userId, recordingPath: $recordingPath, createdAt: $createdAt}';
  }
}
