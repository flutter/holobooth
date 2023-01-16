part of 'convert_bloc.dart';

abstract class ConvertEvent extends Equatable {
  const ConvertEvent();
}

class GenerateVideoRequested extends ConvertEvent {
  const GenerateVideoRequested(this.frames);

  final List<Frame>? frames;

  @override
  List<Object?> get props => [frames];
}
