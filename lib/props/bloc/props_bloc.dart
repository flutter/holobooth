import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'props_event.dart';
part 'props_state.dart';

class PropsBloc extends Bloc<PropsEvent, PropsState> {
  PropsBloc() : super(const PropsState()) {
    on<PropsSelected>(_selected);
  }

  FutureOr<void> _selected(PropsSelected event, Emitter<PropsState> emit) {
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
}
