class RecordedData {
  final int? id;
  final String userId;
  final String recordingPath;
  final String createdAt;

  RecordedData({
    this.id, 
    required this.userId,
    required this.recordingPath,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'recording_path': recordingPath,
      'created_at': createdAt,
    };
  }

  static RecordedData fromMap(Map<String, dynamic> map) {
    return RecordedData(
      id: map['id'],
      userId: map['user_id'],
      recordingPath: map['recording_path'],
      createdAt: map['created_at'],
    );
  }
}
