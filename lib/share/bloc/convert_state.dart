part of 'convert_bloc.dart';

abstract class ConvertState extends Equatable {
  const ConvertState();

  @override
  List<Object> get props => [];
}

class ConvertInitial extends ConvertState {}

class ConvertLoading extends ConvertState {}

class ConvertSuccess extends ConvertState {
  const ConvertSuccess({
    required this.videoPath,
    required this.gifPath,
  });

  final String videoPath;
  final String gifPath;

  @override
  List<Object> get props => [videoPath, gifPath];
}

class ConvertError extends ConvertState {}
