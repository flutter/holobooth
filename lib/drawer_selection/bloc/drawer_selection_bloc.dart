import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/drawer_selection/drawer_selection.dart';

part 'drawer_selection_event.dart';
part 'drawer_selection_state.dart';

class DrawerSelectionBloc
    extends Bloc<DrawerSelectionEvent, DrawerSelectionState> {
  DrawerSelectionBloc() : super(const DrawerSelectionState()) {
    on<DrawerSelectionOptionSelected>(_optionSelected);
    on<DrawerSelectionUnselected>(_unselected);
  }

  FutureOr<void> _optionSelected(
    DrawerSelectionOptionSelected event,
    Emitter<DrawerSelectionState> emit,
  ) {
    emit(state.copyWith(drawerOption: event.drawerOption));
  }

  FutureOr<void> _unselected(
    DrawerSelectionUnselected event,
    Emitter<DrawerSelectionState> emit,
  ) {
    emit(const DrawerSelectionState());
  }
}
