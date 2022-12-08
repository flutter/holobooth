part of 'convert_bloc.dart';

abstract class ConvertEvent extends Equatable {
  const ConvertEvent();

  @override
  List<Object> get props => [];
}

class ConvertFrames extends ConvertEvent {
  const ConvertFrames(this.frames);

  final List<RawFrame> frames;

  @override
  List<Object> get props => [frames];
}
