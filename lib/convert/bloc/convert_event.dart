part of 'convert_bloc.dart';

abstract class ConvertEvent extends Equatable {
  const ConvertEvent();

  @override
  List<Object> get props => [];
}

class ConvertFrames extends ConvertEvent {
  const ConvertFrames(this.frames);

  final List<Frame> frames;

  @override
  List<Object> get props => [frames];
}

class GenerateVideo extends ConvertEvent {
  const GenerateVideo();
}

class FinishConvert extends ConvertEvent {
  const FinishConvert();
}
