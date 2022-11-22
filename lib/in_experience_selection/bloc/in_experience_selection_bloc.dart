import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:io_photobooth/in_experience_selection/drawer_option/drawer_option.dart';

part 'in_experience_selection_event.dart';
part 'in_experience_selection_state.dart';

class InExperienceSelectionBloc
    extends Bloc<InExperienceSelectionEvent, InExperienceSelectionState> {
  InExperienceSelectionBloc() : super(const InExperienceSelectionState()) {
    on<InExperienceSelectionOptionSelected>(_optionSelected);
    on<InExperienceSelectionPropSelected>(_propSelected);
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

  FutureOr<void> _optionSelected(
    InExperienceSelectionOptionSelected event,
    Emitter<InExperienceSelectionState> emit,
  ) {
    emit(
      InExperienceSelectionState(
        selectedProps: state.selectedProps,
        background: state.background,
        drawerOption: event.drawerOption,
      ),
    );
  }
}
