part of 'drawer_selection_bloc.dart';

abstract class DrawerSelectionEvent extends Equatable {
  const DrawerSelectionEvent();
}

class DrawerSelectionOptionSelected extends DrawerSelectionEvent {
  const DrawerSelectionOptionSelected({required this.drawerOption});

  final DrawerOption drawerOption;

  @override
  List<Object> get props => [drawerOption];
}
