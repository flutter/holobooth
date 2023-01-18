import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/in_experience_selection/in_experience_selection.dart';

part '../../in_experience_selection/bloc/in_experience_selection_event.dart';
part '../../in_experience_selection/bloc/in_experience_selection_state.dart';

class InExperienceSelectionBloc
    extends Bloc<InExperienceSelectionEvent, InExperienceSelectionState> {
  InExperienceSelectionBloc() : super(const InExperienceSelectionState()) {
    on<InExperienceSelectionHatToggled>(_hatToggled);
    on<InExperienceSelectionBackgroundSelected>(_backgroundSelected);
    on<InExperienceSelectionCharacterSelected>(_characterSelected);
    on<InExperienceSelectionGlassesToggled>(_glassesToggled);
    on<InExperienceSelectionClothesToggled>(_clothesToggled);
    on<InExperienceSelectionHandleheldLeftToggled>(_handleheldLeftToggled);
  }

  FutureOr<void> _hatToggled(
    InExperienceSelectionHatToggled event,
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

  FutureOr<void> _glassesToggled(
    InExperienceSelectionGlassesToggled event,
    Emitter<InExperienceSelectionState> emit,
  ) {
    if (event.glasses == state.glasses) {
      emit(state.copyWith(glasses: Glasses.none));
    } else {
      emit(state.copyWith(glasses: event.glasses));
    }
  }

  FutureOr<void> _clothesToggled(
    InExperienceSelectionClothesToggled event,
    Emitter<InExperienceSelectionState> emit,
  ) {
    if (event.clothes == state.clothes) {
      emit(state.copyWith(clothes: Clothes.none));
    } else {
      emit(state.copyWith(clothes: event.clothes));
    }
  }

  FutureOr<void> _handleheldLeftToggled(
    InExperienceSelectionHandleheldLeftToggled event,
    Emitter<InExperienceSelectionState> emit,
  ) {
    if (event.handheldlLeft == state.handheldlLeft) {
      emit(state.copyWith(handheldlLeft: HandheldlLeft.none));
    } else {
      emit(state.copyWith(handheldlLeft: event.handheldlLeft));
    }
  }
}
