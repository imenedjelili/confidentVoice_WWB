// lib/models/States/profile_state.dart
class ProfileState {
  final String name;
  final String email;
  final bool isLoading;
  final String? phone;
  final String? bio;
  final String profileImage;

  ProfileState({
    required this.name,
    required this.email,
    required this.isLoading,
    this.phone,
    this.bio,
    this.profileImage = "assets/images/profile.png",
  });

  factory ProfileState.initial() {
    return ProfileState(
      name: 'John Doe',
      email: 'john.doe@example.com',
      isLoading: true,
      profileImage: "assets/images/profile.png",
    );
  }

  ProfileState copyWith({
    String? name,
    String? email,
    bool? isLoading,
    String? phone,
    String? bio,
    String? profileImage,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
