part of 'convert_bloc.dart';

abstract class ConvertState extends Equatable {
  const ConvertState();

  @override
  List<Object> get props => [];
}

class ConvertInitial extends ConvertState {}

class ConvertLoading extends ConvertState {}

class ConvertSuccess extends ConvertState {
  const ConvertSuccess(this.videoPath);

  final String videoPath;

  @override
  List<Object> get props => [videoPath];
}

class ConvertError extends ConvertState {}
