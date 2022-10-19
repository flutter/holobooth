import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'character_selection_event.dart';
part 'character_selection_state.dart';

class CharacterSelectionBloc extends Bloc<CharacterSelectionEvent, Character> {
  CharacterSelectionBloc() : super(Character.dash) {
    on<CharacterSelected>(_onCharacterSelected);
  }

  void _onCharacterSelected(CharacterSelected event, Emitter<Character> emit) {
    emit(event.character);
  }
}
