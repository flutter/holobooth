part of 'convert_bloc.dart';

abstract class ConvertEvent extends Equatable {
  const ConvertEvent();
}

class GenerateVideo extends ConvertEvent {
  const GenerateVideo(this.frames);

  final List<Frame> frames;

  @override
  List<Object> get props => [frames];
}
