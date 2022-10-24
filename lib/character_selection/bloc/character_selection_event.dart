part of 'character_selection_bloc.dart';

abstract class CharacterSelectionEvent extends Equatable {
  const CharacterSelectionEvent();
}

class CharacterSelected extends CharacterSelectionEvent {
  const CharacterSelected(this.character);

  final Character character;

  @override
  List<Object> get props => [character];
}
