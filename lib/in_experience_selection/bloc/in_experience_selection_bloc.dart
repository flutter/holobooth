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
    on<InExperienceSelectionHatSelected>(_hatSelected);
    on<InExperienceSelectionBackgroundSelected>(_backgroundSelected);
    on<InExperienceSelectionCharacterSelected>(_characterSelected);
    on<InExperienceSelectionGlassesSelected>(_glassesSelected);
    on<InExperienceSelectionClothesSelected>(_clothesSelected);
    on<InExperienceSelectionHandleheldLeftSelected>(_handleheldLeftSelected);
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

  FutureOr<void> _glassesSelected(
    InExperienceSelectionGlassesSelected event,
    Emitter<InExperienceSelectionState> emit,
  ) {
    if (event.glasses == state.selectedGlasses) {
      emit(state.copyWith(selectedGlasses: Glasses.none));
    } else {
      emit(state.copyWith(selectedGlasses: event.glasses));
    }
  }

  FutureOr<void> _clothesSelected(
    InExperienceSelectionClothesSelected event,
    Emitter<InExperienceSelectionState> emit,
  ) {
    if (event.clothes == state.clothes) {
      emit(state.copyWith(clothes: Clothes.none));
    } else {
      emit(state.copyWith(clothes: event.clothes));
    }
  }

  FutureOr<void> _handleheldLeftSelected(
    InExperienceSelectionHandleheldLeftSelected event,
    Emitter<InExperienceSelectionState> emit,
  ) {
    if (event.handheldlLeft == state.handheldlLeft) {
      emit(state.copyWith(handheldlLeft: HandheldlLeft.none));
    } else {
      emit(state.copyWith(handheldlLeft: event.handheldlLeft));
    }
  }
}
