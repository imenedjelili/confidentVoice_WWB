class Setting {
  final int id;
  final int userId;
  final String? theme;
  final String? language;
  final bool? notificationsEnabled;
  final String? privacyPolicy;

  const Setting({
    required this.id,
    required this.userId,
    this.theme,
    this.language,
    this.notificationsEnabled,
    this.privacyPolicy,
  });

  factory Setting.fromMap(Map<String, dynamic> map) {
    return Setting(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      theme: map['theme'] as String?,
      language: map['language'] as String?,
      notificationsEnabled: map['notifications_enabled'] as bool?,
      privacyPolicy: map['privacy_policy'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'theme': theme,
      'language': language,
      'notifications_enabled': notificationsEnabled,
      'privacy_policy': privacyPolicy,
    };
  }

  @override
  String toString() {
    return 'Setting{id: $id, userId: $userId, theme: $theme, language: $language, notificationsEnabled: $notificationsEnabled, privacyPolicy: $privacyPolicy}';
  }
}
