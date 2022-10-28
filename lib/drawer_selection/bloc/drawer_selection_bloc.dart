import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'drawer_selection_event.dart';
part 'drawer_selection_state.dart';

class DrawerSelectionBloc
    extends Bloc<DrawerSelectionEvent, DrawerSelectionState> {
  DrawerSelectionBloc() : super(const DrawerSelectionState()) {
    on<DrawerSelectionEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
