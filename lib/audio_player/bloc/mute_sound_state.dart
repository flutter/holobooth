part of 'mute_sound_bloc.dart';

class MuteSoundState extends Equatable {
  const MuteSoundState({required this.isMuted});

  final bool isMuted;

  @override
  List<Object> get props => [isMuted];
}
