import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';

part '../../in_experience_selection/bloc/in_experience_selection_event.dart';
part '../../in_experience_selection/bloc/in_experience_selection_state.dart';

class InExperienceSelectionBloc
    extends Bloc<InExperienceSelectionEvent, InExperienceSelectionState> {
  InExperienceSelectionBloc() : super(const InExperienceSelectionState()) {
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
    if (event.hat == state.hat) {
      emit(state.copyWith(hat: Hats.none));
    } else {
      emit(state.copyWith(hat: event.hat));
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
    if (event.glasses == state.glasses) {
      emit(state.copyWith(glasses: Glasses.none));
    } else {
      emit(state.copyWith(glasses: event.glasses));
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
