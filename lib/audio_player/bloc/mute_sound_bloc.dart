import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'mute_sound_event.dart';
part 'mute_sound_state.dart';

class MuteSoundBloc extends Bloc<MuteSoundEvent, MuteSoundState> {
  MuteSoundBloc() : super(const MuteSoundState(isMuted: false)) {
    on<MuteSoundToggled>(
      (event, emit) {
        emit(MuteSoundState(isMuted: !state.isMuted));
      },
    );
  }
}
