part of 'convert_bloc.dart';

class ConvertState extends Equatable {
  const ConvertState({
    this.frames = const [],
    this.videoPath = '',
    this.gifPath = '',
    this.isFinished = false,
    this.status = ConvertStatus.initial,
  });

  final List<RawFrame> frames;
  final String videoPath;
  final String gifPath;
  final bool isFinished;
  final ConvertStatus status;

  ConvertState copyWith({
    List<RawFrame>? frames,
    String? videoPath,
    String? gifPath,
    bool? isFinished,
    ConvertStatus? status,
  }) {
    return ConvertState(
      frames: frames ?? this.frames,
      videoPath: videoPath ?? this.videoPath,
      gifPath: gifPath ?? this.gifPath,
      isFinished: isFinished ?? this.isFinished,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        frames,
        videoPath,
        gifPath,
        isFinished,
        status,
      ];
}

enum ConvertStatus { initial, loading, success, error }
