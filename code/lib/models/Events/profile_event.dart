// lib/models/Events/profile_event.dart
abstract class ProfileEvent {}

class InitializeProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String name;
  final String email;
  final String? phone;
  final String? bio;

  UpdateProfileEvent({
    required this.name,
    required this.email,
    this.phone,
    this.bio,
  });
}
