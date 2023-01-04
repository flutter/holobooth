part of 'convert_bloc.dart';

class ConvertState extends Equatable {
  const ConvertState({
    this.videoPath = '',
    this.gifPath = '',
    this.isFinished = false,
    this.status = ConvertStatus.loadingFrames,
    this.framesProcessed = 0,
    this.firstFrame,
  });

  final String videoPath;
  final String gifPath;
  final bool isFinished;
  final ConvertStatus status;
  final int framesProcessed;
  final ByteData? firstFrame;

  ConvertState copyWith({
    String? videoPath,
    String? gifPath,
    bool? isFinished,
    ConvertStatus? status,
    int? framesProcessed,
    ByteData? firstFrame,
  }) {
    return ConvertState(
      videoPath: videoPath ?? this.videoPath,
      gifPath: gifPath ?? this.gifPath,
      isFinished: isFinished ?? this.isFinished,
      status: status ?? this.status,
      framesProcessed: framesProcessed ?? this.framesProcessed,
      firstFrame: firstFrame ?? this.firstFrame,
    );
  }

  @override
  List<Object?> get props => [
        videoPath,
        gifPath,
        isFinished,
        status,
        framesProcessed,
        firstFrame,
      ];
}

enum ConvertStatus { loadingFrames, loadingVideo, success, error }
