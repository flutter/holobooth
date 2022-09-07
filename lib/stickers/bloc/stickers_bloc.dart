import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'stickers_event.dart';
part 'stickers_state.dart';

class StickersBloc extends Bloc<StickersEvent, StickersState> {
  StickersBloc() : super(const StickersState()) {
    on<StickersDrawerToggled>(_onDrawerToggled);
    on<StickersDrawerTabTapped>(_onDrawerTabTapped);
  }

  void _onDrawerToggled(StickersDrawerToggled event, Emitter emit) {
    emit(
      state.copyWith(
        isDrawerActive: !state.isDrawerActive,
        shouldDisplayPropsReminder: false,
      ),
    );
  }

  void _onDrawerTabTapped(StickersDrawerTabTapped event, Emitter emit) {
    emit(
      state.copyWith(tabIndex: event.index),
    );
  }
}
