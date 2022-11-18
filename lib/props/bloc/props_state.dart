part of 'props_bloc.dart';

enum Prop {
  helmet,
}

class PropsState extends Equatable {
  const PropsState({this.selectedProps = const []});

  final List<Prop> selectedProps;

  @override
  List<Object> get props => [selectedProps];

  PropsState copyWith({
    List<Prop>? selectedProps,
  }) {
    return PropsState(
      selectedProps: selectedProps ?? this.selectedProps,
    );
  }
}
