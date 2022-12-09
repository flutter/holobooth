import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';

part '../../in_experience_selection/bloc/in_experience_selection_event.dart';
part '../../in_experience_selection/bloc/in_experience_selection_state.dart';

class InExperienceSelectionBloc
    extends Bloc<InExperienceSelectionEvent, InExperienceSelectionState> {
  InExperienceSelectionBloc({required Character characterPreSelected})
      : super(InExperienceSelectionState(character: characterPreSelected)) {
    on<InExperienceSelectionOptionSelected>(_optionSelected);
    on<InExperienceSelectionHatSelected>(_hatSelected);
    on<InExperienceSelectionBackgroundSelected>(_backgroundSelected);
    on<InExperienceSelectionCharacterSelected>(_characterSelected);
  }

  FutureOr<void> _optionSelected(
    InExperienceSelectionOptionSelected event,
    Emitter<InExperienceSelectionState> emit,
  ) {
    if (event.drawerOption != null) {
      emit(state.copyWith(drawerOption: event.drawerOption));
    } else {
      emit(
        InExperienceSelectionState(
          background: state.background,
          character: state.character,
          selectedHat: state.selectedHat,
        ),
      );
    }
  }

  FutureOr<void> _hatSelected(
    InExperienceSelectionHatSelected event,
    Emitter<InExperienceSelectionState> emit,
  ) {
    if (event.hat == state.selectedHat) {
      emit(state.copyWith(selectedHat: Hats.none));
    } else {
      emit(state.copyWith(selectedHat: event.hat));
    }
  }

  FutureOr<void> _backgroundSelected(
    InExperienceSelectionBackgroundSelected event,
    Emitter<InExperienceSelectionState> emit,
  ) {
    emit(state.copyWith(background: event.background));
  }

  FutureOr<void> _characterSelected(
    InExperienceSelectionCharacterSelected event,
    Emitter<InExperienceSelectionState> emit,
  ) {
    emit(state.copyWith(character: event.character));
  }
}
