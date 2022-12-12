import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';

part 'character_selection_event.dart';

class CharacterSelectionBloc extends Bloc<CharacterSelectionEvent, Character> {
  CharacterSelectionBloc() : super(Character.dash) {
    on<CharacterSelectionSelected>(_onSelected);
  }

  void _onSelected(CharacterSelectionSelected event, Emitter<Character> emit) {
    emit(event.character);
  }
}
