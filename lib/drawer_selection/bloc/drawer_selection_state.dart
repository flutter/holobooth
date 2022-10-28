part of 'drawer_selection_bloc.dart';

enum DrawerSelectionStatus {
  shouldOpenProps,
  shouldOpenBackgrounds,
  shouldOpenCharacters,
}

class DrawerSelectionState extends Equatable {
  const DrawerSelectionState({this.drawerSelectionStatus});

  final DrawerSelectionStatus? drawerSelectionStatus;

  @override
  List<Object?> get props => [drawerSelectionStatus];
}
