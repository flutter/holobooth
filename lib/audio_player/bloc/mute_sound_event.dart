part of 'mute_sound_bloc.dart';

abstract class MuteSoundEvent extends Equatable {
  const MuteSoundEvent();

  @override
  List<Object> get props => [];
}

class MuteSoundToggled extends MuteSoundEvent {}
