part of 'drawer_selection_bloc.dart';

class DrawerSelectionState extends Equatable {
  const DrawerSelectionState({this.drawerOption});

  final DrawerOption? drawerOption;

  @override
  List<Object?> get props => [drawerOption];

  DrawerSelectionState copyWith({
    DrawerOption? drawerOption,
  }) {
    return DrawerSelectionState(
      drawerOption: drawerOption ?? this.drawerOption,
    );
  }
}
