// lib/Controllers/profile_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confident_voice/models/Events/profile_event.dart';
import 'package:confident_voice/models/States/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState.initial()) {
    on<InitializeProfileEvent>(_onInitialize);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  void _onInitialize(InitializeProfileEvent event, Emitter<ProfileState> emit) {
    emit(state.copyWith(
      name: 'John Doe',
      email: 'john.doe@example.com',
      isLoading: false,
    ));
  }

  void _onUpdateProfile(UpdateProfileEvent event, Emitter<ProfileState> emit) {
    emit(state.copyWith(
      name: event.name,
      email: event.email,
      phone: event.phone,
      bio: event.bio,
    ));
  }
}
