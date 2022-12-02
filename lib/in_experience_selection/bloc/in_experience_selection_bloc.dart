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
    on<InExperienceSelectionPropSelected>(_propSelected);
    on<InExperienceSelectionBackgroundSelected>(_backgroundSelected);
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
          selectedProps: state.selectedProps,
        ),
      );
    }
  }

  FutureOr<void> _propSelected(
    InExperienceSelectionPropSelected event,
    Emitter<InExperienceSelectionState> emit,
  ) {
    final selected = event.prop;
    final selectedProps = List<Prop>.from(state.selectedProps);
    if (selectedProps.contains(selected)) {
      selectedProps.remove(selected);
    } else {
      selectedProps.add(selected);
    }
    emit(
      state.copyWith(
        selectedProps: selectedProps,
      ),
    );
  }

  FutureOr<void> _backgroundSelected(
    InExperienceSelectionBackgroundSelected event,
    Emitter<InExperienceSelectionState> emit,
  ) {
    emit(state.copyWith(background: event.background));
  }
}
