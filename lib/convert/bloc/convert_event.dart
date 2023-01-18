part of 'convert_bloc.dart';

abstract class ConvertEvent extends Equatable {
  const ConvertEvent();
}

class ProcessFramesRequested extends ConvertEvent {
  const ProcessFramesRequested({required this.frames});

  final List<Frame> frames;

  @override
  List<Object?> get props => [frames];
}

class ShareRequested extends ConvertEvent {
  const ShareRequested();

  @override
  List<Object> get props => [];
}
