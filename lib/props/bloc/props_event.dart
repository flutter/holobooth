part of 'props_bloc.dart';

abstract class PropsEvent extends Equatable {
  const PropsEvent();
}

class PropsSelected extends PropsEvent {
  const PropsSelected(this.prop);

  final Prop prop;

  @override
  List<Object> get props => [prop];
}
