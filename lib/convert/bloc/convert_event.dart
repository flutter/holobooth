part of 'convert_bloc.dart';

abstract class ConvertEvent extends Equatable {
  const ConvertEvent();
}

class GenerateVideoRequested extends ConvertEvent {
  const GenerateVideoRequested();

  @override
  List<Object?> get props => [];
}

class GenerateFramesRequested extends ConvertEvent {
  const GenerateFramesRequested();

  @override
  List<Object?> get props => [];
}

class ShareRequested extends ConvertEvent {
  const ShareRequested(this.shareType);

  final ShareType shareType;

  @override
  List<Object> get props => [shareType];
}
