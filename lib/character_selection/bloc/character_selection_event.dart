part of 'character_selection_bloc.dart';

abstract class CharacterSelectionEvent extends Equatable {
  const CharacterSelectionEvent();
}

class CharacterSelectionSelected extends CharacterSelectionEvent {
  const CharacterSelectionSelected(this.character);

  final Character character;

  @override
  List<Object> get props => [character];
}
