part of 'drawer_selection_bloc.dart';

abstract class DrawerSelectionEvent extends Equatable {
  const DrawerSelectionEvent();

  @override
  List<Object> get props => [];
}

enum DrawerOption { props, backgrounds, character }

class DrawerSelectionOptionSelected extends DrawerSelectionEvent {
  const DrawerSelectionOptionSelected(this.drawerOption);

  final DrawerOption drawerOption;

  @override
  List<Object> get props => [drawerOption];
}
