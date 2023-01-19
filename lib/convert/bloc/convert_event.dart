part of 'convert_bloc.dart';

abstract class ConvertEvent extends Equatable {
  const ConvertEvent();
}

class GenerateVideoRequested extends ConvertEvent {
  const GenerateVideoRequested({required this.frames});

  final List<Frame> frames;

  @override
  List<Object?> get props => [frames];
}

class ShareRequested extends ConvertEvent {
  const ShareRequested(this.shareType);

  final ShareType shareType;

  @override
  List<Object> get props => [shareType];
}
